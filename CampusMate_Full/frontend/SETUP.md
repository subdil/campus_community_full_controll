# Frontend setup

1. `flutter pub get`
2. Open `lib/config/app_config.dart`.
3. Replace `https://YOUR-VERCEL-DOMAIN.vercel.app/api` with your deployed API URL.
4. `flutter run`
5. `flutter build apk --release`

For profile/post/community image upload, wire the image picker to POST multipart `/api/upload`. The backend already provides this endpoint and Cloudinary configuration.
