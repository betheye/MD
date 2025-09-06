#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --partition=gpu3090
#SBATCH --qos=2gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
MDRUN="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

prefix=SECON
$MDRUN -v -s md_0_1.tpr -deffnm ${prefix} -nsteps -1 -maxh 167
#$MDRUN -v -s md_0_1.tpr -cpi ${prefix}.cpt -deffnm ${prefix} -nsteps -1 -maxh 72
