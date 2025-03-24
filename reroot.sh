#!/bin/sh

### config

# -------
# Regular Foreground Colors
K='\e[30m'  # Black
R='\e[31m'  # Red
G='\e[32m'  # Green
Y='\e[33m'  # Yellow
B='\e[34m'  # Blue
M='\e[35m'  # Magenta
C='\e[36m'  # Cyan
W='\e[37m'  # White

# Bold Foreground Colors
BK='\e[1;30m'  # Bold Black
BR='\e[1;31m'  # Bold Red
BG='\e[1;32m'  # Bold Green
BY='\e[1;33m'  # Bold Yellow
BB='\e[1;34m'  # Bold Blue
BM='\e[1;35m'  # Bold Magenta
BC='\e[1;36m'  # Bold Cyan
BW='\e[1;37m'  # Bold White
# Reset
RST='\e[0m'



## ///// Function to start installation /////
function distro_install() {

    ### config
    ROOTFS_DIR=$(pwd)
    export PATH=$PATH:~/.local/usr/bin
    max_retries=50
    timeout=1
    ARCH=$(uname -m)
    ###
    
    clear
    ### banner
    banner() {
    
    echo -e "================================================
           ____  ______  ____  ____  ____  ______
          / __ \/ ____/ / __ \/ __ \/ __ \/_  __/
         / /_/ / __/ (_) /_/ / / / / / / / / /   
        / _, _/ /____ / _, _/ /_/ / /_/ / / /    
       /_/ |_/_____(_)_/ |_|\____/\____/ /_/
                                    ~ v1.0s
                ${BG}>> by adityash4rma <<${RST}
    ================================================
    
    "
    }
    
    banner
    
    ### architecture check
    printf "${Y}Checking CPU Architecture ... ${RST}\n"
    if [ "$ARCH" = "x86_64" ]; then
        ARCH_ALT=amd64
        printf "Architecture: ${BG} ${ARCH_ALT} ${RST}\n"
    elif [ "$ARCH" = "aarch64" ]; then
        ARCH_ALT=arm64
        printf "Architecture: ${BG} ${ARCH_ALT} ${RST}\n"
    else
      printf "${BR}! Unsupported CPU architecture: ${ARCH}${RST}\n"
      exit 1
    fi
    
echo -e "
${BY}! Please select the Linux Distro:${RST}
1. Ubuntu
2. Alpine
"
    printf "${BG}> Enter the Distro you want to install: ${RST}\n"
    read which_distro
    
    
    case $which_distro in
        1) 
            distro="ubuntu"
            printf "${Y}! Downloading Ubuntu (24.04.2) ...${RST}\n";
            wget --show-progress --progress=bar -q --tries=$max_retries --timeout=$timeout --no-hsts -O "/tmp/${distro}-rootfs.tar.gz" "https://cdimage.ubuntu.com/ubuntu-base/releases/24.04.1/release/ubuntu-base-24.04.2-base-${ARCH_ALT}.tar.gz"
            printf "${G}✓ Downloading Completed${RST}\n"
            printf "${Y}! Unpacking Distro ...${RST}\n"
            tar -xf "/tmp/${distro}-rootfs.tar.gz" -C $ROOTFS_DIR
            printf "${BG}✓ Unpacking Completed${RST}\n"
            ;;
        2)
            distro="alpine"
            printf "${Y}! Downloading Alpine Linux...${RST}\n";
            wget --show-progress  --progress=bar -q --tries=$max_retries --timeout=$timeout --no-hsts -O "/tmp/${distro}-rootfs.tar.gz" "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/aarch64/alpine-minirootfs-3.21.3-${ARCH}.tar.gz"
            printf "${G}✓ Downloading Completed${RST}\n"
            printf "${Y}! Unpacking Distro ...${RST}\n"
            tar -xf "/tmp/${distro}-rootfs.tar.gz" -C $ROOTFS_DIR
            printf "${G}✓ Unpacking Completed${RST}\n"
            ;;
    esac
    
    ## Binary installation
    mkdir $ROOTFS_DIR/usr/local/bin -p
    printf "${Y}! Downloading Binary: ${RST}proot ...${RST}\n";
    wget --tries=$max_retries --timeout=$timeout --no-hsts -O $ROOTFS_DIR/usr/local/bin/proot "https://github.com/proot-me/proot-static-build/raw/refs/heads/master/static/proot-${ARCH}"

    ## Downlaod proot binary and check integrity
    while [ ! -s "$ROOTFS_DIR/usr/local/bin/proot" ]; do
        rm $ROOTFS_DIR/usr/local/bin/proot -rf
        printf "${Y}! [RETRY] Downloading Binary: ${RST}proot ...${RST}\n";
        wget --tries=$max_retries --timeout=$timeout --no-hsts -O $ROOTFS_DIR/usr/local/bin/proot "https://github.com/proot-me/proot-static-build/raw/refs/heads/master/static/proot-${ARCH}"

        if [ -s "$ROOTFS_DIR/usr/local/bin/proot" ]; then
            printf "${Y}! Escalating Privileges for${RST} proot ${Y}...${RST}\n"
            chmod 755 $ROOTFS_DIR/usr/local/bin/proot
            break
        fi

        chmod 755 $ROOTFS_DIR/usr/local/bin/proot
        sleep 1
    done
    chmod 755 $ROOTFS_DIR/usr/local/bin/proot
    printf "${G}✓ Escalation Complete.\n"
    sleep 2
    
    ## Adding Domain Nameservers to resolv.conf
    printf "${Y}! Setting up DNS Servers on ${RST}/etc/resolv.conf\n"  
    printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > ${ROOTFS_DIR}/etc/resolv.conf
    printf "${G}✓ DNS Setup Complete.\n"

    ### Removing Temporary files
    printf "${G}! Cleaning Up Caches ...${RST}\n"
    rm -rf "/tmp/${distro}-rootfs.tar.gz" /tmp/sbin
      
    ### Adding file to check if distro is installed
    touch $ROOTFS_DIR/.installed
    printf "${BG}✓ Installation completed successfully!${RST}\n"
    printf "Proceeding in 5 seconds...\n"
    sleep 5
      
      
    
}


# ////// Distro: Boot //////
function distro_boot() {

    $ROOTFS_DIR/usr/local/bin/proot --rootfs="${ROOTFS_DIR}" -0 -w "/home" -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit

}


### When to Boot & When to install
if [ ! -e $ROOTFS_DIR/.installed ]; then
    distro_install
else
    boot
fi


