#!/bin/bash
# 02_convert.sh - combine header/metadata with paired reads and convert the
# gzipped FASTQ pair into an unaligned BAM.
# Stage 02 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${data_raw}"

for f in $(ls *${read1_sufix}* | grep -v tmp ); do

	if [ ! -e ${ualn_bams}${f%${read1_sufix}}_ualn.bam ] ; then

	rm -rf ${logs}ualn_bam_gen.${f%${read1_sufix}}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}ualn_bam_gen.${f%${read1_sufix}}.%j.out
#SBATCH --job-name='mimodd_bam_convert'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ${data_raw}
source ${mimodd_env}/bin/activate

mimodd convert ${f} ${f%${read1_sufix}}${read2_sufix} --iformat gz_pe --oformat bam -t 24 -h ${headers}${f%${read1_sufix}}_header.sam -o ${ualn_bams}${f%${read1_sufix}}_ualn.bam

SHI
EOF

fi

done
