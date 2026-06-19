#!/bin/bash
# 15_snpeff_report.sh - flatten the SnpEff-annotated VCF to one effect per line
# and extract a tab-delimited candidate table with SnpSift (`extractFields`).
# This is the "one per line" (OPL) table behind the *_OPL.xlsx outputs.
# Stage 15 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${snpeff_ann}"

for f in $(ls *.vcf | grep -v tmp ); do

	if [ ! -e ${snpeff_report}${f%_annotated.vcf}_report.txt ] ; then

	rm -rf ${logs}snpeff_report_gen.${f%_annotated.vcf}.*.out


sbatch << EOF
#!/bin/bash
#SBATCH --cpus-per-task=${slurm_cpus}
#SBATCH --mem=${slurm_mem}
#SBATCH --time=${slurm_time}
#SBATCH -p ${slurm_partition}
#SBATCH -o ${logs}snpeff_report_gen.${f%_annotated.vcf}.%j.out
#SBATCH --job-name='snpeff_report'

cd ${container_dir}
singularity exec ${container} /bin/bash << SHI
#!/bin/bash
source ~/.bashrc

module load python/3.6.5
module load rlang/3.5.1

cd ~
source ${mimodd_env}/bin/activate

cd ${snpeff_dir}

cat ${snpeff_ann}${f} \
    | ./scripts/vcfEffOnePerLine.pl \
    | java -jar SnpSift.jar extractFields - CHROM POS REF ALT FILTER "EFF[*].EFFECT" "EFF[*].IMPACT" "EFF[*].FUNCLASS" "EFF[*].CODON" "EFF[*].AA" "EFF[*].AA_LEN" "EFF[*].GENE" "EFF[*].BIOTYPE" "EFF[*].CODING" "EFF[*].TRID" "EFF[*].RANK" "FORMAT" ${f%_annotated.vcf} "external_source_1" -e "." > ${snpeff_report}${f%_annotated.vcf}_report.txt

SHI
EOF

fi

done
