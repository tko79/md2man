#!/bin/bash

# md2man - Yet another md2man tool
# Copyright (C) 2017  Torsten Koschorrek
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

license=$(cat <<EOF
md2man  Copyright (C) 2017  Torsten Koschorrek

This program comes with ABSOLUTELY NO WARRANTY. This is free software, and you
are welcome to redistribute it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
EOF
)

filename=$1
outfile=${filename%".md"}".1"

echo -e "$license"
echo -e ""

# checking if first parameter is a valid file (expecting markdown file with suffix .md)

echo -n "checking if first parameter is a valid file (expecting markdown file with suffix .md) ..."
if [ ! -e $filename ]; then
    echo " file not found!"
    exit 1
fi
echo " done."

# reading header info (header format (e.g. title): [//]: # (title:<title>) )

echo -n "reading header info ..."
#
title=$(grep "\[\/\/\]: # (title:" $filename | awk -F: '{ print $3 }' | awk -F')' '{ print $1 }')
section=$(grep "\[\/\/\]: # (section:" $filename | awk -F: '{ print $3 }' | awk -F')' '{ print $1 }')
description=$(grep "\[\/\/\]: # (description:" $filename | awk -F: '{ print $3 }' | awk -F')' '{ print $1 }')
echo " done."

echo ""
echo "title:\""$title"\""
echo "section:\""$section"\""
echo "description:\""$description"\""
echo ""

# executing pandoc to convert markdown to man page

echo -n "executing pandoc to convert markdown to man page ..."
pandoc --variable=title:$title --variable=section:$section --variable=date:$(date "+%Y-%m-%d") --variable=description:$description --standalone -t man -o $outfile $filename
echo " done."
