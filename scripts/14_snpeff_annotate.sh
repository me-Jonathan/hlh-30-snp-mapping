#!/bin/bash
# 14_snpeff_annotate.sh - independently annotate the region-filtered candidates
# with a direct SnpEff run (formatted effects), as a cross-check / richer source
# for the tabular report in stage 15.
# Stage 14 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs_fil_3}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${snpeff_ann}${f%.vcf}_annotated.vcf ] ; then

	rm -rf ${logs}snpeff_annotation_fil_gen.${f%.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}snpeff_annotation_fil_gen.${f%.vcf}.%j.out
#SBATCH --job-name='snpeff_annotation'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ~
source ${mimodd_env}/bin/activate

cd ${snpeff_dir}

java -Xmx8g -jar snpEff.jar -c ${snpeff_dir}/snpEff.config ${snpeff_genome} -formatEff ${vcfs_fil_3}${f} > ${snpeff_ann}${f%.vcf}_annotated.vcf

SHI
EOF

fi

done
