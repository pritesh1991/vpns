#!/bin/bash

VPN_NAMES=("VPN1" "VPN2")  # Replace with VPN names from macOS Network Preferences. Make sure space is there between two VPN names
# Function to disconnect to a VPN using AppleScript and pass TOTP as password
disconnect_vpn() {
    local vpn_name="$1"
    echo "Disconnecting VPN: $vpn_name"

     # AppleScript to click on the VPN name in the list and enter the password dialog
    osascript <<EOF
    tell application "System Events"
        -- Open the VPN menu by clicking on the VPN menu bar icon
        tell process "SystemUIServer"
            set vpnMenu to first menu bar item of menu bar 1 whose description is "VPN"
            click vpnMenu
        end tell
        delay 1

        -- Select the specific VPN name from the dropdown
        set vpn to "$vpn_name"
        tell process "SystemUIServer"
            tell menu 1 of vpnMenu
                click menu item ("Disconnect "& vpn)
            end tell
        end tell
    end tell
EOF
}

# Connect to each VPN in the list
for vpn_name in "${VPN_NAMES[@]}"; do
    disconnect_vpn "$vpn_name" || true
done

echo "VPN Disconnection completed."
