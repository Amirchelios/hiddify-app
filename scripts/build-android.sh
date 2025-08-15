#!/bin/bash

# Bash script for building Hiddify Android APK
# اجرای این اسکریپت در Linux/macOS

set -e

# رنگ‌ها برای output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# توابع کمکی
print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${WHITE}🔨 $1${NC}"
}

# نمایش راهنما
show_help() {
    echo -e "${WHITE}راهنمای استفاده از اسکریپت Build Android:${NC}"
    echo ""
    echo "پارامترها:"
    echo "  -t, --type TYPE     نوع build (debug, release, all) - پیش‌فرض: all"
    echo "  -c, --clean         پاک کردن فایل‌های قبلی"
    echo "  -i, --install       نصب APK بعد از build"
    echo "  -h, --help          نمایش این راهنما"
    echo ""
    echo "مثال‌ها:"
    echo "  ./build-android.sh                    # Build همه APK ها"
    echo "  ./build-android.sh -t debug           # فقط Debug APK"
    echo "  ./build-android.sh -c                 # پاک کردن و build"
    echo "  ./build-android.sh -i                 # build و نصب"
    echo ""
}

# پارامترهای پیش‌فرض
BUILD_TYPE="all"
CLEAN=false
INSTALL=false

# پردازش پارامترها
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -i|--install)
            INSTALL=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "پارامتر ناشناخته: $1"
            show_help
            exit 1
            ;;
    esac
done

# تنظیمات
FLUTTER_CMD="flutter"
OUTPUT_DIR="build/app/outputs/flutter-apk"

print_header "شروع Build Android APK"

# بررسی وجود Flutter
if ! command -v $FLUTTER_CMD &> /dev/null; then
    print_error "Flutter یافت نشد"
    print_info "لطفاً Flutter را نصب کنید یا PATH را تنظیم کنید"
    exit 1
fi

print_success "Flutter یافت شد:"
$FLUTTER_CMD --version | head -n 1

# پاک کردن
if [ "$CLEAN" = true ]; then
    print_info "پاک کردن فایل‌های قبلی..."
    $FLUTTER_CMD clean
    if [ -d "build" ]; then
        rm -rf build
    fi
    print_success "پاک کردن کامل شد"
fi

# دریافت dependencies
print_info "دریافت dependencies..."
$FLUTTER_CMD pub get
if [ $? -ne 0 ]; then
    print_error "خطا در دریافت dependencies"
    exit 1
fi
print_success "Dependencies دریافت شد"

# Build بر اساس نوع
case $BUILD_TYPE in
    "debug")
        print_header "ساخت Debug APK..."
        $FLUTTER_CMD build apk --debug
        if [ $? -ne 0 ]; then
            print_error "خطا در ساخت Debug APK"
            exit 1
        fi
        print_success "Debug APK ساخته شد"
        ;;
    "release")
        print_header "ساخت Release APK..."
        $FLUTTER_CMD build apk --release --no-shrink
        if [ $? -ne 0 ]; then
            print_error "خطا در ساخت Release APK"
            exit 1
        fi
        print_success "Release APK ساخته شد"
        ;;
    "all")
        print_header "ساخت Debug APK..."
        $FLUTTER_CMD build apk --debug
        if [ $? -ne 0 ]; then
            print_error "خطا در ساخت Debug APK"
            exit 1
        fi
        print_success "Debug APK ساخته شد"
        
        print_header "ساخت Release APK..."
        $FLUTTER_CMD build apk --release --no-shrink
        if [ $? -ne 0 ]; then
            print_error "خطا در ساخت Release APK"
            exit 1
        fi
        print_success "Release APK ساخته شد"
        ;;
    *)
        print_error "نوع build نامعتبر: $BUILD_TYPE"
        print_info "انواع معتبر: debug, release, all"
        exit 1
        ;;
esac

# نمایش فایل‌های ساخته شده
if [ -d "$OUTPUT_DIR" ]; then
    print_info "APK های ساخته شده:"
    for apk in "$OUTPUT_DIR"/*.apk; do
        if [ -f "$apk" ]; then
            size=$(du -h "$apk" | cut -f1)
            filename=$(basename "$apk")
            echo -e "  📦 ${WHITE}$filename${NC} ($size)"
        fi
    done
else
    print_error "پوشه خروجی یافت نشد"
    exit 1
fi

# نصب APK
if [ "$INSTALL" = true ]; then
    print_info "بررسی دستگاه‌های متصل..."
    
    if command -v adb &> /dev/null; then
        devices=$(adb devices | grep -E "device$" | wc -l)
        
        if [ $devices -gt 0 ]; then
            print_success "دستگاه‌های متصل:"
            adb devices | grep -E "device$" | while read line; do
                device_id=$(echo "$line" | awk '{print $1}')
                echo -e "  📱 ${WHITE}$device_id${NC}"
            done
            
            debug_apk="$OUTPUT_DIR/app-debug.apk"
            if [ -f "$debug_apk" ]; then
                print_info "نصب Debug APK..."
                adb install -r "$debug_apk"
                if [ $? -eq 0 ]; then
                    print_success "Debug APK نصب شد"
                else
                    print_error "خطا در نصب APK"
                fi
            fi
        else
            print_warning "هیچ دستگاه Android یافت نشد"
            print_info "لطفاً USB Debugging را فعال کنید"
        fi
    else
        print_warning "ADB یافت نشد"
        print_info "لطفاً Android SDK را نصب کنید"
    fi
fi

echo ""
print_success "Build کامل شد!"
print_info "APK ها در پوشه: $OUTPUT_DIR"
