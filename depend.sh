#!/bin/sh

# date is part of the coreutils package
if command -v date >/dev/null 2>&1 ; then
	echo "date found"
else
	echo "date not found, installing now"
	sudo apt-get -y install coreutils
fi

# Script Start Date and Time (for use in file name)
date=`date +"%m-%d-%y_%T"`
has_multi="true"


# Create log file
echo "Dependency Check" > log/dependency_log_file_$date.txt
echo "Date: $date\n" >> log/dependency_log_file_$date.txt


# Function to check if a certain needed command is available, installing it if not there
checkfor() {
	if command -v $1 >/dev/null 2>&1 ; then
		echo "$1 found"
		echo "$1 found\n" >> log/dependency_log_file_$date.txt
	else
		echo "$1 not found, installing now"
		echo "$1 not found, installing now" >> log/dependency_log_file_$date.txt
		sudo apt-get -y install $1 >> log/dependency_log_file_$date.txt
		echo "\n" >> log/dependency_log_file_$date.txt
	fi
}


# Function to check if a certain file that is needed is available
checkforfile() {
	if [ -f $2 ]; then
		echo "$1 found"
		echo "$1 found\n" >> log/dependency_log_file_$date.txt
	else
		echo "$1 not found, must be installed"
		echo "$1 not found, must be installed\n" >> log/dependency_log_file_$date.txt
		has_multi="false"
	fi		
}


# Usually there
checkfor "wget"
checkfor "tar"

# Commonly missing packages

# sensors is installed using lm-sensors instead of its name 
if command -v sensors >/dev/null 2>&1 ; then
	echo "sensors found"
	echo "sensors found\n" >> log/dependency_log_file_$date.txt
else
	echo "sensors not found, installing now"
	echo "sensors not found, installing now" >> log/dependency_log_file_$date.txt
	sudo apt-get -y install lm-sensors >> log/dependency_log_file_$date.txt
	echo "\n" >> log/dependency_log_file_$date.txt
fi

# All these have the same package name as command
checkfor "stressapptest"
checkfor "make"
checkfor "git"

# Checking for multichase files
checkforfile "multichase main" "src/multichase/multichase"
checkforfile "multichase multiload" "src/multichase/multiload"
checkforfile "multichase fairness" "src/multichase/fairness"
checkforfile "multichase pingpong" "src/multichase/pingpong"

if [ $has_multi = "false" ]; then
	echo "multichase needs to be reinstalled, doing that now"
	echo "doing multichase reinstall" >> log/dependency_log_file_$date.txt
	rm -rf "src/multichase" >> log/dependency_log_file_$date.txt
	git clone https://github.com/google/multichase.git src/multichase >> log/dependency_log_file_$date.txt
	make -C src/multichase >> log/dependency_log_file_$date.txt
	echo "\n" >> log/dependency_log_file_$date.txt
fi


# MLC

if [ -f "src/mlc_v3.9a/Linux/mlc" ]; then
	echo "mlc found"
	echo "mlc found\n" >> log/dependency_log_file_$date.txt
else
	echo "mlc not found, must be manually installed"
	echo "mlc not found, must be manually installed\n" >> log/dependency_log_file_$date.txt
	
	# Removing folder if already there
	if [ -d "src/mlc_v3.9a/" ]; then
		rm -rf "src/mlc_v3.9a/"
	fi
	
	mkdir src/mlc_v3.9a >> log/dependency_log_file_$date.txt
	
	wget -q -P src/ downloadmirror.intel.com/736634/mlc_v3.9a.tgz
	tar -xf src/mlc_v3.9a.tgz -C src/mlc_v3.9a/
	
	rm src/mlc_v3.9a.tgz 
fi	

chmod +x "src/mlc_v3.9a/Linux/mlc"

