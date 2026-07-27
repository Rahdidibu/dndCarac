import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Un dialogue interactif de recadrage d'image compatible toutes plateformes (Web, Android, iOS, macOS, Desktop).
class ImageCropperDialog extends StatefulWidget {
  final Uint8List imageBytes;

  const ImageCropperDialog({
    super.key,
    required this.imageBytes,
  });

  /// Affiche le dialogue et retourne les octets (PNG 512x512) de l'image recadrée,
  /// ou null si l'utilisateur annule.
  static Future<Uint8List?> show(BuildContext context, Uint8List imageBytes) {
    return showDialog<Uint8List>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageCropperDialog(imageBytes: imageBytes),
    );
  }

  @override
  State<ImageCropperDialog> createState() => _ImageCropperDialogState();
}

class _ImageCropperDialogState extends State<ImageCropperDialog> {
  ui.Image? _decodedImage;
  bool _isLoading = true;
  bool _isProcessing = false;

  final TransformationController _transformationController = TransformationController();
  int _rotationQuarters = 0; // 0, 1, 2, 3 -> 0°, 90°, 180°, 270°
  bool _isCircularMask = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    try {
      final codec = await ui.instantiateImageCodec(widget.imageBytes);
      final frame = await codec.getNextFrame();
      if (mounted) {
        setState(() {
          _decodedImage = frame.image;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de lire l\'image : $e')),
        );
        Navigator.of(context).pop(null);
      }
    }
  }

  void _rotateRight() {
    setState(() {
      _rotationQuarters = (_rotationQuarters + 1) % 4;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _resetTransform() {
    setState(() {
      _rotationQuarters = 0;
      _transformationController.value = Matrix4.identity();
    });
  }

  Future<void> _cropAndConfirm() async {
    if (_decodedImage == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final croppedBytes = await _renderCroppedImage();
      if (mounted) {
        Navigator.of(context).pop(croppedBytes);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du recadrage : $e')),
        );
      }
    }
  }

  Future<Uint8List> _renderCroppedImage() async {
    const outputSize = 512.0;
    const cropBoxSize = 280.0;

    final imageWidth = _decodedImage!.width.toDouble();
    final imageHeight = _decodedImage!.height.toDouble();

    // Matrice de transformation courante de l'InteractiveViewer
    final transform = _transformationController.value;

    // Dimensions effectives de l'image après rotation
    final isRotated90or270 = _rotationQuarters % 2 != 0;
    final rotatedWidth = isRotated90or270 ? imageHeight : imageWidth;
    final rotatedHeight = isRotated90or270 ? imageWidth : imageHeight;

    // Calcul du ratio d'affichage initial (BoxFit.contain dans le cropBoxSize)
    final initialScale = math.min(
      cropBoxSize / rotatedWidth,
      cropBoxSize / rotatedHeight,
    );

    // Position initiale centrée
    final initialTx = (cropBoxSize - rotatedWidth * initialScale) / 2;
    final initialTy = (cropBoxSize - rotatedHeight * initialScale) / 2;

    // Matrice globale combinée (initiale * utilisateur)
    final userMatrix = transform;
    final initialMatrix = Matrix4.identity()
      ..translate(initialTx, initialTy)
      ..scale(initialScale, initialScale);

    final combinedMatrix = userMatrix * initialMatrix;

    // Inverser la matrice globale pour projeter le cadre de recadrage (0,0 à 280,280) sur les coordonnées de l'image tournée
    final invertedMatrix = Matrix4.inverted(combinedMatrix);

    final p0 = MatrixUtils.transformPoint(invertedMatrix, const Offset(0, 0));
    final p1 = MatrixUtils.transformPoint(invertedMatrix, const Offset(cropBoxSize, cropBoxSize));

    final cropRectRotated = Rect.fromLTRB(
      p0.dx.clamp(0.0, rotatedWidth),
      p0.dy.clamp(0.0, rotatedHeight),
      p1.dx.clamp(0.0, rotatedWidth),
      p1.dy.clamp(0.0, rotatedHeight),
    );

    // Dessiner sur un Canvas 512x512
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, outputSize, outputSize),
    );

    canvas.save();

    // Appliquer la rotation sur le Canvas si nécessaire
    final dstRect = Rect.fromLTWH(0, 0, outputSize, outputSize);

    if (_rotationQuarters != 0) {
      canvas.translate(outputSize / 2, outputSize / 2);
      canvas.rotate(_rotationQuarters * math.pi / 2);
      if (isRotated90or270) {
        canvas.translate(-outputSize / 2, -outputSize / 2);
      } else {
        canvas.translate(-outputSize / 2, -outputSize / 2);
      }
    }

    // Projeter la zone découpée sur la source originale de l'image
    Rect srcRect;
    switch (_rotationQuarters) {
      case 1: // 90°
        srcRect = Rect.fromLTRB(
          cropRectRotated.top,
          imageHeight - cropRectRotated.right,
          cropRectRotated.bottom,
          imageHeight - cropRectRotated.left,
        );
        break;
      case 2: // 180°
        srcRect = Rect.fromLTRB(
          imageWidth - cropRectRotated.right,
          imageHeight - cropRectRotated.bottom,
          imageWidth - cropRectRotated.left,
          imageHeight - cropRectRotated.top,
        );
        break;
      case 3: // 270°
        srcRect = Rect.fromLTRB(
          imageWidth - cropRectRotated.bottom,
          cropRectRotated.left,
          imageWidth - cropRectRotated.top,
          cropRectRotated.right,
        );
        break;
      case 0:
      default:
        srcRect = cropRectRotated;
        break;
    }

    canvas.drawImageRect(
      _decodedImage!,
      srcRect,
      dstRect,
      Paint()..filterQuality = FilterQuality.high,
    );

    canvas.restore();

    final croppedImage = await recorder.endRecording().toImage(
          outputSize.toInt(),
          outputSize.toInt(),
        );

    final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    const cropAreaSize = 280.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(20),
        border: Border.all(
          color: AppTheme.neonCyan.withValues(alpha: 0.3),
          width: 1.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre
            Row(
              children: [
                const Icon(Icons.crop, color: AppTheme.neonCyan),
                const SizedBox(width: 10),
                const Text(
                  'Recadrer la photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    _isCircularMask ? Icons.circle_outlined : Icons.square_outlined,
                    color: AppTheme.neonCyan,
                  ),
                  tooltip: _isCircularMask ? 'Forme ronde' : 'Forme carrée',
                  onPressed: () {
                    setState(() => _isCircularMask = !_isCircularMask);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right, color: AppTheme.neonCyan),
                  tooltip: 'Pivoter à 90°',
                  onPressed: _rotateRight,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  tooltip: 'Réinitialiser',
                  onPressed: _resetTransform,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Zone interactive de recadrage
            if (_isLoading)
              const SizedBox(
                height: cropAreaSize,
                child: Center(
                  child: CircularProgressIndicator(color: AppTheme.neonCyan),
                ),
              )
            else
              Container(
                width: cropAreaSize,
                height: cropAreaSize,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(_isCircularMask ? cropAreaSize / 2 : 16),
                  border: Border.all(color: AppTheme.neonCyan, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.neonCyan.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Image manipulable avec pincement et glisser
                    InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 0.5,
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(cropAreaSize),
                      clipBehavior: Clip.none,
                      child: SizedBox(
                        width: cropAreaSize,
                        height: cropAreaSize,
                        child: Center(
                          child: RotatedBox(
                            quarterTurns: _rotationQuarters,
                            child: RawImage(
                              image: _decodedImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Grille de cadrage semi-transparente
                    IgnorePointer(
                      child: CustomPaint(
                        size: const Size(cropAreaSize, cropAreaSize),
                        painter: GridPainter(isCircular: _isCircularMask),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Instructions d'interaction
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, size: 16, color: Colors.white54),
                SizedBox(width: 6),
                Text(
                  'Glissez & pincez pour ajuster le cadrage',
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.of(context).pop(null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isProcessing ? null : _cropAndConfirm,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.neonCyan,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : const Icon(Icons.check, size: 20),
                    label: Text(
                      _isProcessing ? 'Traitement...' : 'Valider',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Grille visuelle de guidage (règle des tiers & contour)
class GridPainter extends CustomPainter {
  final bool isCircular;

  GridPainter({required this.isCircular});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    // Lignes verticales (règle des tiers)
    canvas.drawLine(Offset(size.width / 3, 0), Offset(size.width / 3, size.height), paintGrid);
    canvas.drawLine(Offset(size.width * 2 / 3, 0), Offset(size.width * 2 / 3, size.height), paintGrid);

    // Lignes horizontales (règle des tiers)
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), paintGrid);
    canvas.drawLine(Offset(0, size.height * 2 / 3), Offset(size.width, size.height * 2 / 3), paintGrid);

    // Contour du masque
    final paintBorder = Paint()
      ..color = AppTheme.neonCyan.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (isCircular) {
      canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paintBorder);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
        paintBorder,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => oldDelegate.isCircular != isCircular;
}
