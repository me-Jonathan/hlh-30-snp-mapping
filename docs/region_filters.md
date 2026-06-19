# Per-strain linkage regions

The candidate VCFs were restricted to the chromosomal region(s) that showed the
strongest linkage to the mutant phenotype in each strain's mapping plot
(pipeline stage 11, `mimodd vcf-filter --region`). These regions were
determined **manually** by inspecting the linkage analysis (stages 07/09). The
hallmark is a dip in the segregation rate of Hawaiian markers near the causative
locus.

The values below are reproduced verbatim from the per-sample READMEs that
accompanied the original analysis and are the values used to generate the
published candidate tables in `results/tables/`.

| Paper strain | Sample | Linkage region(s) used in `--region` |
|:------------:|:------:|--------------------------------------|
| 39  | S26  | `chrI:1500000-3000000` `chrIII:5000000-10000000` |
| 40  | S136 | `chrI:1000000-3000000` `chrIV:2500000-5000000` `chrIV:12000000-15500000` |
| 43  | S137 | `chrI:1000000-3500000` `chrIII:0-1000000` |
| 71  | S135 | `chrI:1000000-7000000` |
| 109 | S134 | `chrI:1000000-4000000` |
| A1  | S25  | *not documented* |

Regions can be widened, narrowed, or added without re-running the upstream
pipeline; only stages 11–15 need to be repeated.
