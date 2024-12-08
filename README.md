# VPN Connection and Disconnection Script with TOTP

This repository contains two scripts for automating the connection and disconnection of VPNs using a Time-based One-Time Password (TOTP) for authentication. These scripts allow you to connect to and disconnect from specified VPNs using AppleScript, with TOTP generated using `oathtool`.

## Features

- **Connect to VPN**: Generates a TOTP code and connects to specified VPNs by passing the TOTP as the password.
- **Disconnect from VPN**: Disconnects from the specified VPNs via AppleScript.
- Developed and tested on **macOS Sonoma 14.7.**

## Prerequisites

Before running the scripts, ensure the following tools are installed:

1. **oathtool**: This tool generates the TOTP code.
   - Install using Homebrew:  
     ```bash
     brew install oath-toolkit
     ```

2. **AppleScript**: The scripts rely on AppleScript to interact with the macOS UI to connect to and disconnect from VPNs. AppleScript is included by default on macOS.

## How to Get Your TOTP Secret

To get your TOTP secret, follow these steps:

1. Open the authenticator app that you use for two-factor authentication (e.g., Google Authenticator, Authy).
2. Locate the account for which you are generating a TOTP code (the VPN service in this case).
3. **Backup your TOTP codes** in the authenticator app. This step will typically generate a backup file containing all the TOTP secrets for your accounts.
4. Open the backup file and look for the **secret key** associated with the VPN account. It will be a string of characters (e.g., `JBSWY3DPEHPK3PXP`).
5. Copy the TOTP secret and replace `<your_totp_secret>` in the `OAUTH_URI` variable within the `vpn_connect.sh` script.

For example:
```bash
OAUTH_URI="otpauth://totp/<your_email>?secret=<your_totp_secret>"
```

Replace `<your_totp_secret>` with the secret you copied.

## Setup

1. Clone or download the repository.

2. Modify the scripts:
   - In both `vpn_connect.sh` and `disconnect_vpn.sh`, replace the VPN names in the `VPN_NAMES` array with the names from your macOS Network Preferences (ensure there is a space between VPN names).
   - In `vpn_connect.sh`, replace `<your_email>` and `<your_totp_secret>` in the `OAUTH_URI` variable with your own TOTP URI and secret.

## Usage

### VPN Connection

1. Make the `vpn_connect.sh` script executable:
   ```bash
   chmod +x vpn_connect.sh
   ```

2. Run the script to connect to your VPNs:
   ```bash
   ./vpn_connect.sh
   ```

   This script will generate a TOTP code and attempt to connect to each VPN specified in the `VPN_NAMES` array. It will automatically enter the TOTP code in the password field when prompted.

### VPN Disconnection

1. Make the `disconnect_vpn.sh` script executable:
   ```bash
   chmod +x disconnect_vpn.sh
   ```

2. Run the script to disconnect from your VPNs:
   ```bash
   ./disconnect_vpn.sh
   ```

   This script will disconnect from each VPN specified in the `VPN_NAMES` array.

## Troubleshooting

- **oathtool not installed**: If you get an error indicating `oathtool` is not installed, install it using Homebrew:
   ```bash
   brew install oath-toolkit
   ```

- **VPN connection issues**: Ensure the VPN names in the `VPN_NAMES` array exactly match the names listed in your macOS Network Preferences.

- **AppleScript issues**: If the script fails to interact with the SystemUIServer or VPN menu, ensure that AppleScript is functioning correctly and has permission to control your system (check in System Preferences > Security & Privacy > Privacy).

- **macOS compatibility**: These scripts were developed and tested on macOS Sonoma 14.7. If you're using a different macOS version, make sure AppleScript is functioning properly and there are no changes in how macOS handles VPN connections.

## License

This repository is licensed under the MIT License.
