# HLH-30 SNP-based mapping (*C. elegans*)

Hawaiian (CB4856) SNP mapping-by-sequencing pipeline used to find the causative
mutations from a forward-genetic screen in the *hlh-30/TFEB* background. This is
the SNP-mapping contribution (J.K.) to:

> Nonninger T.J., Mak J., Gerisch B., Ramponi V., Kawamura K., Ripa R.,
> Schilling K., Latza C., Kölschbach J., Serrano M. & Antebi A.
> *A TFEB–TGFβ axis systemically regulates diapause, stem cell resilience and
> protects against a senescence-like state.* Nature Aging 5, 1340–1357 (2025).
> https://doi.org/10.1038/s43587-025-00911-4 (CC BY 4.0)

The work covers the whole-genome-sequencing / SNP-mapping analysis of mutant
strains A1, 39, 40, 43, 71 and 109, which were crossed to `hlh-30(tm1978)` in the
Hawaiian CB4856 background and mapped by sequencing.

## What it does

Pooled DNA from recombinant mutants is sequenced, aligned to the *C. elegans*
reference, and screened against Hawaiian CB4856 marker SNPs. Linkage analysis
localises the causative mutation to a chromosomal region, and variants in that
region are filtered and annotated to a candidate shortlist. Built on
[MiModD](https://mimodd.readthedocs.io/) and
[SnpEff](https://pcingola.github.io/SnpEff/). Stage-by-stage walkthrough:
[`docs/pipeline.md`](docs/pipeline.md).

## Strains

| Paper strain | Sample ID | Candidate table |
|:---:|:---:|---|
| A1  | S25  | `results/tables/S25_filter_annotated*.xlsx`  |
| 39  | S26  | `results/tables/S26_filter_annotated*.xlsx`  |
| 109 | S134 | `results/tables/S134_filter_annotated*.xlsx` |
| 71  | S135 | `results/tables/S135_filter_annotated*.xlsx` |
| 40  | S136 | `results/tables/S136_filter_annotated*.xlsx` |
| 43  | S137 | `results/tables/S137_filter_annotated*.xlsx` |

## Running

Requirements: MiModD (in a virtualenv), SnpEff + SnpSift with the `WBcel235.99`
database, a SLURM scheduler, and Singularity/Apptainer. The scripts `sbatch` one
job per sample per stage. Reference resources (a MiModD-sanitised `WBcel235`
genome and a CB4856 marker panel in WBcel235 coordinates) are not bundled.

1. Edit [`config/config.sh`](config/config.sh): `PROJECT_ROOT`, reference and
   annotation resources, container path, SLURM partition.
2. Put the per-sample `*_1.fastq.gz` / `*_2.fastq.gz` reads under `data_raw`.
3. Run the stages in order (wait for each batch to finish), `01_header.sh`
   through `10_varfilter_candidates.sh`.
4. Read off each strain's linked region from the stage 07/09 plots, set it in
   [`scripts/11_region_filter.sh`](scripts/11_region_filter.sh) (current values in
   [`docs/region_filters.md`](docs/region_filters.md)), then run stages 11–15.

## Notes

This repo holds the code and the small final outputs (candidate tables and
linkage figures). The scripts were tidied (paths moved into `config.sh`, naming
cleaned) without changing any tool, flag, filter, or region, and were not re-run
end-to-end during cleanup. The original `data/README` mentioned a `--dp 3`
minimum-depth filter that the genotype-filter stages here (08/10) do not carry;
this is flagged in [`docs/pipeline.md`](docs/pipeline.md). No region-filter record
survives for strain A1 (S25), so its stage-11 line is left commented out.

Tool citations are in [`docs/references.md`](docs/references.md); please cite the
relevant tools if you reuse the pipeline.

## Citation and license

Cite the paper above (and optionally this repo via [`CITATION.cff`](CITATION.cff)).
Code is released under the [MIT License](LICENSE), © 2025 Jonathan Kölschbach /
Max Planck Institute for Biology of Ageing. The associated paper is © The
Author(s) 2025, CC BY 4.0.
