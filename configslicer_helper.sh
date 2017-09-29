#!/bin/bash  

# check if number of arguements are correct
if [ "$#" -lt 2 ]; then
   echo -e "Missing arguement(s):\n\nparam1: absolute config file path (./<configfile>.cfg)\nparam2: import/export\nparam3: output directory (./<directory name>)"
   exit
fi
if [ ! -f $1 ];
then
   echo -e "Cannot find config file, use './<configfile_name>.cfg'\n"
   exit
fi

# read arguement to check if its export or import
configpath=$1
input=$2
output_dir=$3

source $1
jarfile="../config-slicer-3.0.24.jar"
username="apiuser"
password="apipassword"
cf_name=""
cf_path=""

# ask user for confirmation, else exit
read -p "Are you sure you want to $input? [Y/n] " -n 1 -r
if [ $REPLY != "Y" ];
then
   exit
fi

# make manifest and configuration file from the manifest
if [ $input == "export" ];
then
   # Simple example: show values of all shell variables
   # whose name starts with "myfoo". Anything starting with _
   # is implicitly skipped
   for var in "${!wf@}"; do

      # if output dir specified, append it to file name (extracted from config file)
      if [ -n "$output_dir" ];
      then
         cf_name=$output_dir/${!var}
         cf_path=$output_dir/$var
      else
         cf_name=${!var}
         cf_path=$var
      fi

      echo ">>>>EXPORT $cf_path"
      echo "++MANIFEST create .txt"
      man_cmd="java -jar $jarfile -s $(hostname).gis.a-star.edu.sg -u $username -p $password -o custom -w '$cf_name' -m '$cf_path.txt'"
      echo "$man_cmd"
      eval $man_cmd

      #echo "$var=${!var}"

      echo "++CONFIGURATION create .xml"
      con_cmd="java -jar $jarfile -s $(hostname).gis.a-star.edu.sg -u $username -p $password -o export -m '$cf_path.txt' -k '$cf_path.xml'"
      echo -e "$con_cmd\n"
      eval $con_cmd

   done

elif [ $input == "import" ];
then
   for var in "${!wf@}"; do

      # if output dir specified, append it to file name (extracted from config file)
      if [ -n "$output_dir" ];
      then
         cf_name=$output_dir/${!var}
         cf_path=$output_dir/$var
      else
         cf_name=${!var}
         cf_path=$var
      fi

      echo ">>>>IMPORT $cf_path"
      echo "++MANIFEST import .xml"
      import_cmd="java -jar $jarfile -s $(hostname).gis.a-star.edu.sg -u $username -p $password -o import -k '$cf_path.xml'"
      echo -e "$import_cmd\n"
      eval $import_cmd

   done

else

   echo "Positional arguement can either be 'import' or 'export' only"

fi
