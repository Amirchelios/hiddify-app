# راهنمای Build برنامه Hiddify

## 🚀 نحوه Build کردن APK در GitHub Actions

### **مراحل استفاده:**

1. **Push کد به GitHub:**
   ```bash
   git add .
   git commit -m "Add GitHub Actions workflow for APK build"
   git push origin main
   ```

2. **بررسی Actions:**
   - به GitHub repository برو
   - روی تب "Actions" کلیک کن
   - workflow "Build Android APK" رو ببین

3. **دانلود APK:**
   - بعد از اتمام build، روی workflow کلیک کن
   - در قسمت "Artifacts" دو فایل خواهی دید:
     - `hiddify-debug.apk` (قابل نصب)
     - `hiddify-release-unsigned.apk` (بدون امضا)

### **نوع APK های تولید شده:**

#### **Debug APK:**
- ✅ **قابل نصب**: مستقیماً قابل نصب
- ✅ **قابل Debug**: برای توسعه مناسب
- ✅ **اندازه کوچک**: بهینه شده برای تست

#### **Release APK (بدون امضا):**
- ✅ **بهینه شده**: برای استفاده نهایی
- ⚠️ **نیاز به تنظیمات**: باید "Install from unknown sources" فعال باشه
- ✅ **اندازه بهینه**: فشرده شده و بهینه

### **مشکلات احتمالی و راه‌حل:**

#### **خطای "App not installed":**
1. **فعال‌سازی نصب از منابع ناشناس:**
   - Settings → Security → Unknown sources
   - یا Settings → Apps → Special app access → Install unknown apps

2. **حذف نسخه قبلی:**
   - اگر نسخه قبلی نصب شده، اول حذفش کن

#### **خطای "Parse error":**
- مطمئن شو که Android version دستگاهت حداقل 5.0 (API 21) باشه

### **اطلاعات فنی:**

- **Package ID**: `app.hiddify.com`
- **Target SDK**: Android 14 (API 34)
- **Min SDK**: Android 5.0 (API 21)
- **Architectures**: x86_64, armeabi-v7a, arm64-v8a
- **Signing**: Debug signing (بدون نیاز به keystore)

### **نکات مهم:**

1. **هر بار push**: APK جدید ساخته میشه
2. **Retention**: APK ها فقط 1 روز در GitHub Actions ذخیره میشن
3. **اندازه**: APK ها معمولاً بین 50-100MB هستند
4. **سازگاری**: با همه Android 5.0+ سازگار

### **برای توسعه‌دهندگان:**

اگر می‌خوای APK رو محلی build کنی:

```bash
# Debug build
flutter build apk --debug

# Release build (بدون امضا)
flutter build apk --release --no-shrink

# Build برای architecture خاص
flutter build apk --release --target-platform android-arm64
```

### **پشتیبانی:**

- **GitHub Issues**: برای گزارش مشکلات
- **Discord**: برای سوالات و کمک
- **Documentation**: برای اطلاعات بیشتر

---

**نکته**: این APK ها برای تست و توسعه هستند. برای انتشار رسمی نیاز به code signing دارن.
