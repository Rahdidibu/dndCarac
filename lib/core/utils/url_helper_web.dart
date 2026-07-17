// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void openUrlImpl(String url) {
  js.context.callMethod('open', [url]);
}
