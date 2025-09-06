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
TPR="output/pull.tpr"
XTC="output/pull.xtc"
CLUSTER="output/pull_cluster.xtc"
INI="output/pull_0ns.pdb"

echo "18\n" | $GMX trjconv -s $TPR -f $XTC -o $INI -dump 0
echo -e "1\n1\n18\n" | $GMX trjconv -s $TPR -f $XTC -o $CLUSTER -center -pbc cluster -ur compact

echo -e "4\n4\n" | $GMX rms -s $TPR -f $XTC -o output/pull_rmsd.xvg -tu ns
#需要cluster之后生成rmsd，否则有pbc影响（一下跳到很高、、）
# cluster 通过选择cluster的对象，把多个聚在一起，这个不发生pbc。因此，适用于多聚体、多条链.

# $GMX trjconv -f $XTC -s $TPR -o 0ps_au.pdb -dump 0
