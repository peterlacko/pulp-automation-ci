#!/bin/sh
#
# This script is responsible for generating the script with variables
# based on the information inside properties file
if [ "$#" -ne 1 ]; then
    echo "usage: localSetup.sh <script_file_name>"
    exit 1
fi
 
# run this file after updating properties file
echo -n "Enter path to properties file: "
read -e PROP_FILE
read -p "Enter pulp version to test (2.6 or 2.7), default 2.6: " TESTED_VERSION
TESTED_VERSION=${TESTED_VERSION:-'2.6'}
read -p "Enter repo branch you want to use (dev or testing), default testing: " TESTED_BRANCH
TESTED_BRANCH=${TESTED_BRANCH:-'testing'}
read -p "Enter os you want to test pulp on (f22, rhel6 or rhel7), refault rhel7: " EC2_PULP_OS
EC2_PULP_OS=${EC2_PULP_OS:-'rhel7'}

TMPFILE=~/tmpfile
TMPFILE2=~/tmpfile2
 
echo "#!/bin/sh" > $1
 
grep -v "^#" $PROP_FILE | sed -e '/^$/d' > $TMPFILE
 
# escape the keys and values so they are shell friendly.
 
while read curline; do
echo $curline | awk -F = '{print $1;}' | tr '.' '_' | tr '\n' '=' >> $TMPFILE2
echo $curline | awk -F = '{print $2;}' | sed "s/'/'\"'\"'/g" | sed "s/^/\'/" | sed "s/$/\'/" >> $TMPFILE2
done < $TMPFILE
echo TESTED_VERSION=$TESTED_VERSION >> $TMPFILE2
echo TESTED_BRANCH=$TESTED_BRANCH >> $TMPFILE2
echo EC2_PULP_OS=$EC2_PULP_OS >> $TMPFILE2
 
while read curline; do
echo export $curline >> $1
done < $TMPFILE2
 
rm -f $TMPFILE $TMPFILE2
echo "Now run 'source $1' to export variables." 

chmod +x $1
