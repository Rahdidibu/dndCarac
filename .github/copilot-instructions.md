# Contexte du projet

## Application et architecture

- « Le Codex de l'Aventurier » est une application Flutter Web/Android de gestion
  de personnages D&D 5e (2014/2024), avec un univers Batman, une Forge et des
  exports PDF. Le package Dart est `dnd_character_manager`.
- [lib/main.dart](../lib/main.dart) initialise Supabase depuis les constantes de
  compilation, ouvre Drift, peuple les compendiums SRD/Batman puis injecte la base
  dans Riverpod. Navigation par routes nommees et `MainScaffold`.
- Organisation feature-first : [lib/features/](../lib/features/) contient les
  ecrans, widgets et providers metier; [lib/core/](../lib/core/) contient les
  services partages, regles D&D, theme, base et seeders.
- Riverpod 2.x : le code existant utilise surtout des providers manuels.
  La [skill Flutter](../.agents/skills/flutter-clean-refactor/SKILL.md) recommande
  la generation `@riverpod` pour les refactorings; ne pas entreprendre une
  migration globale hors demande.

## Donnees et configuration

- Drift : [AppDatabase](../lib/core/database/app_database.dart), schema version 4,
  tables et DAOs dans `lib/core/database/`. Les donnees de reference viennent de
  [assets/data/](../assets/data/). Toute evolution de schema doit inclure sa
  migration et la regeneration des fichiers associes.
- Sur Web, Drift charge [sqlite3.wasm](../web/sqlite3.wasm) et
  [drift_worker.js](../web/drift_worker.js). Conserver leur compatibilite avec les
  versions verrouillees de Drift/sqlite3.
- Supabase assure l'authentification et des lectures/ecritures de personnages,
  dont des streams Realtime. Ne pas supposer une replication generale
  Drift/Supabase : verifier chaque parcours dans ses providers et DAOs.
  [supabase/migrations/](../supabase/migrations/) contient le schema distant,
  les politiques RLS et la configuration Realtime.
- Le fichier `.env` racine doit contenir `SUPABASE_URL` et `SUPABASE_ANON_KEY`
  (cle publique/publishable ou anon, jamais `service_role`). Flutter ne le charge
  que via `--dart-define-from-file=.env`; voir [.env.template](../.env.template).
  Sans session, la racine affiche l'authentification : le backend n'est pas
  facultatif pour tester le parcours complet actuel.

## Conventions et surfaces liees

- Textes d'interface dans [lib/l10n/](../lib/l10n/), sources `app_fr.arb` et
  `app_en.arb`, acces par `AppLocalizations`. Theme sombre centralise dans
  [app_theme.dart](../lib/core/theme/app_theme.dart).
- Garder les widgets declaratifs et les operations metier dans les providers.
  Verifier D&D 2014/2024 et Batman quand une regle ou un composant partage change.
- Ne pas modifier manuellement les fichiers generes Drift/localisation ni
  [deploy/web/](../deploy/web/) : modifier les sources et reconstruire.
- [release.yml](workflows/release.yml) construit APK et Web sur les tags `v*`;
  [deploy/](../deploy/) contient les scripts et la configuration Nginx.

## Developpement et verification

- Voir le [README](../README.md) pour le parcours devcontainer avec Supabase
  heberge. Le conteneur cible Web et les tests, pas un environnement Android
  complet. Les versions Flutter/Supabase CLI sont fixees dans son Dockerfile;
  le SDK doit aussi satisfaire les contraintes de [pubspec.lock](../pubspec.lock).
- Installation : `flutter pub get --enforce-lockfile`.
- Localisation : `flutter gen-l10n`.
- Apres modification des definitions generees :
  `dart run build_runner build --delete-conflicting-outputs`.
- Verification : `flutter analyze` et `flutter test`; cibler les tests pertinents
  lorsque possible. [test/](../test/) couvre les regles, l'etat du wizard et un
  widget du wizard; ne pas en deduire une couverture de Supabase/auth/PDF.
- Web dans le conteneur :
  `flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8035 --dart-define-from-file=.env`.
  Chrome tourne sur l'hote; `flutter run -d chrome` suppose un Chrome disponible
  dans l'environnement Flutter.
- Mettre ce contexte a jour lorsque l'architecture ou le parcours local evolue.
