#!/bin/bash
#SBATCH --job-name=WHA
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

# 切换到输出目录
cd output

# 列出所有 umbrella*.tpr 文件，并将其保存到 tpr-files.dat
ls umbrella*.tpr -1 > tpr-files.dat

# 列出所有 umbrella*_pullf.xvg 文件，并将其保存到 pullf-files.dat
ls umbrella*_pullf.xvg -1 > pullf-files.dat

# 运行 gmx_mpi wham
gmx_mpi wham -it tpr-files.dat -if pullf-files.dat -o -hist -unit kCal
