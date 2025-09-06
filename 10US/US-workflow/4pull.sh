#!/bin/bash
#SBATCH --job-name=THIRD
#SBATCH --partition=gpu3090
#SBATCH --qos=4gpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --gpus=1

module load gromacs/2023.2-gcc-9.5.0-jzxesel

GMX="gmx_mpi"
#MDRUN="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID"
MDRUN="gmx_mpi mdrun -gpu_id 0"
#MDRUN_GPU="gmx mdrun -ntmpi 1 -ntomp 8 -gpu_id $GPUID -pme gpu -nb gpu -bonded gpu -update gpu"
MDRUN_GPU="gmx_mpi mdrun -nb gpu -pme gpu -bonded gpu -update gpu -gpu_id 0"

TOP=pdb2gmx/topol.top

# Check if index file exists, if not, generate it
if [ ! -f "pdb2gmx/index.ndx" ]; then
    echo "Index file pdb2gmx/index.ndx does not exist, generating it..."
    # You need to replace the following command with the actual command to generate index file using gromacs
    # Here is a placeholder command, adjust it according to your gromacs version and requirements
    echo -e "q\n" | $GMX make_ndx -f output/step4_eq_npt.gro -o pdb2gmx/index.ndx
fi

# $GMX grompp -f mdp/step1_mini.mdp -c pdb2gmx/ionized.gro -p $TOP -o output/em.tpr -r pdb2gmx/ionized.gro
# $MDRUN -v -deffnm output/em

# $GMX grompp -f mdp/step4_eq_npt.mdp -c output/em.gro -p $TOP -r output/em.gro -o output/npt.tpr
# $MDRUN -v -deffnm output/npt

$GMX grompp -f mdp/md_pull.mdp -c output/npt.gro -p $TOP -r output/npt.gro -n pdb2gmx/index.ndx -t output/npt.cpt -o output/pull.tpr -maxwarn 1
$MDRUN -deffnm output/pull -pf output/pullf.xvg -px output/pullx.xvg -v

