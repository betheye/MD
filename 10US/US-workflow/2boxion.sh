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
input_gro="com.gro"

cd pdb2gmx

$GMX editconf -f $input_gro -o newbox.gro -center 3.391 6.391 6.391 -box 26.565 13.565 13.565
# 需要VMD检查盒子正确？

$GMX solvate -cp newbox.gro -cs spc216.gro -o solv.gro -p topol.top

cat > ions.mdp << EOF
integrator  = md
dt          = 0.001
nsteps      = 50000
nstlist         = 1
cutoff-scheme   = Verlet
ns_type         = grid
coulombtype     = PME
rcoulomb        = 1.0
rvdw            = 1.0
pbc             = xyz
EOF

$GMX grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr -maxwarn 1

echo -e "15\n" | $GMX genion -s ions.tpr -o ionized.gro -p topol.top -pname NA -nname CL -neutral -conc 0.1
# 15: SOL

