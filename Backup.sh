#!/bin/bash

is_file_older_than() {

      seconds="$1"; file="$2";

      if [[ ! -f "$file" ]]; then
          return 1;
      fi

      modified_secs="$(date -r "$file" +%s)"
      current_secs="$(date +%s)"
      diff="$(expr "$current_secs" - "$modified_secs")"

      if [[ "$diff" -gt "$seconds" ]]; then
        rm "$file"
        return 0
      fi

      return 1
}

echo Please enter directory path you want to backup.

read DIR_PATH

cd $DIR_PATH

tar -czvf $(date +"%F").tar.gz ./* 

echo Please enter directory path that you want to put backup in it.
read BACKUP_DIR_PATH

mv ./*.tar.gz $BACKUP_DIR_PATH

cd $BACKUP_DIR_PATH

for i in ./*.tar.gz
  do
    is_file_older_than 604800 "$i";
  done 

# If you don't want to use telegram feature,simply comment below lines.

echo Please enter Telegram-Bot Token.
read $TOKEN

echo Please enter Chat-ID.
read $CHAT_ID

curl -F document=@"$BACKUP_DIR_PATH/*.tar.gz" \
  "https://api.telegram.org/bot$TOKEN/sendDocument?chat_id=$CHAT_ID"

