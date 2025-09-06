#!/bin/bash
#SBATCH --job-name=DIS
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

#################################################
# get_distances.sh
#
#   Script iteratively calls gmx distance and
#   assembles a series of COM distance values
#   indexed by frame number, for use in
#   preparing umbrella sampling windows.
#
# Written by: Justin A. Lemkul, Ph.D.
#    Contact: jalemkul@vt.edu
#
#################################################

module load gromacs/2023.2-gcc-9.5.0-jzxesel
alias gmx='/gpfs/spack/opt/linux-rocky8-icelake/gcc-9.5.0/gromacs-2023.2-jzxeselj2n5xcx3uozwap5zgemorxohk/bin/gmx_mpi'

# mkdir output/distance
# echo 0 | gmx_mpi trjconv -s output/pull.tpr -f output/pull.xtc -o output/distance/conf.gro -sep

# compute distances
for (( i=0; i<2501; i++ ))
do
    gmx_mpi distance -s output/pull.tpr -f output/distance/conf${i}.gro -n pdb2gmx/index.ndx -select 'com of group "a_1160-1209" plus com of group "r_5293"' -oall output/dist${i}.xvg 
done

# compile summary
touch summary_distances.dat
for (( i=0; i<2501; i++ ))
do
    d=`tail -n 1 output/dist${i}.xvg | awk '{print $2}'`
    echo "${i} ${d}" >> summary_distances.dat
    rm output/dist${i}.xvg
done

exit;
