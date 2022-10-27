# How it works
# Starts zsh with an interactive (-i) login (-l) shell with XTRACE enabled (-x) and running 
# a noop command (:) that returns an exit value of 0. 
#
# Stderr is set to stdout so that the XTRACE output can be grepped for the given alias which 
# have the form
#
# +/path/to/file:LN> alias 'youralias=your command'
#

# zsh options:
# -x   sets XTRACE
# -l   use login shell
# -i   use interactive shell
# -c   run the following command
# :    a noop command

function grepalias() { 
  local a=$1
  zsh -lxic : 2> >(grep "> alias '$a")
}                                                                                                 

function grepstartup() {
  local a=$1
  zsh -lxic : 2> >(grep "$a")
}