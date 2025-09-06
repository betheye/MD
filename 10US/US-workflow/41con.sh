#!/bin/bash
#SBATCH --job-name=CONT
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

GMX="gmx_mpi"
#MDRUN="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID"
MDRUN="gmx_mpi mdrun -gpu_id 0"
#MDRUN_GPU="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID -pme gpu -nb gpu -bonded gpu -update gpu"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

TOP=pdb2gmx/topol.top

$GMX convert-tpr -s output/pull.tpr -extend 2500 -o output/pull.tpr

$MDRUN -v -deffnm output/pull -cpi output/pull.cpt -pf output/pullf.xvg -px output/pullx.xvg
