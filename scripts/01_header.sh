#!/bin/bash
# 01_header.sh - generate a SAM read-group header for each sequenced sample.
# Stage 01 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.
#
# For every "<sample>_1.fastq.gz" in data_raw, submit a SLURM job that runs
# `mimodd header` inside the Singularity container, writing <sample>_header.sam.
# Re-running only processes samples whose header does not yet exist.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${data_raw}"

for f in $(ls *${read1_sufix}* | grep -v tmp ); do

	if [ ! -e ${headers}${f%${read1_sufix}}_header.sam ] ; then

	rm -rf ${logs}header_gen.${f%${read1_sufix}}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}header_gen.${f%${read1_sufix}}.%j.out
#SBATCH --job-name='mimodd_sam_headers'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ~/
source ${mimodd_env}/bin/activate

mimodd header --rg-id ${f:0:6} --rg-sm ${f%${read1_sufix}} --rg-cn "CCG" -o ${headers}${f%${read1_sufix}}_header.sam

SHI
EOF

fi

done
