# 🚀 Firebase Deployment Guide for "Can I Bunk?" App

## Prerequisites
- ✅ Firebase CLI installed (version 15.1.0)
- ✅ Flutter web app built and tested locally
- ✅ Google account for Firebase Console

## Step-by-Step Deployment Instructions

### 1. Login to Firebase
```bash
firebase login --no-localhost
```
- Choose "Y" or "n" for Gemini features (your preference)
- Complete the browser authentication
- Return to terminal after successful login

### 2. Initialize Firebase in Your Project
```bash
firebase init
```
Select these options when prompted:
- **Which Firebase features do you want to set up?**
  - Hosting: Configure files for Firebase Hosting
  - (Press Space to select, Enter to confirm)

- **Select a default Firebase project for this directory:**
  - Choose "Create a new project" or select existing
  - If creating new: Enter project name like "can-i-bunk-app"

- **What do you want to use as your public directory?**
  - Enter: `build/web`

- **Configure as a single-page app?**
  - Enter: `y` (Yes)

- **Set up automatic builds and deploys with GitHub?**
  - Enter: `n` (No - for now)

### 3. Build Your Flutter Web App
```bash
flutter build web --release
```

### 4. Deploy to Firebase Hosting
```bash
firebase deploy --only hosting
```

### 5. Get Your Live URL
After successful deployment, you'll see output like:
```
Hosting URL: https://your-project-id.web.app
```

## Alternative: Manual Firebase Console Setup

If you prefer to set up via Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing
3. Enable Authentication and Firestore Database
4. Add Firebase Hosting:
   - Go to Hosting section
   - Click "Get Started"
   - Follow the setup wizard

## Post-Deployment Checklist

- [ ] App loads correctly at the Firebase URL
- [ ] Authentication works (sign up/sign in)
- [ ] Data syncs between local and Firebase
- [ ] All features work as expected
- [ ] Test on different devices/browsers

## Custom Domain (Optional)

To use your own domain:
1. Go to Firebase Hosting → Custom Domain
2. Add your domain name
3. Update DNS records as instructed
4. Wait for SSL certificate (can take up to 24 hours)

## Troubleshooting

**Build Issues:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

**Deployment Issues:**
```bash
firebase deploy --only hosting --debug
```

**Permission Issues:**
- Make sure you're logged in with the correct Google account
- Check that you have Editor/Owner permissions on the Firebase project

## Next Steps After Deployment

1. **Monitor Usage**: Check Firebase Analytics in the console
2. **User Feedback**: Share the URL and collect feedback
3. **Iterate**: Make improvements based on user feedback
4. **Scale**: Consider premium features or mobile app development

---

**Your app will be live at:** `https://[your-project-id].web.app`

🎉 **Congratulations on deploying your first Firebase-hosted Flutter app!**
