#!/bin/zsh

OUTPUT_DIR=./full_correc_output/

BONUS_MODE=0
ACTIVATE_VALGRIND=1

REPET_100=500
REPET_500=250
REPET_VALGRIND=5

MAC=0

function test_low {
	cpt=0
	fail=0
	while [ $cpt -lt $repet ]
	do
		echo -n "\r$cpt/$repet"
		ARG=`ruby -e "puts (1..$nbmax).to_a.shuffle.join(' ')"`
		RES=($valgrind $valgrind_opt $push_swap_path ${ARG})
		i=("`$RES | wc -l`")
		rep_checker="$($RES | $checker ${ARG})"
		if [ $BONUS_MODE -eq 1 ]
		then
			rep_custom="$($RES | $custom_checker ${ARG})"
			if [[ $rep_checker != $rep_custom ]]
			then
				echo "\r$RED$BOLD FAIL: Custom checker returned bad output with '$ARG' $NC"
			fi
		fi
		if [ $rep_checker = "KO" ]
		then
			echo "\r$RED$BOLD FAIL: Checker returned KO with input '$ARG' $NC"
			fail=$(($fail + 1))
		elif [ $i -gt $limit ]
		then
			echo "\r$BOLD$RED FAIL: $i operations with input '$ARG' $NC"
			fail=$(($fail + 1))
		fi
		cpt=$(($cpt + 1))
	done
	echo -n "\r$cpt/$repet"
	if [ $fail -eq 0 ]
	then
		echo "\r$GREEN SUCCESS! $NC"
	else
		echo "\r$RED$BOLD FAILED: $fail times $NC"
	fi
}

function test_ps {
	cpt=0
	total=0
	bestCase=1000000000000
	worstCase=0
	bestArg=""
	worstArg=""
	avg=0
	count_0=0
	count_1=0
	count_2=0
	count_3=0
	count_4=0
	count_5=0
	echo -n "\033[2J"
	while [ $cpt -lt $repet ]
	do
		echo "\033[0;0H\033[0J$cpt/$repet"
		echo "Best Case: $bestCase"
		echo "Average: $avg"
		echo "Worst Case: $worstCase"
		ARG=`ruby -e "puts (1..$nbmax).to_a.shuffle.join(' ')"`
		if [ $enable_valgrind -eq 1 ]
		then
			RES=($valgrind $valgrind_opt $push_swap_path ${ARG})
		else
			RES=($push_swap_path ${ARG})
		fi
		i=("`$RES | wc -l`")
		total=$(($total + $i))
		rep_checker="$($RES | $checker ${ARG})"
		if [ $BONUS_MODE -eq 1 ]
		then
			if [ $enable_valgrind -eq 1 ]
			then
				rep_custom="$($RES | $valgrind $valgrind_opt $custom_checker ${ARG})"
			else
				rep_custom="$($RES | $custom_checker ${ARG})"
			fi
			if [[ "$rep_checker" != "$rep_custom" ]]
			then
				echo "\r$RED$BOLD FAIL: Custom checker returned bad output with '$ARG' $NC"
			fi
		fi
		if [ $rep_checker = "KO" ]
		then
			echo "$RED$BOLD FAIL: Checker returned KO with input '$ARG' $NC"
		else
			if [ $i -lt $bestCase ]
			then
				bestCase=$i
				bestArg="$ARG"
			fi
			if [ $i -gt $worstCase ]
			then
				worstCase=$i
				worstArg="$ARG"
			fi
		fi
		if [ $i -le $limit0 ]
		then
			count_0=$(($count_0 + 1))
		elif [ $i -le $limit1 ]
		then
			count_1=$(($count_1 + 1))
		elif [ $i -le $limit2 ]
		then
			count_2=$(($count_2 + 1))
		elif [ $i -le $limit3 ]
		then
			count_3=$(($count_3 + 1))
		elif [ $i -le $limit4 ]
		then
			count_4=$(($count_4 + 1))
		else
			count_5=$(($count_5 + 1))
		fi
		cpt=$(($cpt + 1))
		avg=$(($total / $cpt))
	done
	echo -n "\r$cpt/$repet"
	if [ $print_result -eq 1 ]
	then
		avg=$(($total / $repet))
		if [ $avg -le $limit0 ]
		then
			echo -n "\r$GREEN"
		elif [ $avg -le $limit1 ]
		then
			echo -n "\r$GREEN_YELLOW"
		elif [ $avg -le $limit2 ]
		then
			echo -n "\r$YELLOW"
		elif [ $avg -le $limit3 ]
		then
			echo -n "\r$ORANGE"
		elif [ $avg -le $limit4 ]
		then
			echo -n "\r$RED"
		else
			echo -n "\r$BOLD$RED"
		fi
		echo "Average: $avg$NC"

		if [ $bestCase -le $limit0 ]
		then
			echo -n "\r$GREEN"
		elif [ $bestCase -le $limit1 ]
		then
			echo -n "\r$GREEN_YELLOW"
		elif [ $bestCase -le $limit2 ]
		then
			echo -n "\r$YELLOW"
		elif [ $bestCase -le $limit3 ]
		then
			echo -n "\r$ORANGE"
		elif [ $bestCase -le $limit4 ]
		then
			echo -n "\r$RED"
		else
			echo -n "\r$BOLD$RED"
		fi
		echo "Best case: $bestCase$NC"
		echo "$GRAY Best case argument can be found in best_case_${nbmax}.input $NC"
		echo "$bestArg" > ${OUTPUT_DIR}best_case_${nbmax}.input

		if [ $worstCase -le $limit0 ]
		then
			echo -n "\r$GREEN"
		elif [ $worstCase -le $limit1 ]
		then
			echo -n "\r$GREEN_YELLOW"
		elif [ $worstCase -le $limit2 ]
		then
			echo -n "\r$YELLOW"
		elif [ $worstCase -le $limit3 ]
		then
			echo -n "\r$ORANGE"
		elif [ $worstCase -le $limit4 ]
		then
			echo -n "\r$RED"
		else
			echo -n "\r$BOLD$RED"
		fi
		echo "Worst case: $worstCase$NC"
		echo "$GRAY Worst case argument can be found in worst_case_${nbmax}.input $NC"
		echo "$worstArg" > ${OUTPUT_DIR}worst_case_${nbmax}.input

		echo "Repartition:"
		echo "Below $limit0: $count_0 ($(($count_0 / $repet * 100))%)"
		echo "Between $limit0 and $limit1: $count_1 ($(($count_1 / $repet * 100))%)"
		echo "Between $limit1 and $limit2: $count_2 ($(($count_2 / $repet * 100))%)"
		echo "Between $limit2 and $limit3: $count_3 ($(($count_3 / $repet * 100))%)"
		echo "Between $limit3 and $limit4: $count_4 ($(($count_4 / $repet * 100))%)"
		echo "Above $limit4: $count_5 ($(($count_5 / $repet * 100))%)"
	else
		echo ""
	fi
}

CYAN="\033[0;36m"
GREEN="\033[0;32m"
GREEN_YELLOW="\033[38;5;155m"
YELLOW="\033[33m"
ORANGE="\033[31;1m"
RED="\033[31m"
GRAY="\033[30;1m"
BOLD="\033[1m"
NC="\033[0m"

checker="./checker_linux"
if [ $MAC -eq 1 ]
then
	checker="./checker_mac"
fi
custom_checker="./checker"
push_swap_path="./push_swap"

if [ $ACTIVATE_VALGRIND -eq 1 ]
then
	valgrind="valgrind"
	valgrind_opt="-q"
fi

RES=""
ARG=""

mkdir -p $OUTPUT_DIR

clear

echo "$CYAN ----==== PART 0: Invalid input ====---- $NC"
if [[ "`($valgrind $valgrind_opt $push_swap_path)`" != "" ]]
then
	echo "$BOLD$RED FAIL: Invalid return with no arguments $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

if [[ "`($valgrind $valgrind_opt $push_swap_path 1254)`" != "" ]]
then
	echo "$BOLD$RED FAIL: Invalid return with one argument $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

if [[ "`($valgrind $valgrind_opt $push_swap_path 1 2 3 4 5 8 e)2>&1`" != "Error" ]]
then
	echo "$BOLD$RED FAIL: Invalid return with invalid arguments $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi


if [[ "`($valgrind $valgrind_opt $push_swap_path 1 2 3 4 5 8 421 7 5 6)2>&1`" != "Error" ]]
then
	echo "$BOLD$RED FAIL: Invalid return with doubles $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

if [[ "`($valgrind $valgrind_opt $push_swap_path 1 2 3 4 5 8 -421 7 6)2>&1`" = "Error" ]]
then
	echo "$BOLD$RED FAIL: Do not support negatives $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

if [[ "`($valgrind $valgrind_opt $push_swap_path 145446546465454546545 2 3 4 5 8 -421 7 6)2>&1`" != "Error" ]]
then
	echo "$BOLD$RED FAIL: Do not output Error with numbers greater than int $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

if [[ "`($valgrind $valgrind_opt $push_swap_path 145446546465454546545 2 3 4 5 8 -421 7 6)2>&1`" != "Error" ]]
then
	echo "$BOLD$RED FAIL: Do not output Error with numbers greater than int $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

################################################################################

echo "$CYAN ----==== PART 0.5: 2 numbers ====---- $NC"

RES=($valgrind $valgrind_opt $push_swap_path 0 1)
rep_checker="$($RES | $checker 0 1)"
if [ $BONUS_MODE -eq 1 ]
then
	rep_custom="$($RES | $valgrind $valgrind_opt $custom_checker 0 1)"
	if [[ "$rep_checker" != "$rep_custom" ]]
	then
		echo "\r$RED$BOLD FAIL: Custom checker returned bad output with '$ARG' $NC"
	fi
fi
if [ $rep_checker = "KO" ]
then
	echo "$BOLD$RED FAIL: Couldn't sort '0 1' $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

RES=($valgrind $valgrind_opt $push_swap_path 1 0)
rep_checker="$($RES | $checker 1 0)"
if [ $BONUS_MODE -eq 1 ]
then
	rep_custom="$($RES | $valgrind $valgrind_opt $custom_checker 1 0)"
	if [[ "$rep_checker" != "$rep_custom" ]]
	then
		echo "\r$RED$BOLD FAIL: Custom checker returned bad output with '1 0' $NC"
	fi
fi
if [ $rep_checker = "KO" ]
then
	echo "$BOLD$RED FAIL: Couldn't sort '1 0' $NC"
else
	echo "$GREEN SUCCESS! $NC"
fi

################################################################################

echo "$CYAN ----==== PART 1: 3 numbers ====---- $NC"
repet=20
nbmax=3
limit=3
test_low

################################################################################

echo "$CYAN ----==== PART 2: 5 numbers ====---- $NC"
repet=50
nbmax=5
limit=12
test_low

################################################################################

echo "$CYAN ----==== PART 3: 100 numbers ====---- $NC"
repet=$REPET_100
nbmax=100

limit0=700
limit1=900
limit2=1100
limit3=1300
limit4=1500
enable_valgrind=0
print_result=1
echo "Press [ENTER] to continue"
read tg
test_ps

echo "$CYAN ----==== PART 3.5: 100 numbers, checking leaks ====---- $NC"
repet=$REPET_VALGRIND
enable_valgrind=1
print_result=0
echo "Press [ENTER] to continue"
read tg
test_ps

################################################################################

echo "$CYAN ----==== PART 4: 500 numbers ====---- $NC"
repet=$REPET_500
nbmax=4990

limit0=5500
limit1=7000
limit2=8500
limit3=10000
limit4=11500
enable_valgrind=0
print_result=1
echo "Press [ENTER] to continue"
read tg
test_ps

echo "$CYAN ----==== PART 4.5: 500 numbers, checking leaks ====---- $NC"
repet=$REPET_VALGRIND
enable_valgrind=1
print_result=0
echo "Press [ENTER] to continue"
read tg
test_ps

