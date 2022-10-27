# Managing `.env` Files

## The Problem

I use `.env` files to set environment variables for projects, but those values are different in local vs test
vs prod. I also want support from my IDE and the commandline. VSCode and Intellij both support `.env` files,
but if you want to point your application from local to test or prod, you have to update the `.env` file, which
leaves me with an env file with lots of comments. Alternatively, you can update the IDE to point to another
env file, but that gets a little non-standard by not using `.env`.

## Solution

Instead I use multiple `.env` files, but `.env` itself is a symlink. The real `.env` files are named `.env.local`,
`.env.test`, and `.env.prod`. `.env` then points to one of the real env files. I have two functions in `.zshrc`
that manage the symlinks. `dotenv test` will link `.env.test` to `.env` and source `.env`. `lsenv` will list all
the `.env` files and indicate which, if any, is linked to from `.env`.

Note that the env files are in the format `name=value`, not `export name=value`. This is what an IDE expects, but
to use on the command line, you have to use the command `set -o allexport && source .env && set +o allexport`.

```shell
dotenv () {
  local env="$1"
  if [[ -f $env ]]
  then
    echo "sourcing file $env"
    set -o allexport && source "$env" && set +o allexport
    return 0
  fi
  if [[ $env == "" ]]
  then
    ls --color --classify --human-readable -l .env*
    if [[ -L .env ]]
    then
      local realenv="$(readlink .env | awk -F. '{print $NF}')"
      if [[ $realenv != "" ]]
      then
        dotenv "$realenv"
      fi
    fi
    return 0
  fi
  if [[ $env == "." ]]
  then
    ls --color --classify --human-readable -l .env
    echo "sourcing .env"
    set -o allexport && source .env && set +o allexport
    return 0
  fi
  local common_file=".env.common"
  if [ ! -f "$common_file" ]
  then
    echo "creating file: $common_file"
    touch "$common_file"
  fi
  local env_file=".env.$env"
  if [ ! -f "$env_file" ]
  then
    echo "creating file: $env_file"
    touch "$env_file"
  fi
  tmpfile="$(mktemp)"
  local common_contents="$(cat "$common_file")"
  local env_contents="$(cat "$env_file")"
  cat <<__DOTENV__ > "$tmpfile"
# do not edit - file automatically generated

# $common_file
$common_contents

# $env_file
$env_contents

__DOTENV__
  local combined_file=".env.combined.$env"
  mv -f "$tmpfile" "$combined_file"
  ln -svf "$combined_file" .env
  set -o allexport && source .env && set +o allexport
}

```

```shell
lsenv () {
  local link=""
  if [ -L ".env" ]
  then
    link="$(readlink .env)"
  fi
  for e in $(/bin/ls .env.*)
  do
    local indicator="  "
    if [ "$e" = "$link" ]
    then
      indicator="=>"
    fi
    echo "$indicator $e"
  done
}
```

This allows me to do

```
# see what .env is currently linked to
% lsenv
   .env.aws
=> .env.local
   .env.prod
   .env.test
   .env.wiremock

# switch to test env and source the file
% dotenv test
linking .env.test -> .env
sourcing .env

# show that .env now points to .env.test
% lsenv
   .env.aws
   .env.local
   .env.prod
=> .env.test
   .env.wiremock
```
