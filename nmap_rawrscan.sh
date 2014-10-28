#!/bin/bash
if [ -d $1 ]; then
	echo "Please, enter the IP of Subnet"
	read ip
else 
	ip="$1"
fi 

nmap -T4 -F -sV --open -P0 $ip -oA Fast_TCP_Verbose
cat Fast_TCP_Verbose.gnmap |grep Up |grep -v Nmap |cut -d" " -f2 > livehosts_open.txt
nmap -sT -T4 -sV -p 1-65535 --open -P0 -iL livehosts_open.txt -oA Full_TCP_Verbose

wp=`/opt/rawr/rawr.py -f Full_TCP_Verbose.xml | grep Report | cut -d " " -f 7 | cut -d "[" -f 2 | cut -d "]" -f 1 `

mv Fast_TCP_Verbose.* $wp/
mv Full_TCP_Verbose.* $wp/
mv livehosts_open.txt $wp/

echo "RAWR export located at " $wp

iceweasel $wp/index*.html &


