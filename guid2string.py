 #!/usr/bin/python3

import uuid 
# convert a binary guid from ldap or active directory to a hex string 
# TODO - duplicate

def guid_to_string(binary_guid: bytes) -> str:
    return str(uuid.UUID(bytes_le=binary_guid)).lower()
