# when you get the error "sasl.h is required"
xcrun --show-sdk-path
sudo ln -s <the_path_from_above_command>/usr/include /usr/include

# if you get "Operation not permitted," you probably need to disable SIP:
# reboot, hold down cmd-R, choose Utilities -> Terminal, type "csrutil disable,"
# reboot, try the steps above again

pip install python-ldap