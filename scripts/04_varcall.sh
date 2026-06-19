#!/bin/bash
# 04_varcall.sh - generate variant-call statistics and per-site coverage for
# each aligned sample (`mimodd varcall`), producing a BCF.
# Stage 04 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${bams}"

for f in $(ls *.bam | grep -v tmp ); do

	if [ ! -e ${bcfs}${f%_aln.bam}.bcf ] ; then

	rm -rf ${logs}bcfs_gen.${f%_aln.bam}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}bcfs_gen.${f%_aln.bam}.%j.out
#SBATCH --job-name='mimodd_varcall'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${bams}
source ${mimodd_env}/bin/activate

mimodd varcall ${reference_name} ${f} -o ${bcfs}${f%_aln.bam}.bcf -t 24 --verbose

SHI
EOF

fi

done
