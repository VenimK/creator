#!/bin/bash
# Script to permanently hide Security, Network, and Printer settings tabs

FILE="flutter/lib/desktop/pages/desktop_setting_page.dart"

echo "Modifying $FILE to hide granular settings..."

if [ ! -f "$FILE" ]; then
    echo "ERROR: $FILE not found!"
    exit 1
fi

# Use Python for reliable multi-line replacement
python3 << 'PYTHON_SCRIPT'
import re

file_path = "flutter/lib/desktop/pages/desktop_setting_page.dart"

with open(file_path, 'r') as f:
    content = f.read()

# Replace Security Settings block
content = re.sub(
    r'(\s+)if \(!isWeb &&\s+!bind\.isOutgoingOnly\(\) &&\s+!bind\.isDisableSettings\(\) &&\s+bind\.mainGetBuildinOption\(key: kOptionHideSecuritySetting\) != \'Y\'\)\s+SettingsTabKey\.safety,',
    r'\1// SECURITY SETTINGS PERMANENTLY HIDDEN\n\1// if (!isWeb &&\n\1//     !bind.isOutgoingOnly() &&\n\1//     !bind.isDisableSettings() &&\n\1//     bind.mainGetBuildinOption(key: kOptionHideSecuritySetting) != \'Y\')\n\1//   SettingsTabKey.safety,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Replace Network Settings block
content = re.sub(
    r'(\s+)if \(!bind\.isDisableSettings\(\) &&\s+bind\.mainGetBuildinOption\(key: kOptionHideNetworkSetting\) != \'Y\'\)\s+SettingsTabKey\.network,',
    r'\1// NETWORK SETTINGS PERMANENTLY HIDDEN\n\1// if (!bind.isDisableSettings() &&\n\1//     bind.mainGetBuildinOption(key: kOptionHideNetworkSetting) != \'Y\')\n\1//   SettingsTabKey.network,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Replace Display Settings block
content = re.sub(
    r'(\s+)if \(!bind\.isIncomingOnly\(\)\)\s+SettingsTabKey\.display,',
    r'\1// DISPLAY SETTINGS PERMANENTLY HIDDEN\n\1// if (!bind.isIncomingOnly())\n\1//   SettingsTabKey.display,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Replace Account Settings block
content = re.sub(
    r'(\s+)if \(!bind\.isDisableAccount\(\)\)\s+SettingsTabKey\.account,',
    r'\1// ACCOUNT SETTINGS PERMANENTLY HIDDEN\n\1// if (!bind.isDisableAccount())\n\1//   SettingsTabKey.account,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Replace Plugin Settings block
content = re.sub(
    r'(\s+)if \(!isWeb &&\s+!bind\.isIncomingOnly\(\) &&\s+bind\.pluginFeatureIsEnabled\(\)\)\s+SettingsTabKey\.plugin,',
    r'\1// PLUGIN SETTINGS PERMANENTLY HIDDEN\n\1// if (!isWeb && !bind.isIncomingOnly() && bind.pluginFeatureIsEnabled())\n\1//   SettingsTabKey.plugin,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

# Replace Printer Settings block
content = re.sub(
    r'(\s+)if \(isWindows &&\s+bind\.mainGetBuildinOption\(key: kOptionHideRemotePrinterSetting\) != \'Y\'\)\s+SettingsTabKey\.printer,',
    r'\1// PRINTER SETTINGS PERMANENTLY HIDDEN\n\1// if (isWindows &&\n\1//     bind.mainGetBuildinOption(key: kOptionHideRemotePrinterSetting) != \'Y\')\n\1//   SettingsTabKey.printer,',
    content,
    flags=re.MULTILINE | re.DOTALL
)

with open(file_path, 'w') as f:
    f.write(content)

print("✅ Settings tabs successfully hidden")
PYTHON_SCRIPT

echo "Modified file: $FILE"
