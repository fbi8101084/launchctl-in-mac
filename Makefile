start:
	launchctl unload plist/com.fg.selenium.test.plist
	launchctl load plist/com.fg.selenium.test.plist
	launchctl list | grep 'fg'

stop:
	launchctl unload plist/com.fg.selenium.test.plist
	launchctl list | grep 'fg'