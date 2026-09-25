# CampusMate 2.0 — Full Student + Admin App

This package replaces the earlier limited CampusMate UI/backend.

## Included

### Student
- Separate student login + registration
- Campus social feed
- Text + poster/image posts
- Delete own posts
- Search students
- 1-to-1 chat
- Create communities
- Request to join communities
- Community owner approval/rejection
- Community member removal
- Owner messaging controls: everyone / owner only / nobody
- Delete own communities
- Community chat
- Profile editing
- Remote forced-update check

### Admin
- Separate admin login
- Dashboard statistics
- Search/manage students
- Enable/disable student accounts
- View/delete any post
- View/disable/delete communities
- View/moderate messages
- Remote APK version control
- Home poster/title/message control
- Backend role authorization for every admin endpoint

## Backend → Vercel

Deploy `backend/` as the Vercel Root Directory.

Environment variables:
- `MONGODB_URI`
- `JWT_SECRET`
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`

After deployment, seed the first admin:
```bash
npm install
npm run seed:admin
```

If your Vercel environment is used for the seed command, set the same variables there first. The admin account is never created through student registration.

## Flutter

The Flutter project is `frontend_main/`.

It already points to:
`https://campusmate-demo-app-szj4.vercel.app/api`

If your final Vercel deployment gets a different URL, change `frontend_main/lib/services/api.dart`.

From `frontend_main`:
```bash
flutter clean
flutter pub get
flutter analyze
flutter run
flutter build apk --release
```

The Android package id is `com.campusmate.app`.

## Image/poster uploads

Student poster uploads and future admin poster uploads use Cloudinary through `/api/upload`. Configure the three Cloudinary variables before using image upload.

## Important

The backend performs authorization. UI buttons are not the security boundary:
- students can delete only their own posts/communities;
- community owners can manage their own communities;
- admins can moderate all supported resources;
- admin APIs require a JWT belonging to an admin account.

Before public production use, add rate limiting, stronger audit logging, email verification/password recovery, and a proper production Android signing key.
