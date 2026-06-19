#!/bin/bash
# 00_merge_fastq.sh - (optional) concatenate per-lane FASTQ files into a single
# read pair per sample, before stage 01.
# Stage 00 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.
#
# Sequencing cores often deliver one FASTQ pair per lane. gzip streams can be
# concatenated directly, so this just `cat`s a sample's lane files into one
# "<sample>_1.fastq.gz" / "<sample>_2.fastq.gz" pair. This is a TEMPLATE: edit
# the sample list and lane glob to match your delivery. Skip this stage if your
# reads already arrive as a single pair per sample.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${data_raw}"

# Replace these with your own sample identifiers.
samples=(SAMPLE_A SAMPLE_B)

for sample in "${samples[@]}"; do
    cat "${sample}"_*_R1_*.fastq.gz > "${sample}${read1_sufix}"
    cat "${sample}"_*_R2_*.fastq.gz > "${sample}${read2_sufix}"
done
