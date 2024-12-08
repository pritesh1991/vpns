#!/bin/bash

# Define variables
OAUTH_URI="otpauth://totp/<your_email>?secret=<your_totp_secret>"  # Replace with your TOTP URI
VPN_NAMES=("VPN1" "VPN2")  # Replace with VPN names from macOS Network Preferences. Make sure space is there between two VPN names

# Extract the TOTP secret using sed
TOTP_SECRET=$(echo "$OAUTH_URI" | sed -n 's/.*secret=\([^&]*\).*/\1/p')

# Validate extraction
if [ -z "$TOTP_SECRET" ]; then
    echo "Error: Could not extract the TOTP secret from the URI."
    exit 1
fi

# Generate the TOTP code
TOTP_CODE=$(oathtool --totp --base32 "$TOTP_SECRET")
if [ $? -ne 0 ]; then
    echo "Error generating TOTP code. Ensure oathtool is installed."
    exit 1
fi

echo "Generated TOTP: $TOTP_CODE"

# Function to connect to a VPN using AppleScript and pass TOTP as password
connect_vpn() {
    local vpn_name="$1"
    echo "Connecting to VPN: $vpn_name"

     # AppleScript to click on the VPN name in the list and enter the password dialog
    osascript <<EOF
    tell application "System Events"
        -- Open the VPN menu by clicking on the VPN menu bar icon
        tell process "SystemUIServer"
            set vpnMenu to first menu bar item of menu bar 1 whose description is "VPN"
            click vpnMenu
        end tell

        -- Select the specific VPN name from the dropdown
        set vpn to "$vpn_name"
        tell process "SystemUIServer"
            tell menu 1 of vpnMenu
                click menu item ("Connect "& vpn)
            end tell
        end tell
        delay 1

        -- Enter the TOTP code into the password field
        tell application "System Events"
            keystroke "$TOTP_CODE"
            keystroke return
        end tell
    end tell
EOF
}

# Connect to each VPN in the list
for vpn_name in "${VPN_NAMES[@]}"; do
    connect_vpn "$vpn_name"
done

echo "VPN connection script completed."
