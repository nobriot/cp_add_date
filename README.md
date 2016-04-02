# cp_add_date
Utility script for file/folder backup

cp_add_date is a small shell utility that can be used for appending the date in front of the name when copying files or directories. It makes it easy to replace copy commands like "cp -R folder 2016_04_25_folder" for backup purposes
This scripts takes a file or directory as an argument and copies it into the same folder with a timestamp preprended with the YYYY_MM_DD_ format.

       usage: cp_add_date filename [destination_folder]
              cp_add_date folder_name [destination_folder]
