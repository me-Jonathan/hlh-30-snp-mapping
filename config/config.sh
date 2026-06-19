# shellcheck shell=bash
# ============================================================================
# config.sh - central configuration for the HLH-30 SNP-mapping pipeline
# ----------------------------------------------------------------------------
# All scripts in scripts/ source this file. Edit the values below to match
# your own compute environment; the pipeline logic itself does not change.
#
# NOTE ON PROVENANCE: the values committed here are the ones actually used for
# the published analysis (project "20221020_WGS" on a SLURM + Singularity
# HPC cluster). They are kept as documented defaults; adapt them for re-use.
# ============================================================================

# --- Project root ----------------------------------------------------------
# PROJECT_ROOT is derived from $HOME, so no absolute/site-specific home path is
# hardcoded. Point it elsewhere by overriding PROJECT_ROOT if needed.
project="20221020_WGS"
PROJECT_ROOT="${HOME}/${project}"

# --- Working directories (one per pipeline stage) --------------------------
# Trailing slashes are intentional: scripts reference these as "${var}filename".
data_raw="${PROJECT_ROOT}/data_raw/"
headers="${PROJECT_ROOT}/headers/"
logs="${PROJECT_ROOT}/logs/"
ualn_bams="${PROJECT_ROOT}/ualn_bams/"
bams="${PROJECT_ROOT}/bams/"
bcfs="${PROJECT_ROOT}/bcfs/"
dels="${PROJECT_ROOT}/dels/"
vcfs="${PROJECT_ROOT}/vcfs/"
vcfs_linkage_unfil="${PROJECT_ROOT}/vcfs_linkage_unfil/"
vcfs_fil_1="${PROJECT_ROOT}/vcfs_fil_1/"
vcfs_linkage_fil_1="${PROJECT_ROOT}/vcfs_linkage_fil_1/"
vcfs_fil_2="${PROJECT_ROOT}/vcfs_fil_2/"
vcfs_fil_3="${PROJECT_ROOT}/vcfs_fil_3/"
vcfs_ann="${PROJECT_ROOT}/vcfs_ann/"
htmls="${PROJECT_ROOT}/htmls/"
snpeff_ann="${PROJECT_ROOT}/snpeff_ann/"
snpeff_report="${PROJECT_ROOT}/snpeff_report/"

# --- Reference / annotation resources --------------------------------------
ref_dir="${PROJECT_ROOT}/reference_files"
reference_name="WBcel235_clean.fa"          # MiModD-sanitised WBcel235 (ce11) genome
reference="${ref_dir}/${reference_name}"
ha_snps="${ref_dir}/HA_SNPs_WBcel235.vcf"   # Hawaiian (CB4856) SNP panel, WBcel235 coords
snpeff_genome="WBcel235.99"                 # SnpEff / MiModD annotation database

# --- FASTQ read-pair suffixes ----------------------------------------------
read1_sufix="_1.fastq.gz"
read2_sufix="_2.fastq.gz"

# --- Software locations -----------------------------------------------------
mimodd_env="${HOME}/software/mimodd"        # MiModD virtualenv (activate script lives here)
snpeff_dir="${HOME}/software/snpEff"        # SnpEff installation (snpEff.jar, SnpSift.jar)

# --- Singularity container --------------------------------------------------
# Site-specific shared container path; change to wherever your image lives.
container_dir="/path/to/singularity"
container="bioinformatics_software.v2.0.6.sif"

# --- SLURM resource request -------------------------------------------------
# slurm_partition is the cluster queue name; set it to one of your site's partitions.
slurm_partition="default"
slurm_cpus="32"
slurm_mem="24gb"
slurm_time="3-24"
