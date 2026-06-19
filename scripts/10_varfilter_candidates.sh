#!/bin/bash
# 10_varfilter_candidates.sh - genotype filter for the candidate branch: keep
# variants that are het/hom-alt in the mutant AND absent ("./.") in the
# external_source_1 background sample (`mimodd vcf-filter`). Output feeds the
# region filter (stage 11).
# Stage 10 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${vcfs_fil_2}${f} ] ; then

	rm -rf ${logs}vcfs_fil_2_gen.${f}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}vcfs_fil_2_gen.${f%.vcf}.%j.out
#SBATCH --job-name='mimodd_vcf_fil'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${vcfs}
source ${mimodd_env}/bin/activate

mimodd vcf-filter ${f} -o ${vcfs_fil_2}${f} --sample ${f%.vcf} external_source_1 --gt 0/1,1/1 ./.

SHI
EOF

fi

done
