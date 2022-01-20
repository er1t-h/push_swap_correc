#!/bin/zsh

RES=""
TOT=0
cpt=0
max=${1:-100}
nb=$((${2:-100} - 1))
max_op=10000000000000
if [ $nb -eq 99 ]
then
	max_op=699
elif [ $nb -eq 499 ]
then
	max_op=5499
fi
clear
ko=0
pc=0
pArg=""
mc=1000000000000
mArg=""
while [ $cpt -lt $max ]
do
	ARG=`ruby -e "puts (0..$nb).to_a.shuffle.join(' ')"`
	RES=(./push_swap ${ARG})
	i=("`$RES | wc -l`")
	TOT=$(($TOT + $i))
	if [ $i -gt $max_op ]
	then
		ko=$(($ko+1))
	fi
	if [ $pc -lt $i ]
	then
		pc=$i
		pArg="${ARG}"
	fi
	if [ $mc -gt $i ]
	then
		mc=$i
		mArg="${ARG}"
	fi
	if [ "$($RES | ./checker_linux ${ARG})" = "KO" ]
	then
		echo ${ARG} | xclip -sel clip
		echo "Petit probleme... Input: ${ARG}"

		exit 1
	fi
	echo -n "\r${cpt}/$max ($ko failed)"
	cpt=$(($cpt+1))
done
echo -n "\rAverage: "
echo $TOT/$max | bc -l
echo "Best case: $mc"
echo "Worst case: $pc"
if [[ $nb -eq 99 || nb -eq 499 ]]
then
	if [ $ko -eq 0 ]
	then
		echo "wow. i'm amazed."
	else
		echo "push_swap outputed $ko times more than $max_op instructions"
	fi
fi
echo "----------------"
echo "Best case: $mArg"
echo "Worst case: $pArg"
echo "${mArg}" | xclip
echo "${pArg}" | xclip -sel clip
