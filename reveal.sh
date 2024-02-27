#!/usr/bin/env bash


DECODER_FILE=/tmp/reveal.txt
## Set your favorite editor here
editor="${EDITOR:-hx}"


function decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'=' 
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}


function urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


# cmd=$(printf "jwt\nx509\nreq\nbase64\nb64url\nurl" | gum filter)
cmd=$(printf "jwt\nx509\nreq\nbase64\nb64url\nurl" | fzf  --reverse)
case $cmd in 
  jwt)
    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    jwt decode $(cat $DECODER_FILE | sed '/^$/d')
  ;;
  x509)

    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    cat $DECODER_FILE | sed '/^$/d' | openssl x509 -text 
  ;;
  req)

    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    cat $DECODER_FILE | sed '/^$/d' | openssl req -text 
  ;;
  base64)

    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    cat $DECODER_FILE | sed '/^$/d' | base64 -d 
  ;;
  b64url)

    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    decode_base64_url  "$(cat $DECODER_FILE | sed '/^$/d')" 
  ;;
  url)

    echo "" > $DECODER_FILE
    $editor $DECODER_FILE
    urldecode  "$(cat $DECODER_FILE | sed '/^$/d')" 
  ;;
  *)
    echo "ERROR missing cmd"
    exit 1
  ;;
esac


