#!/bin/bash
#SBATCH --job-name=RELLLA
#SBATCH --partition=gpu3090
#SBATCH --qos=2gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

for (( i=239; i<501; i++ ))
do
    if [ -f "frame-${i}_run-umbrella.sh" ]; then
        bash frame-${i}_run-umbrella.sh   
    fi
done