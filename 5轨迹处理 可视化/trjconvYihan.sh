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

echo -e "1\n1\n18\n" | $GMX trjconv -s md.tpr -f md.xtc -o md_cluster.xtc -center -pbc cluster -ur compact  -dt 2000
# 适用于轨迹为200ns，saving every 2000th frame 
# center for protein #1
# pbc cluster for protein #1
# output non-water #18
# ur compact for 2 chains