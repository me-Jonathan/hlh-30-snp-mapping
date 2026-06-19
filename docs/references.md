# References

## The study this work belongs to

- Nonninger T.J., Mak J., Gerisch B., Ramponi V., Kawamura K., Ripa R.,
  Schilling K., Latza C., **Kölschbach J.**, Serrano M. & Antebi A. (2025).
  *A TFEB–TGFβ axis systemically regulates diapause, stem cell resilience and
  protects against a senescence-like state.* **Nature Aging** 5, 1340–1357.
  https://doi.org/10.1038/s43587-025-00911-4 (CC BY 4.0)

## Methods and software used by this pipeline

- **MiModD** (Maier W.). Mutation Identification in Model Organism Genomes; the
  toolkit that runs the alignment, variant calling, linkage/mapping and
  annotation steps here.
  https://celegans.biologie.uni-freiburg.de/ · https://mimodd.readthedocs.io/

- **CloudMap / Variant Discovery Mapping**. Minevich G., Park D.S.,
  Blankenberg D., Poole R.J. & Hobert O. (2012). *CloudMap: A cloud-based
  pipeline for analysis of mutant genome sequences.* **Genetics** 192(4),
  1249–1269. https://doi.org/10.1534/genetics.112.144204
  (the SNP-/variant-mapping-by-sequencing strategy implemented by MiModD)

- **SnpEff**. Cingolani P. et al. (2012). *A program for annotating and
  predicting the effects of single nucleotide polymorphisms, SnpEff.* **Fly**
  6(2), 80–92. https://doi.org/10.4161/fly.19695

- **SnpSift**. Cingolani P. et al. (2012). *Using Drosophila melanogaster as a
  model for genotoxic chemical mutational studies with a new program, SnpSift.*
  **Frontiers in Genetics** 3, 35. https://doi.org/10.3389/fgene.2012.00035

- **SNAP aligner**. Zaharia M. et al. (2011). *Faster and more accurate
  sequence alignment with SNAP.* arXiv:1111.5572 (used via `mimodd snap`)

## Reference data

- **WBcel235** *C. elegans* genome assembly (Ensembl/WormBase); annotation
  database `WBcel235.99`.
- **Hawaiian CB4856 marker SNPs**. The polymorphism panel used to seed the
  linkage analysis. For the underlying one-step WGS + SNP-mapping concept see
  Doitsidou M., Poole R.J., Sarin S., Bigelow H. & Hobert O. (2010).
  *C. elegans mutant identification with a one-step whole-genome-sequencing and
  SNP mapping strategy.* **PLoS ONE** 5(11), e15435.
  https://doi.org/10.1371/journal.pone.0015435
