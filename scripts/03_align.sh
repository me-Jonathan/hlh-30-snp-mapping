#!/bin/bash
# 03_align.sh - align the unaligned BAM to the reference genome with the SNAP
# aligner (via `mimodd snap paired`).
# Stage 03 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${ualn_bams}"

for f in $(ls *.bam | grep -v tmp ); do

	if [ ! -e ${bams}${f%_ualn.bam}_aln.bam ] ; then

	rm -rf ${logs}aln_bam_gen.${f%_ualn.bam}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}aln_bam_gen.${f%_ualn.bam}.%j.out
#SBATCH --job-name='mimodd_bam_align'

source .bashrc
source .bash_profile

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${ualn_bams}
source ${mimodd_env}/bin/activate

mimodd snap paired ${reference} ${f} --iformat bam -o ${bams}${f%_ualn.bam}_aln.bam -t 24 --verbose

SHI
EOF

fi

done
