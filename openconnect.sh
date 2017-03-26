#!/bin/bash
Home=`echo $HOME`
EncryptedFile="$Home/.encryptedText.txt"
DecryptedFile="$Home/.decryptedText.txt"
UsernameFile="$Home/.username.txt" 
HostnameFile="$Home/.hostname.txt"

SL_Connect() {
if [ -f "$EncryptedFile" -a -f "$UsernameFile" -a -f "$HostnameFile" ];
then
   openssl rsautl -decrypt -inkey $Home/.ssh/id_rsa -in $EncryptedFile -out $DecryptedFile
   sl_password=`cat $DecryptedFile`
   username=`cat $UsernameFile`
   hostname=`cat $HostnameFile`
   rm $DecryptedFile
   echo "Connecting to $hostname"
   read -p "Enter VIP Access code: " vip_access
   printf "$sl_password\n$vip_access\n" | sudo openconnect --user $username --passwd-on-stdin $hostname
else
   unset hostname
   read -p "Enter Hostname to openconnect: " hostname
   echo $hostname > $HostnameFile
   unset username
   unset password
   read -p "Enter Username: " username
   prompt="Enter Password: "
   while IFS= read -p "$prompt" -r -s -n 1 char
	do
        	if [[ $char == $'\0' ]]
                	then
                        break
        	fi
                prompt='*'
                password+="$char"
        done
   echo $username > $UsernameFile
   echo $password > $Home/.pswd.txt
   chmod 640 $UsernameFile $Home/.pswd.txt

   ssh-keygen -f $Home/.ssh/id_rsa.pub -e -m PKCS8 > $Home/.ssh/id_rsa.pem.pub
   openssl rsautl -encrypt -pubin -inkey $Home/.ssh/id_rsa.pem.pub -ssl -in $Home/.pswd.txt -out $EncryptedFile
   rm $Home/.pswd.txt
   echo ""
   SL_Connect
fi
}

[[ $1 == "refresh" && -f $EncryptedFile ]] && rm $EncryptedFile
SL_Connect
