#!/bin/bash - 
#===============================================================================
#
#          FILE: buildMonDB.sh
# 
#         USAGE: ./buildMonDB.sh 
# 
#   DESCRIPTION: Turn the Monster Manual PDF into JSON
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Dusty Carver (), 
#  ORGANIZATION: 
#       CREATED: 04/13/2018 16:00
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
#ggrep "Initiative +[0-9]" monman2.txt > Monsters
#Had to delete this last line, it was output from grep about the file
#gsed '$d' Monsters
IFS=$'\n'
n=0
echo "["
#exit
for i in $(cat Monsters); do 
echo "{"
    #echo $i;
    echo "\"id\" : \"$n\","
    #Names are not included in the Table in the PDF
    echo '"name": "",'
    #Add Description Keyword, Then Grab Description, Put in quotes
    printf "\"Description\": \""; echo $i | ggrep -o '.* Initiative +[0-9]\+' | gsed 's/Initiative.*//' | gsed 's/$/",/'
    #Grab And Change Inititive to quoted JSON Format
    echo $i | ggrep -o 'Initiative +[0-9]\+' | gsed 's/Initiative /"Initiative": "/' | gsed 's/$/",/'
    #Grab and Change Level
    echo $i | ggrep -o 'Level +[0-9]\+' | gsed 's/Level /"Level": "/' | gsed 's/$/",/'
    #Grab and Change Senses
    echo $i | ggrep -o 'Senses.*HP' | gsed 's/HP$//' | gsed 's/Senses /"Senses":"/' | gsed 's/$/",/'
    #Grab and Change hp
    echo $i | ggrep -o 'HP [0-9]\+' | gsed 's/HP /"HP": "/' | gsed 's/$/",/'
    #Other health is a big category and requires some additional work, grab all the information, remove any quotes
    #Printf so it's on the same line
    printf '"Other Health": "';
    #Printf again, Command substitue the echo, greps and seds, that get it to where you want it, then transpose all the quotes to deleted
    printf "$(echo $i | ggrep -o 'HP [0-9]\+.*AC [0-9]\+' | gsed 's/HP [0-9]\+ //' | gsed 's/AC [0-9]\+$//' | gsed 's/^; //' | tr -d '"' )\""
    echo ","
    #Grab and Change AC
    echo $i | ggrep -o 'AC [0-9]\+' | gsed 's/AC /"AC": "/' | gsed 's/$/",/'
    #Grab and Change Fortitude
    echo $i | ggrep -o 'Fortitude [0-9]\+'| gsed 's/Fortitude /"Fortitude": "/' | gsed 's/$/",/'
    #Grab and Change Reflex
    echo $i | ggrep -o 'Reflex [0-9]\+'| gsed 's/Reflex /"Reflex": "/' | gsed 's/$/",/'
    #Grab and Change Will
    echo $i | ggrep -o 'Will [0-9]\+'| gsed 's/Will /"Will": "/' | gsed 's/$/",/'
    #Grab and Damage
    COUNTER=1
    echo $i | for b in $(ggrep -o '[0-9]d[0-9A-Za-z +]\+ damage'); do echo $b |  gsed "s/^/\"Damage $COUNTER\": \"/" | gsed 's/$/",/'; COUNTER=$[$COUNTER +1]; done ; 
    #Grab Perception
    echo $i | ggrep -o 'Perception +[0-9]\+' | gsed 's/Perception /"Perception": "/' | gsed 's/$/",/'
    #Grab and Change Speed
    echo $i | ggrep -o 'Speed [0-9]\+'| gsed 's/Speed /"Speed": "/' | gsed 's/$/",/'
    #Other Abilities is a lot of information, again grab it all and remove any quotes
    printf '"Other Abilities": "'
    #Printf again, Command substitue the echo, greps and seds, that get it to where you want it, then transpose all the quotes to deleted
    printf "$(echo $i | ggrep -o 'Speed [0-9]\+.*' | gsed 's/Speed [0-9]\+//' | gsed 's/ m.//' | tr -d '"' )\""
    echo "},"

    #iterate our id number
    n=$(($n + 1))
done
echo "]"
