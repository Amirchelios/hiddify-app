# 🚀 راهنمای سریع Build APK

## **برای شروع فوری:**

### **1. Push کد به GitHub:**
```bash
git add .
git commit -m "Add APK build workflow"
git push origin main
```

### **2. بررسی GitHub Actions:**
- به repository برو
- روی تب "Actions" کلیک کن
- workflow "Build Android APK" رو ببین

### **3. دانلود APK:**
- بعد از اتمام build، روی workflow کلیک کن
- در "Artifacts" دو فایل خواهی دید:
  - `hiddify-debug.apk` (قابل نصب)
  - `hiddify-release-unsigned.apk` (بدون امضا)

---

## **Build محلی:**

### **Windows (PowerShell):**
```powershell
# Build همه APK ها
.\scripts\build-android.ps1

# فقط Debug APK
.\scripts\build-android.ps1 -BuildType debug

# Build و نصب
.\scripts\build-android.ps1 -Install
```

### **Linux/macOS:**
```bash
# Build همه APK ها
./scripts/build-android.sh

# فقط Debug APK
./scripts/build-android.sh -t debug

# Build و نصب
./scripts/build-android.sh -i
```

### **Makefile:**
```bash
# نمایش راهنما
make help

# Build همه APK ها
make build-all

# Build و نصب Debug
make test-apk
```

---

## **مشکلات رایج:**

### **خطای "App not installed":**
1. Settings → Security → Unknown sources
2. یا Settings → Apps → Special app access → Install unknown apps

### **خطای "Parse error":**
- Android version باید حداقل 5.0 (API 21) باشه

### **خطای Flutter:**
```bash
flutter doctor
flutter clean
flutter pub get
```

---

## **اطلاعات فنی:**

- **Package**: `app.hiddify.com`
- **Min SDK**: Android 5.0 (API 21)
- **Target SDK**: Android 14 (API 34)
- **Architectures**: x86_64, armeabi-v7a, arm64-v8a
- **Signing**: Debug (بدون نیاز به keystore)

---

## **نکات مهم:**

✅ **اتوماتیک**: هر push = APK جدید  
✅ **بدون امضا**: نیازی به keystore نداره  
✅ **قابل نصب**: APK های تولید شده قابل نصب هستند  
✅ **Multi-arch**: از همه architecture ها پشتیبانی می‌کنه  

---

**🎯 هدف**: تولید APK های قابل نصب بدون نیاز به code signing
