#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

# Icons and symbols
CHECKMARK="✅"
CLEANING="🧼"
TRASH="🗑️"
ROCKET="🚀"
SPARKLES="✨"
WARNING="⚠️"

# Function to print colored text
print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}                 Arch Linux System Cleaner               ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo -e "${BLUE}▶ ${WHITE}$1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

print_cleaning() {
    echo -e "${YELLOW}${CLEANING} $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

# Function to show disk usage
show_disk_usage() {
    echo -e "${PURPLE}📊 Current disk usage:${NC}"
    df -h / | tail -n 1 | awk '{print "   Root: " $3 " used / " $2 " total (" $5 " full)"}'
    echo ""
}

# Function to confirm action
confirm_action() {
    echo -e "${YELLOW}${WARNING} This will clean system caches and remove orphaned packages.${NC}"
    echo -e "${GRAY}   Press ENTER to continue or Ctrl+C to cancel...${NC}"
    read -r
}

# Main TUI
clear
print_header
show_disk_usage
confirm_action

echo -e "${ROCKET} ${WHITE}Starting cleanup process...${NC}"
echo ""

# 1. Pacman cache
print_section "Pacman Cache Cleanup"
print_cleaning "Clearing pacman cache..."
sudo pacman -Scc --noconfirm >/dev/null 2>&1
sudo rm -rf /var/cache/pacman/pkg/* >/dev/null 2>&1
print_success "Pacman cache cleared"
echo ""

# 2. Temp files
print_section "Temporary Files Cleanup"
print_cleaning "Clearing temporary system files..."
sudo rm -rf /tmp/* >/dev/null 2>&1
sudo rm -rf /var/tmp/* >/dev/null 2>&1
print_success "Temporary files cleared"
echo ""

# 3. User cache
print_section "User Cache Cleanup"
print_cleaning "Clearing user cache..."
rm -rf ~/.cache/* >/dev/null 2>&1
print_cleaning "Clearing all users' cache (if any)..."
sudo rm -rf /home/*/.cache/* >/dev/null 2>&1
print_success "User caches cleared"
echo ""

# 4. Journal logs
print_section "Journal Logs Cleanup"
print_cleaning "Vacuuming journal logs (keeping 1 day)..."
JOURNAL_BEFORE=$(journalctl --disk-usage 2>/dev/null | grep -oE '[0-9.]+[KMGT]?B' | tail -1 || echo "unknown")
sudo journalctl --vacuum-time=1d >/dev/null 2>&1
JOURNAL_AFTER=$(journalctl --disk-usage 2>/dev/null | grep -oE '[0-9.]+[KMGT]?B' | tail -1 || echo "unknown")
if [ "$JOURNAL_BEFORE" != "unknown" ] && [ "$JOURNAL_AFTER" != "unknown" ]; then
    print_success "Journal logs vacuumed (was: $JOURNAL_BEFORE, now: $JOURNAL_AFTER)"
else
    print_success "Journal logs vacuumed"
fi
echo ""

# 5. Thumbnail cache
print_section "Thumbnail Cache Cleanup"
print_cleaning "Clearing thumbnail cache..."
rm -rf ~/.cache/thumbnails/* >/dev/null 2>&1
print_success "Thumbnail cache cleared"
echo ""

# 6. Orphaned packages
print_section "Orphaned Packages Cleanup"
print_cleaning "Removing orphaned packages..."
orphans=$(pacman -Qdtq 2>/dev/null)
if [ -n "$orphans" ]; then
    echo -e "${GRAY}   Found orphaned packages: $(echo $orphans | wc -w) packages${NC}"
    sudo pacman -Rns --noconfirm $orphans >/dev/null 2>&1
    print_success "Orphaned packages removed"
else
    print_info "No orphaned packages found"
fi
echo ""

# 7. AUR helpers
print_section "AUR Helper Cache Cleanup"
if command -v yay &> /dev/null; then
    print_cleaning "Cleaning yay cache..."
    yay -Sc --noconfirm >/dev/null 2>&1
    print_success "Yay cache cleaned"
elif command -v paru &> /dev/null; then
    print_cleaning "Cleaning paru cache..."
    paru -Sc --noconfirm >/dev/null 2>&1
    print_success "Paru cache cleaned"
else
    print_info "No AUR helpers found"
fi
echo ""

# 8. Dev tool caches
print_section "Development Tool Caches"
print_cleaning "Cleaning npm, pip, cargo, flatpak caches..."

# Check and clean npm cache
if [ -d ~/.npm/_cacache ]; then
    rm -rf ~/.npm/_cacache >/dev/null 2>&1
    print_success "NPM cache cleared"
fi

# Check and clean pip cache
if [ -d ~/.cache/pip ]; then
    rm -rf ~/.cache/pip >/dev/null 2>&1
    print_success "Pip cache cleared"
fi

# Check and clean cargo cache
if [ -d ~/.cache/cargo ]; then
    rm -rf ~/.cache/cargo >/dev/null 2>&1
    print_success "Cargo cache cleared"
fi

# Check and clean flatpak
if command -v flatpak &> /dev/null; then
    FLATPAK_UNUSED=$(flatpak uninstall --unused --dry-run 2>/dev/null | grep -c "Nothing unused to uninstall" || echo "found")
    if [ "$FLATPAK_UNUSED" = "found" ]; then
        flatpak uninstall --unused -y >/dev/null 2>&1
        print_success "Flatpak unused packages removed"
    else
        print_info "No unused Flatpak packages found"
    fi
else
    print_info "Flatpak not installed"
fi
echo ""

# Final summary
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${WHITE}                    Cleanup Complete!                     ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${SPARKLES} ${GREEN}System cleanup completed successfully!${NC}"
echo ""
print_info "Final disk usage:"
show_disk_usage
