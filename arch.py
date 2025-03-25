import os

def run_command(command):
    os.system(f"echo y | {command}")

def cleanup():
    print("Starting Arch Linux Cleanup Script...")
    
    # Show disk usage before cleanup
    print("\nDisk usage before cleanup:")
    os.system("df -h")
    
    # Clear pacman cache
    run_command("sudo pacman -Scc")
    run_command("sudo paccache -r -k0")
    
    # Remove orphaned packages
    run_command("sudo pacman -Qdtq | sudo pacman -Rns -")
    
    # Clear AUR cache (yay/paru)
    run_command("rm -rf ~/.cache/yay/*")
    run_command("rm -rf ~/.cache/paru/*")
    
    # Clear journal logs
    run_command("sudo journalctl --vacuum-time=7d")
    run_command("sudo journalctl --vacuum-size=50M")
    
    # Clear system logs
    run_command("sudo rm -rf /var/log/*")
    
    # Clear thumbnails cache
    run_command("rm -rf ~/.cache/thumbnails/*")
    
    # Clear temp files
    run_command("sudo rm -rf /tmp/*")
    
    # Clear user cache
    run_command("rm -rf ~/.cache/*")
    
    # Show disk usage after cleanup
    print("\nDisk usage after cleanup:")
    os.system("df -h")
    
    print("\nCleanup completed!")

if __name__ == "__main__":
    cleanup()

