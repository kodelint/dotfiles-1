# disable
sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
sudo rm /private/var/vm/swapfile*
sudo nvram boot-args="kext-dev-mode=1 nvda_drv=1 vm_compressor=2 -v"
sudo pmset -a hibernatemode 0
sudo rm -rf /var/vm/sleepimage

# enable
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist
sudo nvram boot-args="kext-dev-mode=1 nvda_drv=1 vm_compressor=4 -v"
sudo pmset -a hibernatemode 3
