#!/bin/bash
# 06_varextract.sh - extract variant sites from the BCF into a VCF, seeding the
# linkage panel with the Hawaiian (CB4856) marker SNPs (`mimodd varextract -p`).
# Stage 06 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${bcfs}"

for f in $(ls *.bcf | grep -v tmp ); do

	if [ ! -e ${vcfs}${f%.bcf}.vcf ] ; then

	rm -rf ${logs}vcfs_gen.${f%.bcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_gen.${f%.bcf}.%j.out
#SBATCH --job-name='mimodd_varextract'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${bcfs}
source ${mimodd_env}/bin/activate

mimodd varextract ${f} -p ${ha_snps} -o ${vcfs}${f%.bcf}.vcf --verbose

SHI
EOF

fi

done
