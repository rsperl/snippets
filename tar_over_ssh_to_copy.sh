#!/bin/sh

# copy from local to remote
tar zvcf - whatever/ | ssh user@host 'cat > whatever.tar.gz'

# copy from remote to local
ssh user@host 'tar cz folder/to/copy | tar -xvz