# Inherit full common Franken stuff
$(call inherit-product, vendor/franken/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
