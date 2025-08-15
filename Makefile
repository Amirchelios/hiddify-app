# Makefile for Hiddify APK building

.PHONY: help clean build-debug build-release build-all

help: ## نمایش راهنما
	@echo "دستورات موجود:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

clean: ## پاک کردن فایل‌های build
	flutter clean
	rm -rf build/
	rm -rf .dart_tool/

build-debug: ## ساخت APK debug
	flutter build apk --debug

build-release: ## ساخت APK release (بدون امضا)
	flutter build apk --release --no-shrink

build-all: clean build-debug build-release ## ساخت همه APK ها

install-debug: build-debug ## نصب APK debug
	adb install build/app/outputs/flutter-apk/app-debug.apk

install-release: build-release ## نصب APK release
	adb install build/app/outputs/flutter-apk/app-release-unsigned.apk

# Build برای architecture های مختلف
build-arm64: ## ساخت APK برای ARM64
	flutter build apk --release --target-platform android-arm64

build-arm7: ## ساخت APK برای ARM7
	flutter build apk --release --target-platform android-arm

build-x64: ## ساخت APK برای x64
	flutter build apk --release --target-platform android-x64

# Build universal APK
build-universal: ## ساخت APK universal
	flutter build apk --release --no-shrink

# نمایش اطلاعات APK
info: ## نمایش اطلاعات APK های ساخته شده
	@echo "=== APK های موجود ==="
	@ls -lh build/app/outputs/flutter-apk/*.apk 2>/dev/null || echo "هیچ APK یافت نشد"
	@echo ""
	@echo "=== اطلاعات دستگاه ==="
	@adb devices 2>/dev/null || echo "ADB در دسترس نیست"

# تست APK
test-apk: build-debug ## تست APK debug
	@echo "نصب APK debug..."
	adb install -r build/app/outputs/flutter-apk/app-debug.apk
	@echo "APK debug نصب شد"
	

