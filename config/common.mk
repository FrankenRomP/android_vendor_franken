PRODUCT_BRAND ?= FrankenRom

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Google property overides
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.setupwizard.rotation_locked=true \
    ro.config.calibration_cad=/system/etc/calibration_cad.xml

# Security Enhanced Linux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),userdebug)
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif
endif

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.device.cache_dir=/cache
endif

# LatineIME Gesture swyping
ifneq ($(filter shamu,$(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so \
    vendor/franken/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so \
    vendor/franken/prebuilt/common/lib64/libjni_latinimegoogle.so:system/lib64/libjni_latinimegoogle.so
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/franken/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/franken/prebuilt/common/bin/50-liquid.sh:system/addon.d/50-liquid.sh \
    vendor/franken/prebuilt/common/bin/blacklist:system/addon.d/blacklist

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/franken/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/franken/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/franken/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# FrankenRom specific init file
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/etc/init.local.rc:root/init.franken.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Google Dialer
PRODUCT_COPY_FILES +=  \
    vendor/franken/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml 

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Include FrankenRom boot animation
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# AR
PRODUCT_COPY_FILES += \
    vendor/franken/prebuilt/common/etc/calibration_cad.xml:system/etc/calibration_cad.xml

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/franken/config/twrp.mk
endif

# Required packages
PRODUCT_PACKAGES += \
    Launcher3 

# Franken Stuff
#PRODUCT_PACKAGES += \
#    Lab

# Optional packages
PRODUCT_PACKAGES += \
    libemoji \
    LiveWallpapersPicker

PRODUCT_PACKAGES += \
    librsjni

# Custom packages
PRODUCT_PACKAGES += \
    ExactCalculator \
	MusicFX 

# Extra tools
PRODUCT_PACKAGES += \
    libsepol \
    mke2fs \
    powertop \
    tune2fs

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank
endif

# Prebuilt Apps
$(call inherit-product-if-exists, vendor/franken/prebuilt/common/prebuilt.mk)

# Vendor Overlays
DEVICE_PACKAGE_OVERLAYS += vendor/franken/overlay/common

# Version System
PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE := 

ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    FRANKEN_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    FRANKEN_VERSION_MAINTENANCE := 
endif

# Set FRANKEN_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef FRANKEN_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "FRANKEN_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^FRANKEN_||g')
        FRANKEN_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(LIQUID_BUILDTYPE)),)
    FRANKEN_BUILDTYPE :=
endif

ifdef FRANKEN_BUILDTYPE
    ifneq ($(FRANKEN_BUILDTYPE), SNAPSHOT)
        ifdef FRANKEN_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            FRANKEN_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from FRANKEN_EXTRAVERSION
            FRANKEN_EXTRAVERSION := $(shell echo $(FRANKEN_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to FRANKEN_EXTRAVERSION
            FRANKEN_EXTRAVERSION := -$(FRANKEN_EXTRAVERSION)
        endif
    else
        ifndef FRANKEN_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            FRANKEN_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from FRANKEN_EXTRAVERSION
            FRANKEN_EXTRAVERSION := $(shell echo $(FRANKEN_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to FRANKEN_EXTRAVERSION
            FRANKEN_EXTRAVERSION := -$(FRANKEN_EXTRAVERSION)
        endif
    endif
else
    # If FRANKEN_BUILDTYPE is not defined, set to UNOFFICIAL
    FRANKEN_BUILDTYPE := UNOFFICIAL
    FRANKEN_EXTRAVERSION := 
endif

ifeq ($(FRANKEN_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        FRANKEN_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(FRANKEN_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(FRANKEN_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(FRANKEN_VERSION_MAINTENANCE),0)
                FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(FRANKEN_BUILD)
            else
                FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(FRANKEN_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(FRANKEN_BUILD)
            endif
        else
            FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(FRANKEN_BUILD)
        endif
    endif
else
    ifeq ($(FRANKEN_VERSION_MAINTENANCE),0)
        FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(FRANKEN_BUILDTYPE)$(FRANKEN_EXTRAVERSION)-$(FRANKEN_BUILD)
    else
        FRANKEN_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(FRANKEN_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(FRANKEN_BUILDTYPE)$(FRANKEN_EXTRAVERSION)-$(FRANKEN_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.franken.version=$(FRANKEN_VERSION) \
    ro.franken.releasetype=$(FRANKEN_BUILDTYPE) \
    ro.franken.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(FRANKEN_VERSION)

FRANKEN_DISPLAY_VERSION := $(FRANKEN_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.franken.display.version=$(FRANKEN_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/franken/config/partner_gms.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
