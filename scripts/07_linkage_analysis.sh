#!/bin/bash
# 07_linkage_analysis.sh - run the (unfiltered) variant linkage / mapping
# analysis against the Hawaiian markers (`mimodd map VAF`), producing the
# linkage report and plot used to spot candidate regions.
# Stage 07 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${vcfs_linkage_unfil}${f%.vcf}_linkage_analysis.txt ] ; then

	rm -rf ${logs}vcfs_linkage_unfil_gen.${f%.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_linkage_unfil_gen.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_linkage_analysis'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs}
source ${mimodd_env}/bin/activate

mimodd map VAF ${f} -m ${f%.vcf} -u external_source_1 -o ${vcfs_linkage_unfil}${f%.vcf}_linkage_analysis.txt -p ${vcfs_linkage_unfil}${f%.vcf}_linkage_analysis.pdf

SHI
EOF

fi

done
