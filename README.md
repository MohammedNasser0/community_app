# ConnectMe Community App — V1.0

ConnectMe is an end-to-end Flutter community application built for the capstone assignment from Omar Khalil. It combines Firebase authentication, Firestore real-time posts, biometric profile protection, device information, gallery profile images, Google Maps markers, Clean Architecture, GetIt dependency injection, and a beta-release workflow through Firebase App Distribution.

The UI is intentionally inspired by the **Social App — Free UI Kit (30 Screens)** by Bruno: purple/indigo primary branding, rounded cards, clean white surfaces, profile-centric navigation, compact social feed cards, and a bottom navigation pattern. The reference is used as a visual direction rather than copied as a pixel-perfect screen set.

## Features

- Firebase Email/Password Login and Sign Up.
- Validation for full name, email, password, and confirmation password.
- Persistent Firebase auth session through FirebaseAuth.
- Real-time Firestore community feed.
- Create and publish posts from the floating action button.
- Local SharedPreferences post cache with remote Firestore fallback strategy.
- Biometric gate before opening the profile.
- Device model and OS information through `device_info_plus`.
- Profile photo selection from the device gallery using `image_picker`.
- Compressed profile images stored directly in Firestore as Base64 for a billing-safe V1 (no Firebase Storage dependency).
- Community Map with three hardcoded members in Cairo, Riyadh, and London.
- Google Maps marker info windows.
- Clean Architecture: Data / Domain / Presentation.
- Builder Pattern for User creation.
- Factory Pattern for Post repository source selection.
- Singleton Pattern for the Firestore service.
- GetIt dependency injection.
- User-friendly Firebase/network errors.
- Responsive layouts using `MediaQuery` / `LayoutBuilder` where appropriate.

## Architecture

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   └── failures.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── datasources/
│   │   ├── local_post_datasource.dart
│   │   ├── post_remote_datasource.dart
│   │   └── user_remote_datasource.dart
│   ├── models/
│   │   ├── post_model.dart
│   │   └── user_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── post_repository_factory.dart
│       └── post_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── post.dart
│   │   ├── user.dart
│   │   └── user_builder.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   └── post_repository.dart
│   └── usecases/
│       ├── create_post.dart
│       ├── get_posts.dart
│       ├── login.dart
│       ├── sign_up.dart
│       └── update_profile_image.dart
├── presentation/
│   ├── blocs/
│   │   ├── auth_cubit.dart
│   │   ├── auth_state.dart
│   │   ├── post_cubit.dart
│   │   ├── post_state.dart
│   │   ├── profile_cubit.dart
│   │   └── profile_state.dart
│   ├── screens/
│   │   ├── auth_gate.dart
│   │   ├── create_post_screen.dart
│   │   ├── explore_screen.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── map_screen.dart
│   │   ├── profile_screen.dart
│   │   └── sign_up_screen.dart
│   └── widgets/
│       ├── app_bottom_nav.dart
│       ├── auth_text_field.dart
│       ├── member_marker.dart
│       ├── post_card.dart
│       └── profile_avatar.dart
├── services/
│   ├── auth_service.dart
│   ├── biometric_service.dart
│   ├── device_info_service.dart
│   └── firestore_service.dart
├── firebase_options.dart
├── injection.dart
└── main.dart
```

## Design Patterns

### Builder
`UserBuilder` constructs the domain `User` incrementally and only includes optional fields when they are provided. Sign-up currently sets ID, full name, and email; the profile image is added later.

### Factory
`PostRepositoryFactory` selects between a remote Firestore strategy and a local cache strategy through `PostDataSourceType`.

### Singleton
`FirestoreService` uses a private constructor plus a static instance and is registered as a lazy singleton in GetIt. All Firestore data sources use this service.

### SOLID
Business operations are separated into use cases and repository interfaces. The data layer owns Firebase/SharedPreferences implementation details, while Presentation depends on abstractions and Cubits.

## Firebase Setup

The provided project already contains the Firebase Android configuration and generated `firebase_options.dart` for the existing Firebase project.

1. Open Firebase Console for the project.
2. Enable **Authentication → Sign-in method → Email/Password**.
3. Create/enable **Cloud Firestore**.
4. Publish the included `firestore.rules`.
5. In Google Cloud Console, enable **Maps SDK for Android** for the same Google Cloud project. The Android manifest already reads the configured project API key from `google_maps_key`.
6. For iOS, enable **Maps SDK for iOS** if building for iPhone.

The included Firestore rules allow authenticated members to read posts and their own user document, create posts for their own UID, and update their own profile.

## Google Maps

The Android key is referenced through:

```text
android/app/src/main/res/values/strings.xml
```

The iOS AppDelegate also contains the same project key for the iOS Maps SDK. Before release, restrict the key in Google Cloud Console by application/package/bundle ID and API usage.

## Android Permissions

ConnectMe declares only the permissions required by the current implementation:

- `android.permission.INTERNET` — Firebase/Firestore/Google Maps.
- `android.permission.USE_BIOMETRIC` — biometric profile gate.

`image_picker` uses the Android system photo picker/gallery flow; no broad storage permission is manually requested.

## Run

From the project root:

```bash
flutter pub get
flutter clean
flutter pub get
flutter run
```

For a connected Android emulator/device:

```bash
flutter devices
flutter run
```

## Quality Checks

Before submission:

```bash
dart format .
flutter analyze
flutter test
```

Then build the release APK:

```bash
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Firebase App Distribution

Install/authenticate Firebase CLI first, then:

```bash
firebase login
firebase projects:list
```

Build the release APK:

```bash
flutter build apk --release
```

Upload it with Firebase App Distribution:

```bash
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_ANDROID_APP_ID \
  --testers tester1@example.com,tester2@example.com \
  --release-notes "ConnectMe V1.0 beta — capstone delivery"
```

Alternatively, use the Firebase Console App Distribution UI and add at least two tester emails.

### Required evidence to add before final submission

Place the real screenshots generated from the finished app/build in `docs/screenshots/` and update the names below:

| Evidence | File |
|---|---|
| Login | `01-login.png` |
| Sign Up | `02-signup.png` |
| Home Firestore feed | `03-home-feed.png` |
| Biometric prompt | `04-biometric.png` |
| Profile + device information | `05-profile.png` |
| Community Map + open marker | `06-community-map.png` |
| Firebase App Distribution dashboard | `07-app-distribution.png` |
| Tester invitation email | `08-tester-invitation.png` |

These are intentionally not fabricated: the final screenshots must come from the running Firebase-connected app and the actual tester accounts.

## Figma Reference

Reference used for the visual language:

**Social App — Free UI Kit (30 Screens), Bruno, Figma Community.**

The original kit contains 30 mobile social-app screens and is presented as a free editable UI kit. The implementation here adapts its visual language to the ConnectMe assignment requirements.

## GitHub Delivery Checklist

- [ ] Public repository created.
- [ ] Repository name/username follows the assignment's naming expectation.
- [ ] Firebase configuration is connected to the intended project.
- [ ] Firestore rules published.
- [ ] Maps SDK enabled and API key restricted.
- [ ] `dart format .` passes.
- [ ] `flutter analyze` has no warnings/errors.
- [ ] Release APK builds successfully.
- [ ] Firebase App Distribution has at least two testers.
- [ ] Both testers accepted the invitation and installed the build.
- [ ] Eight required screenshots are captured and added to `docs/screenshots/`.
- [ ] README screenshots section updated with the real evidence.

## Implementation verification — 10 October 2026

The supplied Figma overview screenshot guided the diagonal indigo/violet headers, pill inputs and centered create-post navigation. Original photographic assets were not supplied, so the header artwork is drawn with Flutter gradients. This is an adaptation, not a claim of pixel-perfect reproduction.

Fixed the composer route to share its PostCubit, retained the draft after failed publishing, prevented duplicate publish taps, handled unavailable biometrics/gallery errors, recovered corrupt local caches, and registered/injected all five use cases through GetIt.

Three automated tests cover signup constraints, corrupt-cache recovery and post-cache round trips. Real-device biometric, Maps and Firebase integration evidence still requires execution against the intended configured project.

Release currently uses the Android debug signing key for beta testing. Configure a private release keystore before production delivery. GitHub publishing and tester invitation/install evidence have not been completed.
