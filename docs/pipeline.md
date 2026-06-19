# Pipeline walkthrough

This pipeline performs Hawaiian (CB4856) SNP-based mapping-by-sequencing in
*C. elegans* to identify the causative mutation(s) behind a forward-genetic
screen phenotype. It is built on [MiModD](https://mimodd.readthedocs.io/) and
[SnpEff](https://pcingola.github.io/SnpEff/), and was run on a SLURM +
Singularity HPC cluster.

## How the scripts are organised

- Each stage is a numbered script in `scripts/`.
- Stages 01–10 and 12–15 are **batch submitters**: they loop over the input
  files of a stage and `sbatch` one SLURM job per file (wrapped in a
  `singularity exec` of the analysis container). They are idempotent: a file
  whose output already exists is skipped, so a stage can be re-run safely.
- Stage 00 (lane merging) and stage 11 (region filtering) are **manual /
  per-sample** steps, not loops. Stage 11 is the one place where strain-specific,
  result-determining values live (see [region_filters.md](region_filters.md)).
- All paths, the reference genome, the container, and the SLURM resource request
  are defined once in [`config/config.sh`](../config/config.sh). Edit that file
  to run elsewhere; the stage scripts themselves do not need changing.

## Reference resources

| Resource | Value |
|---|---|
| Reference genome | `WBcel235` (ce11), MiModD-sanitised → `WBcel235_clean.fa` |
| Hawaiian marker panel | `HA_SNPs_WBcel235.vcf` (CB4856 SNPs in WBcel235 coords) |
| Annotation database | `WBcel235.99` (SnpEff / MiModD) |

## Stages

| # | Script | Tool | Purpose |
|---|--------|------|---------|
| 00 | `00_merge_fastq.sh` | `cat` | *(optional)* merge per-lane FASTQs into one read pair per sample |
| 01 | `01_header.sh` | `mimodd header` | build a SAM read-group header per sample |
| 02 | `02_convert.sh` | `mimodd convert` | merge header + paired reads → unaligned BAM |
| 03 | `03_align.sh` | `mimodd snap paired` | align reads to `WBcel235_clean.fa` |
| 04 | `04_varcall.sh` | `mimodd varcall` | variant-call statistics + coverage → BCF |
| 05 | `05_delcall.sh` | `mimodd delcall` | *(optional)* call deletions (`--max-cov 4 --min-size 100`) |
| 06 | `06_varextract.sh` | `mimodd varextract` | extract variant sites → VCF, seeding the Hawaiian marker panel (`-p`) |
| 07 | `07_linkage_analysis.sh` | `mimodd map VAF` | linkage/mapping analysis + plot (unfiltered) |
| 08 | `08_varfilter_genotype.sh` | `mimodd vcf-filter` | keep het/hom-alt in the mutant (`--gt 0/1,1/1`) |
| 09 | `09_linkage_analysis_filtered.sh` | `mimodd map VAF` | linkage/mapping analysis + plot (post genotype filter) |
| 10 | `10_varfilter_candidates.sh` | `mimodd vcf-filter` | het/hom-alt in mutant **and** absent in background (`--gt 0/1,1/1 ./.`) |
| 11 | `11_region_filter.sh` | `mimodd vcf-filter` | manually restrict to the linked region(s) per strain (`--region`) |
| 12 | `12_annotate_mimodd.sh` | `mimodd annotate` | annotate candidates with gene/effect info (`WBcel235.99`) |
| 13 | `13_varreport.sh` | `mimodd varreport` | render an HTML variant report |
| 14 | `14_snpeff_annotate.sh` | `SnpEff` | independent SnpEff annotation (formatted effects) |
| 15 | `15_snpeff_report.sh` | `SnpSift` | flatten to one-effect-per-line tab-delimited table (→ `*_OPL` outputs) |

### Two filtering branches

After variant extraction (06) the flow splits:

- **Visualisation branch:** 08 (genotype filter) → 09 (linkage plot on the
  filtered set), used to read off the linked region by eye.
- **Candidate branch:** 10 (genotype filter against the background sample) →
  11 (region filter) → 12/13 (MiModD annotation + HTML report) and 14/15 (SnpEff
  annotation + tabular OPL report).

## Filtering criteria (as applied)

- **Genotype:** `--gt 0/1,1/1` retains variants that are heterozygous or
  homozygous for the alternative allele in the mutant. Stage 10 additionally
  requires `./.` (no genotype) in the `external_source_1` background sample.
- **Region:** `--region chr:start-end …` retains only variants inside the
  manually chosen linked interval(s); see
  [region_filters.md](region_filters.md).

> **Documentation note:** the original `data/README` text mentioned a minimum
> read-depth filter (`--dp 3`). The genotype-filter stages reproduced here
> (08/10) do **not** carry a `--dp` flag; depth filtering does not appear in the
> scripts that produced these outputs. The scripts are kept faithful to what was
> run; this note simply flags the discrepancy. See the repository README.

## Per-sample data flow

One sample flows through as:

```
reads.fastq.gz
  → header.sam            (01)
  → ualn.bam              (02)
  → aln.bam               (03)
  → calls.bcf             (04)            [+ deletions.txt (05)]
  → variants.vcf          (06, with Hawaiian markers)
  → linkage plot          (07)
  → genotype-filtered vcf (08) → linkage plot (09)
  → candidate vcf         (10) → region-filtered vcf (11)
  → annotated vcf + html  (12/13)
  → SnpEff vcf + OPL table (14/15)
```
