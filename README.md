# ConnectMe

A Flutter community app for the bootcamp final project. Users can create an account, share posts and view their profile.

## Features

- Login and sign up using Firebase.
- View community posts and add a new post.
- Open the profile using fingerprint or Face ID on supported devices.
- Choose a profile photo from the gallery.
- Show the device model and OS version.
- View three member locations on Google Maps.

## Tools used

Flutter, Firebase Auth, Cloud Firestore, Cubit and GetIt.

The project uses image_picker, local_auth, device_info_plus and google_maps_flutter for the device features.

## Project structure

The code is divided into data, domain and presentation folders. Shared services and helpers are kept in separate folders.

Builder is used to create the user, Factory selects the post data source, and Singleton is used for the Firestore service.

## Run the app

```bash
flutter pub get
flutter run
```

For your own Firebase project, update the Firebase configuration, enable Email/Password login and Firestore, and apply the rules in firestore.rules. Google Maps also needs a valid API key with the Maps SDK enabled.

## Permissions

The app uses internet access and biometric authentication. The profile photo is selected through the system photo picker. On iOS, photo library and Face ID usage descriptions are included.

## Testing

```bash
flutter analyze
flutter test
flutter build apk --release
```

The APK was uploaded to Firebase App Distribution and shared with two testers. Their installation confirmation and the required submission screenshots are still pending. More details are in [the distribution notes](docs/beta-distribution.md).

## Design reference

The screens are inspired by this [Figma UI kit](https://www.figma.com/community/file/1074560321292383928/social-app-free-ui-kit).
