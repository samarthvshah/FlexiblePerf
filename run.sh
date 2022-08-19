#!/bin/sh

# Script Start Date and Time (for use in file name)
date=`date +"%m-%d-%y_%H-%M-%S"`

# Ask what platform the system is on
echo ""
read -p "What platform is the system running on? (intel or amd, default is amd): " platform


if [ "$platform" = "intel" ]; then

	# Ask which of the workloads the user would like to run
	echo ""
	echo "_____________________________________________"
	echo "| stress     | StressAppTest                |"
	echo "| multichase | Multichase + Multiload       |"
	echo "| mlc        | Intel Memory Latency Checker |"
	echo "| all        | Run all Workloads            |"
	echo "|____________|______________________________|"
	read -p "What workloads do you want to run? (enter a comma-seperated list with the left side names above): " workloads

	# Convert all to all workloads
	if [ "$workloads" = "all" ]; then
		workloads="stress,multichase,mlc"
	fi

elif [ "$platform" = "amd" ]; then

	# Ask which of the workloads the user would like to run
	echo ""
	echo "_____________________________________________"
	echo "| stress     | StressAppTest                |"
	echo "| multichase | Multichase + Multiload       |"
	echo "| all        | Run all Workloads            |"
	echo "|____________|______________________________|"
	read -p "What workloads do you want to run? (enter a comma-seperated list with the left side names above): " workloads

	# Convert all to all workloads
	if [ "$workloads" = "all" ]; then
		workloads="stress,multichase"	
	fi	
	
else 
	echo "Invalid Platform"
	exit
	
fi



# Main Loop
OIFS=$IFS
IFS=","

for workload in $workloads
do
	if [ "$workload" = "stress" ]; then
	
		bash GSA/commands.txt >> GSA/Results/report_${platform}_${date}.txt
	
	elif [ "$workload" = "mlc" ]; then
		
		bash MLC/commands.txt >> MLC/Results/report_${platform}_${date}.txt
	
	elif [ "$workload" = "multichase" ]; then
	
		bash MCML/commands.txt >> MCML/Results/report_${platform}_${date}.txt
		
	else 
		
		echo "Invalid Workload"
		
	fi
done

IFS=$OIFS
