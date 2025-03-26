```
    _   ____  ______  ____  ____  ______
   / | / / / / / __ \/ __ \/ __ \/_  __/
  /  |/ / / / / /_/ / / / / / / / / /   
 / /|  / /_/ / _, _/ /_/ / /_/ / / /    
/_/ |_/\____/_/ |_|\____/\____/ /_/               
                            ~ v1.0s
```
_Run apps that require sudo privilege, on *Unprivileged* &amp; *Ephemeral* Linux Environments_



## Uhh?
Nuroot leverages [Proot](https://proot-me.github.io/) to simulate root privileges, enabling applications that require `sudo` to run without actual root access. It supports multiple Linux distributions and architectures (x86_64, AArch64 for now).

## Installation
1. Downloading Locally
   ```bash
   wget https://github.com/adityash4rma/nuroot/raw/refs/heads/main/nuroot.sh
   chmod +x nuroot.sh
   ```
2. Installing
   ```bash
   bash ./nuroot.sh
   ```

## Usage
Just run the script again to login to the Installed Distro
```bash
bash nuroot.sh
```
