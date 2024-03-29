#!/bin/bash

url="https://go.microsoft.com/fwlink/?LinkID=760865"

function get_latest_version()
{
    url2=$(curl --silent -I "$url" | grep Location | awk '{print $NF}' | sed -e 's/\r//')
    v=$(curl --silent -I "$url2" | grep Location | awk -F/ '{print $NF}' | awk -F_ '{print $2}' )
    echo $v
}

latest_version=$(get_latest_version)
current_version=$(dpkg-query --show code-insiders | awk '{print $NF}')

if [ "$latest_version" = "$current_version" ]
then
    echo "Already at latest version $latest_version"
else
    echo "Current Version: $current_version"
    echo "Latest Version:  $latest_version"
    echo "Updating..."
    curl -L "$url" > /tmp/vscode.deb
    sudo dpkg -i /tmp/vscode.deb
    rm /tmp/vscode.deb
fi
exit 0