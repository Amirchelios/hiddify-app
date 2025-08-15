# PowerShell script for building Hiddify Android APK
# اجرای این اسکریپت در PowerShell

param(
    [string]$BuildType = "all",
    [switch]$Clean,
    [switch]$Install,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
راهنمای استفاده از اسکریپت Build Android:

پارامترها:
    -BuildType: نوع build (debug, release, all) - پیش‌فرض: all
    -Clean: پاک کردن فایل‌های قبلی
    -Install: نصب APK بعد از build
    -Help: نمایش این راهنما

مثال‌ها:
    .\build-android.ps1                    # Build همه APK ها
    .\build-android.ps1 -BuildType debug  # فقط Debug APK
    .\build-android.ps1 -Clean            # پاک کردن و build
    .\build-android.ps1 -Install          # build و نصب
"@
    exit 0
}

# تنظیمات
$FlutterPath = "flutter"
$OutputDir = "build\app\outputs\flutter-apk"

# بررسی وجود Flutter
try {
    $flutterVersion = & $FlutterPath --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter یافت نشد"
    }
    Write-Host "✅ Flutter یافت شد:" -ForegroundColor Green
    Write-Host $flutterVersion[0] -ForegroundColor Cyan
} catch {
    Write-Host "❌ خطا: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "لطفاً Flutter را نصب کنید یا PATH را تنظیم کنید" -ForegroundColor Yellow
    exit 1
}

# پاک کردن
if ($Clean) {
    Write-Host "🧹 پاک کردن فایل‌های قبلی..." -ForegroundColor Yellow
    & $FlutterPath clean
    if (Test-Path "build") {
        Remove-Item -Recurse -Force "build"
    }
    Write-Host "✅ پاک کردن کامل شد" -ForegroundColor Green
}

# دریافت dependencies
Write-Host "📦 دریافت dependencies..." -ForegroundColor Yellow
& $FlutterPath pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ خطا در دریافت dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Dependencies دریافت شد" -ForegroundColor Green

# Build بر اساس نوع
switch ($BuildType.ToLower()) {
    "debug" {
        Write-Host "🔨 ساخت Debug APK..." -ForegroundColor Yellow
        & $FlutterPath build apk --debug
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ خطا در ساخت Debug APK" -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Debug APK ساخته شد" -ForegroundColor Green
    }
    "release" {
        Write-Host "🔨 ساخت Release APK..." -ForegroundColor Yellow
        & $FlutterPath build apk --release --no-shrink
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ خطا در ساخت Release APK" -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Release APK ساخته شد" -ForegroundColor Green
    }
    "all" {
        Write-Host "🔨 ساخت Debug APK..." -ForegroundColor Yellow
        & $FlutterPath build apk --debug
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ خطا در ساخت Debug APK" -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Debug APK ساخته شد" -ForegroundColor Green
        
        Write-Host "🔨 ساخت Release APK..." -ForegroundColor Yellow
        & $FlutterPath build apk --release --no-shrink
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ خطا در ساخت Release APK" -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Release APK ساخته شد" -ForegroundColor Green
    }
    default {
        Write-Host "❌ نوع build نامعتبر: $BuildType" -ForegroundColor Red
        Write-Host "انواع معتبر: debug, release, all" -ForegroundColor Yellow
        exit 1
    }
}

# نمایش فایل‌های ساخته شده
if (Test-Path $OutputDir) {
    Write-Host "`n📱 APK های ساخته شده:" -ForegroundColor Cyan
    Get-ChildItem $OutputDir -Filter "*.apk" | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 2)
        Write-Host "  📦 $($_.Name) ($size MB)" -ForegroundColor White
    }
} else {
    Write-Host "❌ پوشه خروجی یافت نشد" -ForegroundColor Red
    exit 1
}

# نصب APK
if ($Install) {
    Write-Host "`n📱 بررسی دستگاه‌های متصل..." -ForegroundColor Yellow
    $devices = & adb devices 2>$null | Select-String "device$"
    
    if ($devices) {
        Write-Host "✅ دستگاه‌های متصل:" -ForegroundColor Green
        $devices | ForEach-Object { Write-Host "  📱 $($_.ToString().Split()[0])" -ForegroundColor White }
        
        $debugApk = Join-Path $OutputDir "app-debug.apk"
        if (Test-Path $debugApk) {
            Write-Host "📲 نصب Debug APK..." -ForegroundColor Yellow
            & adb install -r $debugApk
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Debug APK نصب شد" -ForegroundColor Green
            } else {
                Write-Host "❌ خطا در نصب APK" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "❌ هیچ دستگاه Android یافت نشد" -ForegroundColor Red
        Write-Host "لطفاً USB Debugging را فعال کنید" -ForegroundColor Yellow
    }
}

Write-Host "`n🎉 Build کامل شد!" -ForegroundColor Green
Write-Host "APK ها در پوشه: $OutputDir" -ForegroundColor Cyan
