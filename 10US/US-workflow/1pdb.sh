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
input_pdb="pro.pdb"
input_gro="pro.gro"

# 检查当前目录下是否存在名为 pdb2gmx 的目录
if [! -d "pdb2gmx" ]; then
    # 如果不存在，则创建 pdb2gmx 目录
    mkdir pdb2gmx
fi
# 进入 pdb2gmx 目录
cd pdb2gmx

# 检查当前目录下是否存在名为 $input_pdb 的文件
if [! -f "$input_pdb" ]; then
    echo "Error: The file $input_pdb does not exist in <pdb2gmx> directory." >&2
    exit 1
fi

echo -e "8\n1\n0\n0\n0\n0\n" | $GMX pdb2gmx -f $input_pdb -ignh -ter -o $input_gro