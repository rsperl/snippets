# src: http://www.davidpashley.com/articles/writing-robust-shell-scripts/

# noclobber will not redirect to an existing file
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null; 
then
  # we have the lockfile, so be sure to remove it if the script exits early
  trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

  # do our critical stuff

  # remote the lockfile
  rm -f "$lockfile"
  
  # remove our trap
  trap - INT TERM EXIT
else
   echo "Failed to acquire lockfile: $lockfile." 
   echo "Held by $(cat $lockfile)"
fi