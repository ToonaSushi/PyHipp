#!/bin/bash

# Submit this script with: sbatch <this-filename>

#SBATCH --time=5:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --cpus-per-task=1   # number of CPUs for this task
#SBATCH -J "quiz1-slurm"   # job name

## /SBATCH -p general # partition (queue)
#SBATCH -o quiz1-slurm.%N.%j.out # STDOUT
#SBATCH -e quiz1-slurm.%N.%j.err # STDERR

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
/data/miniconda3/bin/conda init
source ~/.bashrc
envarg=`/data/src/PyHipp/envlist.py`
conda activate $envarg

python -u -c "import PyHipp as pyh; \
import time; \
DPT.objects.processDirs(dirs=None, objtype=pyh.Unity, saveLevel=1)
from PyHipp import mountain_batch; \
mountain_batch.mountain_batch(); \
from PyHipp import export_mountain_cells; \
export_mountain_cells.export_mountain_cells(); \
print(time.localtime());"

conda deactivate 
/data/src/PyHipp/envlist.py $envarg

aws sns publish --topic-arn arn:aws:sns:ap-southeast-1:180294188152:awsnotify --message "Quiz1JobDone"
