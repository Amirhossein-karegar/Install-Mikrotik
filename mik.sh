Introduction
This guide explains how to install MikroTik RouterOS on a Linux machine using a Bash script. This method is efficient but requires careful handling to ensure the correct settings are applied.

Prerequisites
A Linux system (preferably a test environment).
Root or sudo access.
Basic understanding of Linux commands and networking.
Steps
Prepare the Environment:

Ensure your network interface and storage device names are correct. Use ip a to check network interface names and lsblk to check storage device names (usually /dev/sda for the primary disk).
Create the Script:

Open a text editor and create a new file named script.sh.

You can do that by using nano command (if nano not exist, you can install it by apt-get install nano)

As example: nano script.sh, copy the script code, click on Ctrl+x, will ask you to save click y and enter.
Copy the following script into the file:
#!/bin/bash
wget https://download.mikrotik.com/routeros/7.5/chr-7.5.img.zip -O chr.img.zip && \
gunzip -c chr.img.zip > chr.img && \
mount -o loop,offset=512 chr.img /mnt && \
ADDRESS=`ip addr show enp0s3 | grep global | cut -d' ' -f 6 | head -n 1` && \
GATEWAY=`ip route list | grep default | cut -d' ' -f 3` && \
echo "/ip address add address=$ADDRESS interface=[/interface ethernet find where name=ether1]
/ip route add gateway=$GATEWAY
/ip service disable telnet
/user set 0 name=root password=xxxxxx"
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/sda && \
echo "sync disk" && \
echo s > /proc/sysrq-trigger && \
echo "Sleep 5 seconds" && \
sleep 5 && \
echo "Ok, reboot" && \
echo b > /proc/sysrq-trigger​
 

Modify the Script:

Replace enp0s3 with your network interface name, you can check by run ip a command
Replace /dev/sda with your storage device name, you can check by run lsblk command
Set a secure password instead of xxxxxx.
Save and Execute the Script:

Save the file and exit the editor.
Give execute permission to the script:
chmod 755 script.sh
Run the script as root:
sudo ./script.sh
Important Notes
This script will overwrite the data on the specified storage device (/dev/sda in the script). Make sure this is the correct device and that you have backups if necessary.
The script configures basic network settings and sets a root password. Ensure these settings are correct for your network.
Running scripts like this should be done with caution. Review and understand each command before executing.
Conclusion
Following these steps, you'll have MikroTik RouterOS installed on your Linux system. This method is suited for advanced users familiar with Linux and network configuration.

Additional Tips
Test this script in a safe environment first, like a virtual machine.
Always backup important data before running such scripts.
