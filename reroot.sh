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

# ------
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
  printf "${BR}Unsupported CPU architecture: ${ARCH}${RST}"
  exit 1
fi

echo -e "
${BY}! Please select the Linux Distro:${RST}
1. Linux
2. Debian
"
printf "${BG}> Enter the Distro you want to install: ${RST}"
read which_distro














