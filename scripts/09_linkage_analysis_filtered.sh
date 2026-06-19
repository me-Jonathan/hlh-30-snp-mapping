#!/bin/bash
# 09_linkage_analysis_filtered.sh - re-run the linkage / mapping analysis on the
# genotype-filtered VCF from stage 08 (`mimodd map VAF`), giving the cleaner
# post-filter linkage report and plot.
# Stage 09 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs_fil_1}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${vcfs_linkage_fil_1}${f%.vcf}_linkage_analysis.txt ] ; then

	rm -rf ${logs}vcfs_linkage_fil_1_gen.${f%.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_linkage_fil_1_gen.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_linkage_analysis'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs_fil_1}
source ${mimodd_env}/bin/activate

mimodd map VAF ${f} -m ${f%.vcf} -u external_source_1 -o ${vcfs_linkage_fil_1}${f%.vcf}_linkage_analysis.txt -p ${vcfs_linkage_fil_1}${f%.vcf}_linkage_analysis.pdf

SHI
EOF

fi

done
