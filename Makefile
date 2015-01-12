include theos/makefiles/common.mk

TWEAK_NAME = SpotSiri
SpotSiri_FILES = Tweak.xm
SpotSiri_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
