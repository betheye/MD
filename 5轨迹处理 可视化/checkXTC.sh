#!/bin/bash
#SBATCH --job-name=TRJ
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel
GMX="gmx_mpi"
# MDRUN="gmx_mpi mdrun -gpu_id 0"
# MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"
# TPR_FILE="md.tpr"
# INDEX_FILE="index.ndx"
XTC_FILE="md.xtc"

# 轨迹检查
gmx_mpi check -f "$XTC_FILE"