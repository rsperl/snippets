# Find files that have been modified on your system in the past 60 minutes
find / -mmin 60 -type f

# Find all files larger than 20M
find / -type f -size +20M

# Find duplicate files (based on MD5 hash)
find -type f -exec md5sum '{}' ';' | sort | uniq --all-repeated=separate -w 33

# Change permission only for files
cd /var/www/site && find . -type f -exec chmod 766 {} \;
cd /var/www/site && find . -type f -exec chmod 664 {} +

# Change permission only for directories
cd /var/www/site && find . -type d -exec chmod g+x {} \;
cd /var/www/site && find . -type d -exec chmod g+rwx {} +

# Find files and directories for specific user
find . -user <username >-print

# Find files and directories for all without specific user
find . \!-user <username >-print

# Delete older files than 60 days
find . -type f -mtime +60 -delete

# Recursively remove all empty sub-directories from a directory
find . -depth -type d -empty -exec rmdir {} \;

# How to find all hard links to a file
find </path/to/dir >-xdev -samefile filename

# Recursively find the latest modified files
find . -type f -exec stat --format '%Y :%y %n' "{}" \; | sort -nr | cut -d: -f2- | head
