#!/bin/bash
# 08_varfilter_genotype.sh - keep only variants that are het or hom-alt in the
# mutant sample (`mimodd vcf-filter --gt 0/1,1/1`). The filtered VCF feeds the
# post-filter linkage analysis (stage 09).
# Stage 08 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${vcfs_fil_1}${f} ] ; then

	rm -rf ${logs}vcfs_fil_1_gen.${f}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_fil_1_gen.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_vcf_fil'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs}
source ${mimodd_env}/bin/activate

mimodd vcf-filter ${f} -o ${vcfs_fil_1}${f} --sample ${f%.vcf} --gt 0/1,1/1

SHI
EOF

fi

done
