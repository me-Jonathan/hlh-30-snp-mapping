#!/bin/bash
# 05_delcall.sh - call deletions from the aligned BAM + BCF (`mimodd delcall`).
# Stage 05 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.
#
# Deletion calling is not required for mapping-by-sequencing; it is included as
# an optional extra in case the larger structural variants are of interest.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${bams}"

for f in $(ls *.bam | grep -v tmp ); do

	if [ ! -e ${dels}${f%_aln.bam}_deletions.txt ] ; then

	rm -rf ${logs}delcall_gen.${f%_aln.bam}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}delcall_gen.${f%_aln.bam}.%j.out
#SBATCH --job-name='mimodd_delcall'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${bams}
source ${mimodd_env}/bin/activate

mimodd delcall ${f} ${bcfs}${f%_aln.bam}.bcf -o ${dels}${f%_aln.bam}_deletions.txt --max-cov 4 --min-size 100

SHI
EOF

fi

done
