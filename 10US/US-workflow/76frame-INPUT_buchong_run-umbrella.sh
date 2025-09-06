#!/bin/bash
#SBATCH --job-name=SINGLE
#SBATCH --partition=gpu4090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

frame=0
distance=$2
num=$1

module load gromacs/2023.2-gcc-9.5.0-jzxesel
GMX="gmx_mpi"
MDRUN="gmx_mpi mdrun -gpu_id 0"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

# Short equilibration
$GMX grompp -f mdp_buchong${num}/npt_umbrella.mdp -c output/distance/conf${frame}.gro -r output/distance/conf${frame}.gro -p pdb2gmx/topol.top -n pdb2gmx/index.ndx -o output/npt${frame}_${distance}.tpr -maxwarn 3
$MDRUN -deffnm output/npt${frame}_${distance}

# Umbrella run
$GMX grompp -f mdp_buchong${num}/md_umbrella.mdp -c output/npt${frame}_${distance}.gro -r output/npt${frame}_${distance}.gro -t output/npt${frame}_${distance}.cpt -p pdb2gmx/topol.top -n pdb2gmx/index.ndx -o output/umbrella${frame}_${distance}.tpr -maxwarn 3
$MDRUN_GPU -deffnm output/umbrella${frame}_${distance} -v
