# src: https://likegeeks.com/awk-command/

# preprocessing section
BEGIN {
  # Special variables
  # RS  - record separator (default=\n)
  # FS  - field separator (default=space or tab)
  # OFS - output field separator (default=space)
  # ORS - output record separator (default=\n)
  # FIELDWIDTHS -
  #   space-separator list of widths between fields; 
  #   For example, if set to "3 4 5," then fields 1 and 2 would be
  #   be separated by 3 spaces, fields 2 & 3 by 4 spaces, and fields
  #   4 & 5 by 5 spaces
  # ARGC - Retrieves the number of passed parameters.
  # ARGV -    Retrieves the command line parameters; for example, ARGV[1]
  # ENVIRON -    
  #   Array of the shell environment variables and corresponding values.
  #   For example, ENVIRON["PATH"]
  # FILENAME -
  #   The file name that is processed by awk.
  # NF   - Fields count of the line being processed.
  # NR   - Retrieves total count of processed records.
  # FNR  - The record which is processed.
  # IGNORECASE -
  #   To ignore the character case.
}

# main part of program
{
  if ($1 > 4) {
    # do something
  }
  
  while ( $1 > 5) {
  	# do something
  }
  
  for (n=1; n<5; n++) {
    # do something
  }
  
  printf "Total is %d\n", my_integer_value;

}

# post processing section
END {

}