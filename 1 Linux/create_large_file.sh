#!/bin/bash

#dd if=/dev/zero of=large_file bs=1M count=50

#check if the file name is "passwd"
if [ "$(basename "$1")" != "passwd" ]; then
    echo "Error: File name is not 'passwd'"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "Error: File does not exist"
    exit 1
fi

#print the home directory for each user in the passwd file
echo "1. Print the home directory"
awk -F: '{print "User:", $1, "Home Directory:", $6}' "$1"
#2. List all usernames from the passwd file
echo "2. List all usernames from the passwd file"
awk -F: '{print $1}' "$1"
#3. Count the number of users
echo "3. Count the number of users"
user_count=$(awk -F: '{print $1}' "$1" | wc -l)
echo "Number of users: $user_count"
#4. Find the home directory of a specific user
echo "4. Find the home directory of a specific user"
read -p "Enter the username: " username
#find the home directory of the specified user
home_directory=$(awk -F: -v username="$username" '$1 == username {print $6}' "$1")
#check if the user exists
if [ -z "$home_directory" ]; then
    echo "Error: User '$username' not found"
    exit 1
fi

echo "Home directory of user '$username' is: $home_directory"
#5. List users with specific UID range (e.g. 1000-1010)
echo "5. List users with specific UID range"
#the UID range
start_uid=1000
end_uid=1010
awk -v start_uid="$start_uid" -v end_uid="$end_uid" -F: '$3 >= start_uid && $3 <= end_uid {print $1}' "$1"
#6. Find users with standard shells like /bin/bash or /bin/sh
echo "6. Find users with standard shells like /bin/bash or /bin/sh"
awk -F: '$NF ~ "/bin/bash$|/bin/sh$"' "$1" | cut -d: -f1
#7. Replace the “/” character with “\” character in the entire /etc/passwd file and redirect 
echo "7. Replace the “/” character with “\” character"
read -p "Please enter a destination file" destination 
sed 's/\//\\/g' "$1" > "$destination"

echo "8. Print the private IP"
private_ip=$(hostname -I | awk '{print $1}' | grep -E '^192\.|^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.')

#check if private IP is found
if [ -z "$private_ip" ]; then
    echo "Error: Private IP address not found"
    exit 1
fi

echo "Private IP address: $private_ip"

#10. Switch to john user
echo "10. Switch to john user"
su john

#11. Print the home directory
echo "11. Print the home directory"
eval echo "Home directory of user john is ~john"

#9. Print the public IP
echo "9. Print the public IP"
public_ip=$(curl -s https://api.ipify.org)

#check if public IP is found
if [ -z "$public_ip" ]; then
    echo "Error: Public IP address not found"
    exit 1
fi

echo "Public IP address: $public_ip"

#mv lage_file /home/john