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

# Ask if the user wants to collect sensor data
echo ""
read -p "Do you want to collect sensor data? (yes or no, default is yes): " sensors

# Setting default value
if [ "$sensors" = "" ]; then
	sensors="yes"
fi




# Main Loop
OIFS=$IFS
IFS=","

for workload in $workloads
do
	if [ "$workload" = "stress" ]; then
	
		# Starting sensor data collection
		if [ "$sensors" = "yes" ]; then
			sh sensor_data.sh GSA/Results/${platform}_${date}/gsa_sensor_data_${platform}_${date}.txt &
			sensor_process=$!
		fi
	
		mkdir GSA/Results/${platform}_${date}
		bash GSA/commands.txt >> GSA/Results/${platform}_${date}/report_${platform}_${date}.txt
		
		# Ending sensor data collection
		if [ "$sensors" = "yes" ]; then
			sudo kill $sensor_process
		fi

	
	elif [ "$workload" = "mlc" ]; then
	
		# Starting sensor data collection
		if [ "$sensors" = "yes" ]; then
			sh sensor_data.sh MLC/Results/${platform}_${date}/mlc_sensor_data_${platform}_${date}.txt &
			sensor_process=$!
		fi
		
		mkdir MLC/Results/${platform}_${date}
		bash MLC/commands.txt >> MLC/Results/${platform}_${date}/report_${platform}_${date}.txt
		
		# Ending sensor data collection
		if [ "$sensors" = "yes" ]; then
			sudo kill $sensor_process
		fi
	
	elif [ "$workload" = "multichase" ]; then
	
		# Starting sensor data collection
		if [ "$sensors" = "yes" ]; then
			sh sensor_data.sh MCML/Results/${platform}_${date}/mcml_sensor_data_${platform}_${date}.txt &
			sensor_process=$!
		fi
	
		mkdir MCML/Results/${platform}_${date}
		bash MCML/commands.txt >> MCML/Results/${platform}_${date}/report_${platform}_${date}.txt
		
		# Ending sensor data collection
		if [ "$sensors" = "yes" ]; then
			sudo kill $sensor_process
		fi
		
	else 
		
		echo "Invalid Workload"
		
	fi
done

IFS=$OIFS
