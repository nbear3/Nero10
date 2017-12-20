# include $(THEOS)/makefiles/common.mk

# TWEAK_NAME = Nero10
# Nero10_FILES = Tweak.xm
# Nero10_FRAMEWORKS = UIKit Foundation

# include $(THEOS_MAKE_PATH)/tweak.mk

# after-install::
# 	install.exec "killall -9 SpringBoard"

export TARGET=iphone:clang
ARCHS = armv7 arm64
DEBUG = 1
PACKAGE_VERSION = 1.0

THEOS=/opt/theos

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nero10
$(TWEAK_NAME)_FILES = Tweak.xm 
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = AppSupport
$(TWEAK_NAME)_LDFLAGS += -F./ -F./Common/
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -F./Common/

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Settings
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"