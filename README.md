The initivative of this script is to update the Google Chrome browser while tracking the progress using a progess bar using DEPNotify. 

The script is designed to check if a Google Chrome browser update is warranted by using a curl command to check the latest browser version via the Google website. If an update is needed per the credential check the script will automatically uninstall the current browser version and update the browser with the updated version while logging the results. The progress status of the install will be shown using DEPNotify. 

To ensure DEPNotify will function, the script will ensure that DEPnotify is installed on the local machine. A configuration file to set parameters such as the main title, progress bar and status text that is typically named "depnotify.plist" and placed in a specific directory, like /Library/Application Support/. Also, a specific command to sent to the control file is needed that is typically located at '/var/tmp/depnotify.log', this is the file where the script will echo commands. 

DEPNotify Package link: https://github.com/jamf/DEPNotify/releases
https://files.nomad.menu/DEPNotify.pkg


