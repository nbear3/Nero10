THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 6666

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Nero10
Nero10_FILES = Tweak.xm
Nero10_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 test.nero10"
	# install.exec "killall -9 MobilePhone"
