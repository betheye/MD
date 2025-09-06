#!/bin/bash
#SBATCH --job-name=US
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

./71setupUmbrella.py summary_distances.dat 0.2 72run-umbrella.sh &> caught-output.txt

sbatch 73gAndm.sh 0 1300

sbatch 73gAndm.sh 1300 1700

sbatch 73gAndm.sh 1700 2100

sbatch 73gAndm.sh 2100 2501