#!/bin/bash

# wireless-adb.sh - Script to connect to Android devices wirelessly via ADB
# Usage: ./wireless-adb.sh [ip_address]

# Color codes for better output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display error messages and exit
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to display success messages
success_msg() {
    echo -e "${GREEN}$1${NC}"
}

# Function to display informational messages
info_msg() {
    echo -e "${YELLOW}$1${NC}"
}

# Display usage information
display_usage() {
    echo "Wireless ADB Connection Script"
    echo "==============================="
    echo "This script helps connect to Android devices wirelessly via ADB."
    echo
    echo "Usage:"
    echo "  ./wireless-adb.sh           - Auto-detect device and connect"
    echo "  ./wireless-adb.sh IP_ADDRESS - Connect to specific IP address"
    echo
    echo "Requirements:"
    echo "  - ADB must be installed and in PATH"
    echo "  - Device must be connected via USB initially"
    echo "  - Device and computer must be on the same network"
    echo
}

# Check if ADB is available
check_adb() {
    if ! command -v adb &> /dev/null; then
        error_exit "ADB is not installed or not in PATH. Please install Android SDK platform tools."
    else
        success_msg "ADB found and ready."
    fi
}

# Check if any device is connected via USB
check_device_connected() {
    local device_count
    device_count=$(adb devices | grep -v "List" | grep -v "^$" | wc -l)
    
    if [ "$device_count" -eq 0 ]; then
        error_exit "No devices connected. Please connect your device via USB first."
    elif [ "$device_count" -gt 1 ]; then
        info_msg "Multiple devices detected. Using the first one."
    fi
    
    success_msg "Device detected."
}

# Get IP address of the connected device
get_device_ip() {
    local ip_address
    
    # Try to get IP address using different methods
    ip_address=$(adb shell "ip addr show wlan0 | grep 'inet ' | cut -d' ' -f6 | cut -d/ -f1")
    
    if [ -z "$ip_address" ]; then
        # Try alternative command
        ip_address=$(adb shell "ifconfig wlan0 | grep 'inet addr' | cut -d: -f2 | awk '{print \$1}'")
    fi
    
    if [ -z "$ip_address" ]; then
        # Try another alternative
        ip_address=$(adb shell "settings get global wifi_ip_address")
    fi
    
    if [ -z "$ip_address" ]; then
        error_exit "Could not determine the IP address of the device. Make sure Wi-Fi is enabled."
    fi
    
    echo "$ip_address"
}

# Enable TCP/IP mode
enable_tcpip() {
    local ip_address="$1"
    
    info_msg "Enabling TCP/IP mode on port 5555..."
    
    if ! adb tcpip 5555 &> /dev/null; then
        error_exit "Failed to enable TCP/IP mode. Please ensure the device is properly connected."
    fi
    
    # Wait a second for the setting to take effect
    sleep 1
    success_msg "TCP/IP mode enabled on $ip_address:5555"
}

# Connect to device wirelessly
connect_wireless() {
    local ip_address="$1"
    
    info_msg "Connecting to $ip_address:5555..."
    
    # Wait a moment before attempting connection
    sleep 2
    
    if ! adb connect "$ip_address:5555" | grep -q "connected"; then
        error_exit "Failed to connect to $ip_address:5555. Please check the network connection and try again."
    fi
    
    success_msg "Successfully connected to $ip_address:5555"
    info_msg "You can now disconnect the USB cable."
    info_msg "To disconnect, run: adb disconnect $ip_address:5555"
}

# Main function
main() {
    display_usage
    check_adb
    
    # If IP address is provided as argument
    if [ -n "$1" ]; then
        ip_address="$1"
        info_msg "Using provided IP address: $ip_address"
    else
        # Auto-detect IP address
        check_device_connected
        ip_address=$(get_device_ip)
        info_msg "Detected device IP address: $ip_address"
    fi
    
    enable_tcpip "$ip_address"
    connect_wireless "$ip_address"
}

# Execute main function with all arguments
main "$@"

