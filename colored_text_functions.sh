# usage: source colored_text.sh
# c_red("hello")

export C_BLACK="\\033[0;30m"
export C_DK_GRAY="\\033[1;30m"

export C_RED="\\033[0;31m"
export C_LT_RED="\\033[1;31m"

export C_GREEN="\\033[0;32m"
export C_LT_GREEN="\\033[1;32m"

export C_BROWN="\\033[0;33m"
export C_LT_BROWN="\\033[1;33m"

export C_BLUE="\\033[0;34m"
export C_LT_BLUE="\\033[1;34m"

export C_PURPLE="\\033[0;35m"
export C_LT_PURPLE="\\033[1;35m"

export C_CYAN="\\033[0;36m"
export C_LT_CYAN="\\033[1;36m"

export C_LT_GRAY="\\033[0;37m"
export C_WHITE="\\033[1;37m"

export C_NORMAL="\\033[0;39m"

function c_black() { echo $C_BLACK$1$C_NORMAL }
function c_dk_gray() { echo $C_DK_GRAY$1$C_NORMAL }

function c_red()       { echo $C_RED$1$C_NORMAL }
function c_lt_red()    { echo $C_LT_RED$1$C_NORMAL }

function c_green()     { echo $C_GREEN$1$C_NORMAL }
function c_lt_green()  { echo $C_LT_GREEN$1$C_NORMAL }

function c_brown()     { echo $C_BROWN$1$C_NORMAL }
function c_lt_brown()  { echo $C_LT_BROWN$1$C_NORMAL }

function c_blue()     { echo $C_BLUE$1$C_NORMAL }
function c_lt_blue()  { echo $C_LT_BLUE$1$C_NORMAL }

function c_purple()   { echo $C_PURPLE$1$C_NORMAL }
function c_lt_purple(){ echo $C_LT_PURPLE$1$C_NORMAL }

function c_cyan()     { echo $C_CYAN$1$C_NORMAL }
function c_lt_cyan()  { echo $C_LT_CYAN$1$C_NORMAL }

function c_lt_gray()  { echo $C_LT_GRAY$1$C_NORMAL }
function c_white()    { echo $C_WHITE$1$C_NORMAL }

function c_normal()   { echo $C_NORMAL$1$C_NORMAL }