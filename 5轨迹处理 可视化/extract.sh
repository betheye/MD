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

tpr_file="md.tpr"
input_file="md.xtc"
output_file="md_cluster.xtc"

echo "18\n" | $GMX trjconv -s $tpr_file -f $input_file -o 0ns.pdb -dump 0
# echo "18\n" | $GMX trjconv -s $tpr_file -f $input_file -o 200ns.pdb -dump 200000
#-dump 是时间，单位是ps，1ns = 1000ps

echo -e "1\n1\n18\n" | $GMX trjconv -s $tpr_file -f $input_file -o $output_file -center -pbc cluster -ur compact  -dt 1000
# 适用于轨迹为200ns，saving every 2000th frame 
# center for protein #1
# pbc cluster for protein #1
# output non-water #18
# ur compact for 2 chains
# cluster 通过选择cluster的对象，把多个聚在一起，这个不发生pbc。因此，适用于多聚体、多条链

# {
#     echo "1"  # 第一次选择分组 1
#     echo "0"  # 第三次选择分组 0
# } | gmx_mpi trjconv -s md.tpr -f $input_file -o $output_file -center -pbc mol -ur compact
# mol: molecule 整个分子，据GPT说是chain1算一个molecule ...
# gmx_mpi trjconv -s md.tpr -f md.xtc -o md_0_1_noPBC.xtc -center -pbc mol -ur compact

# # 检查输出文件是否生成
# if [ -f "$output_file" ]; then
#     # 使用 printf 自动选择分组 0
#     gmx trjconv -f $output_file -o trj_40-50ns.xtc -b 40000 -e 50000
# else
#     echo "Error: $output_file not found!"
# fi