#!/bin/sh
#
#
#
####################################################################################################
# - The purpose of this script is to show the progress status while updating the Google Chrome browser.
# - The process will utilize DEPNotify with a progress bar for installing applications.
#
# - Created by Taren Doolittle
#
####################################################################################################

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

LOGPATH=/path/to/folder
LOGFILE=/path/to/folder
VERSION=1.0
jbinpth=/path/to/folder
helper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
bddy=/usr/libexec/PlistBuddy
icon=/path/to/folder
tgt=/Library/Preferences/com.apple.SoftwareUpdate.plist
user=$(scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( $2 != "loginwindow" ) { print $2 }}')
DNLOG=/path/to/folder
dmgfile="googlechrome.dmg"
volname="Google Chrome"
bddy=/usr/libexec/PlistBuddy
tgt=/Applications/Google\ Chrome.app/Contents/Info.plist
instld=`$bddy -c "Print :CFBundleShortVersionString" "$tgt"`

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#FUNCTION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Download and Install
DLIns (){
/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
echo $(date) "Downloading Current Stable "$verchk"..." >> $logFile
echo $(date) "Downloading Current Stable "$verchk"..."
##Mounting Chrome .dmg
/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
#Removing old version of Chrome, and copying new version
rm -rf "/Applications/Google Chrome.app"
cp -R "/Volumes/${volname}/Google Chrome.app/" "/Applications/Google Chrome.app/"
echo $(date) "Replacing Chrome" >> $logFile
echo $(date) "Replacing Chrome"
#Unmouting Chrome .dmg
/usr/bin/hdiutil detach "${volname}" -quiet
#Removing Chrome .dmg from /tmp
/bin/rm /tmp/"${dmgfile}"
echo $(date) "Chrome has been replaced.. Download deleted" >> $logFile
echo $(date) "Chrome has been replaced...Download deleted"
}

## Beginning install for Google Chrome to be called later in script
GoogleUpdate(){
url="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
#m1 url="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"

## Get Current version installed
echo $(date) "Current Installed Chrome version is "$instld" " >> $logFile
echo $(date) "Current Installed Chrome version is "$instld" "

## Get Current Google version
verchk=$(curl -s https://omahaproxy.appspot.com/history|awk -F',' '/mac,stable/{print $3; exit}')
echo $(date) "Current Stable Version is "$verchk"..." >> $logFile
echo $(date) "Current Stable Version is "$verchk"..."

# Test if Installed Ver is Current Ver
if [ ! -f "/Applications/Google Chrome.app/Contents/Info.plist" ] ; then
	echo $(date) "Chrome not Installed.. installing Chrome" >> $logFile
	echo $(date) "Chrome not Installed.. installing Chrome"
	DLIns
fi

# Check if the installed version is same as current, if so exit. If not proceed upgrade
if [[ "$instld" == "$verchk" ]]; then
	echo $(date) "Chrome is on Current Version "$instld"... No update needed, exiting" >> $logFile
	echo $(date) "Chrome is on Current Version "$instld"... No update needed, exiting"
else
	echo $(date) "Chrome is not on current version "$verchk" or not installed.. Proceeding to update/install" >> $logFile
	echo $(date) "Chrome is not on current version "$verchk" or not installed.. Proceeding to update/install"
	DLIns
	sleep 10
	echo $(date) "Update completed. Current Chrome version is "$instld"..." >> $logFile
	echo $(date) "Update completed. Current Chrome version is "$instld"..."
fi
exit 0
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# PRE-SETUP
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#################################################################
# Setup DEPNotify

echo "Command: Image: /usr/local/VRTXfiles/vertex_logo_sop_r_rgb.png" >> $DNLOG
echo "Command: WindowStlyle: Activate" >> $DNLOG
echo "Command: Determinate: 15" >> $DNLOG
echo "Command: WindowTitle: DTE macOS" >> $DNLOG
echo "Command: MainTitle: macOS Provisioning Process" >> $DNLOG
echo "Command: MainText: This device is being configured with baseline configuration. This window will update as steps are completed. Please do not shutdown or restart until instructed." >> $DNLOG
echo "Command: Help: Please contact Service Desk for assistance" >> $DNLOG
#################################################################
## JAMF Helper Text
heading="macOS Provisioning Complete"
updy="The provisioning process has completed.
updy01="The Google Chrome Update will be downloaded."
updn="The installtion process has completed."
#########################################################################
# Pre-Check for Updates to insure /Library/Preferences/com.apple.SoftwareUpdate.plist contains lrua
#/usr/sbin/softwareupdate -l
#########################################################################

## Open DepNotify
echo $(date) "Launching DEP Notify dialog" >> $DNLOG
sudo -u "$user" open -a /Applications/Utilities/DEPNotify.app/Contents/MacOS/DEPNotify &

## INSTALL APPLICATIONS

echo "Status: Start Your Engines" >> $DNLOG
sleep 10
#Google Chrome
echo "Status: Installing Updated Google Chrome" >> $DNLOG
GoogleUpdate
echo "Chrome Update is Installed" >> $LOGFILE
#################################################################
# Cleanup
# Remove DEPNotify and the logs
rm -Rf /Applications/Utilities/DEPNotify.app
rm -Rf $DNLOG
#
shutdown -r now

