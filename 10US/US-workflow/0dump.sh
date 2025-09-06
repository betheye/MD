#!/bin/bash
#SBATCH --job-name=TRJ
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

# module load gromacs/2023.2-gcc-9.5.0-jzxesel
GMX="gmx"
input_pdb="pro.pdb"
au_gro="au.gro"
md_XTC="md_cluster.xtc"
md_pro="md_0ns.pdb"

# 导出200ns的pro
echo "1\n" | $GMX trjconv -f $md_XTC -s $md_pro -o $input_pdb -dump 200000

# 导出200ns的aunp
echo "13\n" | $GMX trjconv -f $md_XTC -s $md_pro -o $au_gro -dump 200000


