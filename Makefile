XBUILD=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
PROJECT=DTMHeatmap.xcodeproj
TARGET=DTMHeatmap

all: $(TARGET).framework

$(TARGET)-simulator.framework:
	$(XBUILD) ONLY_ACTIVE_ARCH=NO -project $(PROJECT) -target $(TARGET) -sdk iphonesimulator -configuration Release clean build
	mv build/Release-iphonesimulator/$(TARGET).framework $(TARGET)-simulator.framework

$(TARGET)-iphone.framework:
	$(XBUILD) ONLY_ACTIVE_ARCH=NO -project $(PROJECT) -target $(TARGET) -sdk iphoneos -configuration Release clean build
	mv build/Release-iphoneos/$(TARGET).framework $(TARGET)-iphone.framework

$(TARGET).framework: $(TARGET)-simulator.framework $(TARGET)-iphone.framework
	cp -R $(TARGET)-iphone.framework ./$(TARGET).framework
	rm ./$(TARGET).framework/$(TARGET)
	lipo $(TARGET)-simulator.framework/$(TARGET) -remove arm64 -output $(TARGET)-simulator.framework/$(TARGET)
	lipo -create -output $(TARGET).framework/$(TARGET) $(TARGET)-simulator.framework/$(TARGET) $(TARGET)-iphone.framework/$(TARGET)

clean:
	rm -rf *.framework
	rm -rf build