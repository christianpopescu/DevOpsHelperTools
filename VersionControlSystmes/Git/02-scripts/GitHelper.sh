#!/bin/bash

function check_git_status() {
    local  __resultvar=$2
    cd "$1"
    if git status | grep -q 'nothing to commit, working tree clean'; then
                echo $1 " -> Clean"
                local myresult="C"
    else
                echo $1 " -> NOT Clean "
                local myresult="N"
    fi
    cd ..
    eval $__resultvar="'$myresult'"

}
function git_pull() {
    cd "$1"
    git pull
    cd ..
}

cwd=$(pwd)

shopt -s nullglob
array=(*/)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later
#echo "${array[@]}"  # Note double-quotes to avoid extra parsing of funny characters in filenames

clean_structure="Y"
for f in "${array[@]}"
do
    check_git_status "$f" result
    if [ "$result" == "N" ]
    then
                clean_structure="N"
    fi
done
if [ "$clean_structure" == "N" ]
then
    echo "Not a clean structure"
    exit 1
fi
echo "Clean structure -> proceed with pull"
for f in "${array[@]}"
do
    git_pull "$f"
done


exit 0
