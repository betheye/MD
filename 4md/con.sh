#!/bin/bash
#SBATCH --job-name=CONT
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

# 此续跑为延续上一段参数，另起一段

module load gromacs/2023.2-gcc-9.5.0-jzxesel

GMX="gmx_mpi"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

TOP=pdb2gmx/topol.top

# 检查参数数量是否足够
if [ $# -lt 2 ]; then
    echo -e "Usage: $0 [prefix] [extend_time]"
    exit 1
fi

PREFIX="$1"
EXTEND_TIME="$2"  # 用户输入的扩展时间（单位：ps）

# 确保输出目录存在
# mkdir -p output

# 检查必需文件是否存在
if [ ! -f "output/${PREFIX}.tpr" ]; then
    echo "Error: TPR file output/${PREFIX}.tpr not found."
    exit 1
fi

if [ ! -f "output/${PREFIX}.cpt" ]; then
    echo "Error: Checkpoint file output/${PREFIX}.cpt not found."
    exit 1
fi

# 扩展模拟时间
$GMX convert-tpr -s output/${PREFIX}.tpr -extend $EXTEND_TIME -o output/${PREFIX}2.tpr

# 运行模拟
$MDRUN_GPU -v -deffnm output/${PREFIX}2 -cpi output/${PREFIX}.cpt
