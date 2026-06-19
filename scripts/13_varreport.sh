#!/bin/bash
# 13_varreport.sh - render the MiModD-annotated candidate VCF into a browsable
# HTML variant report (`mimodd varreport -f html`).
# Stage 13 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs_ann}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${htmls}${f%.vcf}.html ] ; then

	rm -rf ${logs}vcfs_varreport.gen.${f%.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_varreport.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_varreport'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs_ann}
source ${mimodd_env}/bin/activate

mimodd varreport ${f} -o ${htmls}${f%.vcf}.html -f html

SHI
EOF

fi

done
