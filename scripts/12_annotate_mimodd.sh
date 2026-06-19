#!/bin/bash
# 12_annotate_mimodd.sh - annotate the region-filtered candidate variants with
# affected-gene / effect information via MiModD's SnpEff wrapper
# (`mimodd annotate`).
# Stage 12 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs_fil_3}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${vcfs_ann}${f%.vcf}_annotated.vcf ] ; then

	rm -rf ${logs}vcfs_ann_gen.${f%.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_ann_gen.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_vcf_annotate'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs_fil_3}
source ${mimodd_env}/bin/activate

mimodd annotate ${f} ${snpeff_genome} -o ${vcfs_ann}${f%.vcf}_annotated.vcf

SHI
EOF

fi

done
