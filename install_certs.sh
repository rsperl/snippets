#!/bin/bash

# cert src: http://sww.sas.com/sites/it/our-it/div/security-and-compliance/gis-team/documentation/digital-certificates/internal-ca-trust-issues/
# installation notes: https://hub.sas.com/messages/136637 (Paul Kent's comment)

certurls=(
  https://certificates.sas.com/pki/SASSHA2RootCA.crt
  https://certificates.sas.com/pki/SASSHA2IssuingCA01.crt
  https://certificates.sas.com/pki/SASSHA2IssuingCA02.crt
)

for c in "${certurls[@]}"; do
  echo "downloading $c"
  curl --silent -LO "$c"
done

for c in *.crt; do
  echo "installing $c"
  sudo /usr/bin/security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$c"
done
