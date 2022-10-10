## How the SLA primer designer works

The output is based on methods initially outlined in [Kramer 2011](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3152947/) which were implemented in Python to create sets of primers and probes. This was originally written by Sam Beppler and takes the **full sequence guidestrand (GS)** as the imput.

### RT primer

The RT primer creates the "stem-loop" portion of the assay and is designed by adding the first 6, 7, and 8 nucleotides of the _reverse complement_ of the GS to the _3'_ end of the universal stem-loop sequence _5' GTCGTATCCAGTGCAGGGTCCGAGGTATTCGCACTGGATACGAC 3'_.

### Forward primers and probes

