start:
	launchctl unload plist/com.fg.selenium.test.plist
	launchctl load plist/com.fg.selenium.test.plist
	launchctl list | grep 'fg'

stop:
	launchctl unload plist/com.fg.selenium.test.plist
	launchctl list | grep 'fg'

start591:
	launchctl unload plist/com.591.plist
	launchctl load plist/com.591.plist

stop591:
	launchctl unload plist/com.591.plist