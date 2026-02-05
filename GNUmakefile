# GNUmakefile for SmallStep (Linux/GNUStep)

include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME = SmallStep

SmallStep_HEADER_FILES = \
	SmallStep/Core/SmallStep.h \
	SmallStep/Core/SSPlatform.h \
	SmallStep/Core/SSFileSystem.h \
	SmallStep/Core/SSWindowStyle.h \
	SmallStep/Core/SSConcurrency.h \
	SmallStep/Core/SSFileDialog.h \
	SmallStep/Core/SSApplicationMenu.h \
	SmallStep/Core/SSAppDelegate.h \
	SmallStep/Core/SSHostApplication.h \
	SmallStep/Core/SSMainMenu.h

SmallStep_OBJC_FILES = \
	SmallStep/Core/SmallStep.m \
	SmallStep/Core/SSPlatform.m \
	SmallStep/Core/SSFileSystem.m \
	SmallStep/Core/SSWindowStyle.m \
	SmallStep/Core/SSConcurrency.m \
	SmallStep/Core/SSFileDialog.m \
	SmallStep/Core/SSApplicationMenu.m \
	SmallStep/Core/SSHostApplication.m \
	SmallStep/Core/SSMainMenu.m \
	SmallStep/Platform/Linux/SSLinuxPlatform.m

SmallStep_INCLUDE_DIRS = -I. -ISmallStep/Core -ISmallStep/Platform/Linux

include $(GNUSTEP_MAKEFILES)/framework.make
