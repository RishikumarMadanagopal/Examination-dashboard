# 🔑 Firebase API Key Setup Guide

This guide explains how to set up your own Firebase project and update the API keys.

---

## 🎯 **Why Change the API Key?**

The current Firebase configuration uses a demo/shared project. For production or personal use, you should:

✅ Create your own Firebase project  
✅ Have full control over authentication  
✅ Secure your own user data  
✅ Avoid conflicts with other users  

---

## 📝 **Step-by-Step Guide**

### **Step 1: Create Firebase Project** (5 minutes)

1. **Go to Firebase Console**:
   - Visit: https://console.firebase.google.com/
   - Sign in with your Google account

2. **Create New Project**:
   - Click **"Add project"** or **"Create a project"**
   - Project name: `exam-portal` (or any name you like)
   - Click **"Continue"**

3. **Google Analytics** (Optional):
   - You can disable this for learning projects
   - Click **"Continue"**

4. **Wait for project creation** (~30 seconds)

5. Click **"Continue"** when ready

---

### **Step 2: Enable Authentication** (3 minutes)

1. **In your Firebase project**, click **"Authentication"** in the left sidebar

2. Click **"Get started"**

3. **Enable Email/Password Authentication**:
   - Click on **"Email/Password"** provider
   - Toggle **"Enable"** to ON
   - Click **"Save"**

4. **Enable Google Authentication** (Optional):
   - Click on **"Google"** provider
   - Toggle **"Enable"** to ON
   - Select your support email
   - Click **"Save"**

---

### **Step 3: Register Web App** (2 minutes)

1. **In Firebase Console**, click the **⚙️ gear icon** (top left) → **"Project settings"**

2. **Scroll down** to **"Your apps"** section

3. **Click the web icon** `</>` (looks like: `</>`  )

4. **Register app**:
   - App nickname: `exam-portal-web`
   - **Don't** check "Also set up Firebase Hosting"
   - Click **"Register app"**

5. **Copy the configuration**:
   - You'll see a code snippet with `firebaseConfig`
   - **Copy the entire firebaseConfig object**

Example:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "exam-portal-12345.firebaseapp.com",
  projectId: "exam-portal-12345",
  storageBucket: "exam-portal-12345.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef123456",
  measurementId: "G-XXXXXXXXXX"
};
```

6. Click **"Continue to console"**

---

### **Step 4: Update login.html** (2 minutes)

1. **Open**: `project/login.html`

2. **Find lines 308-320** (the firebaseConfig section)

3. **Replace** the placeholder values with YOUR Firebase config:

**BEFORE** (current placeholder):
```javascript
const firebaseConfig = {
  apiKey: "YOUR-API-KEY-HERE",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef",
  measurementId: "G-XXXXXXX"
};
```

**AFTER** (your actual config):
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",  // Your actual API key
  authDomain: "exam-portal-12345.firebaseapp.com",  // Your actual domain
  projectId: "exam-portal-12345",  // Your actual project ID
  storageBucket: "exam-portal-12345.appspot.com",  // Your actual storage
  messagingSenderId: "123456789012",  // Your actual sender ID
  appId: "1:123456789012:web:abcdef123456",  // Your actual app ID
  measurementId: "G-XXXXXXXXXX"  // Your actual measurement ID
};
```

4. **Save the file**

---

### **Step 5: Rebuild and Redeploy** (3 minutes)

Since you updated the HTML file, you need to rebuild the Docker image and redeploy:

#### **For Local Kubernetes:**

```powershell
# Navigate to project directory
cd C:\Users\Home\Downloads\project\project

# Rebuild Docker image
docker build -t az900-portal:v1.0 .

# Restart Kubernetes deployment
kubectl rollout restart deployment az900-portal -n production

# Wait for pods to restart
kubectl get pods -n production -w
```

Press `Ctrl+C` when both pods show "Running"

#### **For Azure (when you deploy later):**

Just push to GitHub - the CI/CD pipeline will rebuild automatically:

```powershell
git add project/login.html
git commit -m "Update Firebase configuration"
git push origin main
```

---

### **Step 6: Test Authentication** (2 minutes)

1. **Open your application**:
   - Local: http://localhost:8080
   - Or: http://localhost:30691

2. **Click "Sign Up"**

3. **Create a test account**:
   - Email: test@example.com
   - Password: Test123456
   - Click "Sign Up"

4. **Check Firebase Console**:
   - Go to Firebase Console → Authentication → Users
   - You should see your test user!

5. **Test Login**:
   - Logout (if logged in)
   - Click "Login"
   - Use the same credentials
   - Should work!

---

## 🔒 **Security Best Practices**

### **1. API Key Restrictions** (Recommended for production)

1. In Firebase Console → **Project Settings** → **General**
2. Scroll to **"Your apps"**
3. Click on your web app
4. Under **"App restrictions"**, you can restrict by:
   - HTTP referrers (domains)
   - IP addresses

### **2. Environment Variables** (For production)

Instead of hardcoding, use environment variables:

```javascript
const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  // ... etc
};
```

### **3. Firebase Security Rules**

In Firebase Console → **Firestore Database** → **Rules**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 🐛 **Troubleshooting**

### **Issue: "Firebase: Error (auth/invalid-api-key)"**

**Solution**: 
- Double-check you copied the entire API key correctly
- Make sure there are no extra spaces
- Verify the API key in Firebase Console → Project Settings

### **Issue: "Firebase: Error (auth/unauthorized-domain)"**

**Solution**:
1. Go to Firebase Console → Authentication → Settings → Authorized domains
2. Add: `localhost`
3. Add your domain if deploying to cloud

### **Issue: Login/Signup not working**

**Solution**:
- Check browser console for errors (F12)
- Verify Email/Password is enabled in Firebase Authentication
- Clear browser cache and try again

### **Issue: After rebuilding, still seeing old config**

**Solution**:
```powershell
# Force rebuild without cache
docker build --no-cache -t az900-portal:v1.0 ./project

# Delete old pods
kubectl delete pods -l app=az900-portal -n production

# Verify new pods are running
kubectl get pods -n production
```

---

## 📊 **Quick Reference**

| What | Where to Find |
|------|---------------|
| **API Key** | Firebase Console → Project Settings → Your apps |
| **Enable Auth** | Firebase Console → Authentication → Sign-in method |
| **View Users** | Firebase Console → Authentication → Users |
| **Security Rules** | Firebase Console → Firestore Database → Rules |
| **Usage Stats** | Firebase Console → Usage and billing |

---

## 💡 **Firebase Free Tier Limits**

Firebase offers a generous free tier:

| Feature | Free Tier Limit |
|---------|-----------------|
| **Authentication** | Unlimited users |
| **Email/Password** | Unlimited |
| **Google Sign-in** | Unlimited |
| **Firestore Reads** | 50,000/day |
| **Firestore Writes** | 20,000/day |
| **Storage** | 1 GB |
| **Bandwidth** | 10 GB/month |

**Perfect for learning and small projects!** ✅

---

## 🎯 **Alternative: Use Environment-Based Config**

For more advanced setups, you can use different configs for different environments:

```javascript
const firebaseConfig = 
  window.location.hostname === 'localhost' 
    ? {
        // Local development config
        apiKey: "LOCAL-API-KEY",
        // ...
      }
    : {
        // Production config
        apiKey: "PROD-API-KEY",
        // ...
      };
```

---

## ✅ **Checklist**

- [ ] Created Firebase project
- [ ] Enabled Email/Password authentication
- [ ] Enabled Google authentication (optional)
- [ ] Registered web app
- [ ] Copied firebaseConfig
- [ ] Updated login.html
- [ ] Rebuilt Docker image
- [ ] Redeployed to Kubernetes
- [ ] Tested signup
- [ ] Tested login
- [ ] Verified user in Firebase Console

---

## 🎉 **You're Done!**

Your application now uses YOUR own Firebase project!

**Benefits**:
✅ Full control over authentication  
✅ Your own user database  
✅ Can monitor usage in Firebase Console  
✅ Can add more features (Firestore, Storage, etc.)  
✅ Production-ready authentication  

---

## 📚 **Learn More**

- **Firebase Docs**: https://firebase.google.com/docs
- **Firebase Auth**: https://firebase.google.com/docs/auth
- **Firebase Console**: https://console.firebase.google.com/

---

**🔥 Your app now has professional-grade authentication! 🔥**
