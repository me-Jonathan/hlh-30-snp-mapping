# Results

Final, GitHub-sized outputs of the mapping pipeline. The bulky raw and
intermediate files (BAM/BCF and full VCFs) are **not** included here; see the
repository README for where they belong.

## `tables/`: annotated candidate variants

These are the final filtered candidate lists (pipeline stages 11–15): the
bona-fide candidates for the causative mutation in each strain, restricted to
the linked region(s) (see [`../docs/region_filters.md`](../docs/region_filters.md)).

Two flavours per strain:

- `*_filter_annotated.xlsx`: **multiple effects per line.** Often several
  predicted effects share one variant; keeping them on one line gives a compact
  overview and shows whether a variant is het or hom.
- `*_filter_annotated_OPL.xlsx`: **one effect per line** (OPL). Each effect gets
  its own row, with shared fields (e.g. `POS`) repeated, plus extra columns.
  Easier to filter, more verbose.

> Tip: the candidate lists can be long even after filtering. Filtering on
> `EFF[*].EFFECT` (sequence-ontology terms) to the effect classes of interest is
> the quickest way to narrow them down.

### Column reference (VCF-derived fields)

| Field | Meaning |
|---|---|
| `CHROM` | reference chromosome / contig |
| `POS` | 1-based reference position |
| `REF` / `ALT` | reference / alternative base(s) |
| `QUAL` | Phred-scaled quality of the `ALT` assertion |
| `DP` | combined read depth across samples |
| `AC` | allele count per `ALT` allele |
| `MQ` | RMS mapping quality across samples |

See the [VCF v4.2 spec](https://samtools.github.io/hts-specs/VCFv4.2.pdf) for full
definitions, and the SnpEff `EFF[*]` effect-field documentation for the
annotation columns.

## `figures/`: linkage analysis plots

One PDF per strain (and a `*_prefilter_*` variant). The histograms visualise the
binned linkage report; the scatterplots show, for each marker, its rate of
segregation from the causative mutation; a dip near the causative locus marks
the linked region. Markers are binned, with bin size encoded by point colour
saturation, and a regression line shows the overall trend.

Background: <https://mimodd.readthedocs.io/en/latest/tutorial_example3.html>
