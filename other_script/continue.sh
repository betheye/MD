#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --partition=gpu3090
#SBATCH --qos=1gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

# Define parameters and commands
#GPUID="$1"
#GMX="gmx"
GMX="gmx_mpi"
#MDRUN="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID"
MDRUN="gmx_mpi mdrun -gpu_id 0"
#MDRUN_GPU="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID -pme gpu -nb gpu -bonded gpu -update gpu"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

$GMX convert-tpr -s output/md.tpr -extend 1000000 -o output/md.tpr
$MDRUN_GPU -v -s output/md.tpr -cpi output/md.cpt -deffnm output/md