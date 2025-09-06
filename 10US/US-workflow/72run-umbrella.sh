#!/bin/bash
#SBATCH --job-name=RELLLA
#SBATCH --partition=gpu4090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

GMX="gmx_mpi"
# MDRUN="gmx_mpi mdrun -gpu_id 0"
# MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

# Short equilibration
$GMX grompp -f mdp/npt_umbrella.mdp -c output/distance/confXXX.gro -r output/distance/confXXX.gro -p pdb2gmx/topol.top -n pdb2gmx/index.ndx -o output/nptXXX.tpr -maxwarn 3
$GMX mdrun -v -deffnm output/nptXXX

# Umbrella run
$GMX grompp -f mdp/md_umbrella.mdp -c output/nptXXX.gro -r output/nptXXX.gro -t output/nptXXX.cpt -p pdb2gmx/topol.top -n pdb2gmx/index.ndx -o output/umbrellaXXX.tpr -maxwarn 3
$GMX mdrun -v -deffnm output/umbrellaXXX
