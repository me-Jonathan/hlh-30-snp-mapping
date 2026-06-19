#!/bin/bash
# 11_region_filter.sh - restrict candidate variants to the linked chromosomal
# region(s) for each strain (`mimodd vcf-filter --region`). Input is the
# genotype-filtered VCF from stage 10 (vcfs_fil_2); output goes to vcfs_fil_3,
# which is then annotated (stages 12-15).
# Stage 11 of the HLH-30 SNP-mapping pipeline. See docs/pipeline.md.
#
# IMPORTANT - this is a MANUAL, per-strain step, not an automated loop. The
# region(s) below were determined by eye from each strain's linkage analysis
# (stages 07/09) and are the values that produced the published candidate
# tables. They are reproduced verbatim from the per-sample READMEs and are also
# listed in docs/region_filters.md. Confirm the exact input/output VCF names
# against your filesystem before running. Run this with the MiModD environment
# already activated (see the header of any stage script for the activation
# command).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/config.sh"

cd "${vcfs_fil_2}"

# --- Strain 39  (sample S26) ----------------------------------------------
mimodd vcf-filter S26.vcf  -o ${vcfs_fil_3}S26.vcf  --region chrI:1500000-3000000 chrIII:5000000-10000000

# --- Strain 109 (sample S134) ---------------------------------------------
mimodd vcf-filter S134.vcf -o ${vcfs_fil_3}S134.vcf --region chrI:1000000-4000000

# --- Strain 71  (sample S135) ---------------------------------------------
mimodd vcf-filter S135.vcf -o ${vcfs_fil_3}S135.vcf --region chrI:1000000-7000000

# --- Strain 40  (sample S136) ---------------------------------------------
mimodd vcf-filter S136.vcf -o ${vcfs_fil_3}S136.vcf --region chrI:1000000-3000000 chrIV:2500000-5000000 chrIV:12000000-15500000

# --- Strain 43  (sample S137) ---------------------------------------------
mimodd vcf-filter S137.vcf -o ${vcfs_fil_3}S137.vcf --region chrI:1000000-3500000 chrIII:0-1000000

# --- Strain A1  (sample S25) ----------------------------------------------
# NOTE: no region filter is documented in the source READMEs for S25/A1.
# A candidate table (S25_filter_annotated*.xlsx) nonetheless exists, so the
# region used here is unknown. Fill in and uncomment once confirmed:
# mimodd vcf-filter S25.vcf -o ${vcfs_fil_3}S25.vcf --region <chr:start-end>
