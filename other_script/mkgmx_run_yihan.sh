#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --partition=gpu3090
#SBATCH --qos=1gpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

# Define parameters and commands
#GPUID="$1"
#GMX="gmx"
GMX="gmx_mpi"
#MDRUN="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID"
MDRUN="gmx_mpi mdrun -gpu_id 0"
#MDRUN_GPU="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID -pme gpu -nb gpu -bonded gpu -update gpu"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

# Check if the number of arguments is zero
#if [ $# -eq 0 ]; then 
#    echo "mkgmx> Usage: $0 [GPU ID]; Suggested: 0"
#    exit 1
#fi

# Check if the required directory exists
[ ! -d pdb2gmx ] && echo "mkgmx> Directory pdb2gmx not found!" && exit 1 

# Check if the required files exist
#files=("pdb2gmx/ionized.gro" "pdb2gmx/topol.top" "pdb2gmx/index.ndx")
files=("pdb2gmx/ionized.gro" "pdb2gmx/topol.top")
for file in "${files[@]}"; do
    [ ! -f "$file" ] && echo "mkgmx> $file not found!" && exit 1
done

# Simulation settings
mkdir -p output
chmod -R +x /gpfs/work/bio/xiahuang/yihan/SECON/output
mini=true
double=false
heat=true
eq_npt=true
md=true

INITIAL_PDB=pdb2gmx/ionized.gro
#NDX=pdb2gmx/index.ndx
TOP=pdb2gmx/topol.top

# Function to run a simulation step
run_simulation() {
    local previous="$1"
    local prefix="$2"
    local mdp_file="$3"
    local TPR="output/${prefix}.tpr"
    rm -f $TPR
#    $GMX grompp -f $mdp_file -o $TPR -c output/${previous}.gro -r $INITIAL_PDB -n $NDX -p $TOP
    $GMX grompp -f $mdp_file -o $TPR -c output/${previous}.gro -r $INITIAL_PDB -p $TOP
    $4 -v -s $TPR -deffnm output/${prefix}
}

# Simulation steps based on the set conditions
if $mini; then
    prefix="step1_mini"
    TPR="output/${prefix}.tpr"
    rm -f $TPR
#    $GMX grompp -f mdp/step1_mini.mdp -o $TPR -c $INITIAL_PDB -r $INITIAL_PDB -n $NDX -p $TOP
    $GMX grompp -f mdp/step1_mini.mdp -o $TPR -c $INITIAL_PDB -r $INITIAL_PDB -p $TOP
    $MDRUN -v -s $TPR -deffnm output/${prefix}
fi

$double && run_simulation "step1_mini" "step1_mini_double" "mdp/step1_mini_double.mdp" "gmx_d mdrun -ntmpi 1 -ntomp 8"
$heat && run_simulation "step1_mini" "step3_annealing" "mdp/step3_annealing.mdp" "$MDRUN"
$eq_npt && run_simulation "step3_annealing" "step4_eq_npt" "mdp/step4_eq_npt.mdp" "$MDRUN"
$md && run_simulation "step4_eq_npt" "md" "mdp/step5_md.mdp" "$MDRUN_GPU"
