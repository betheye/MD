#!/bin/bash
#SBATCH --job-name=RELLLA
#SBATCH --partition=gpu4090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

start=$1
end=$2

for (( i=start; i<end; i++ ))
do
    if [ -f "frame-${i}_72run-umbrella.sh" ] && [ ! -f "output/umbrella${i}.xtc" ]; then
        bash frame-${i}_72run-umbrella.sh 
        rm frame-${i}_72run-umbrella.sh output/umbrella${i}.trr
    fi
    echo "${i}"
done
