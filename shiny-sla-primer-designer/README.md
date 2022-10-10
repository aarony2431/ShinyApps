## How the SLA primer designer works

The output is based on methods initially outlined in [Kramer 2011](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3152947/) which were implemented in Python to create sets of primers and probes. This was originally written by Sam Beppler and takes the **full sequence guidestrand (GS)** as the imput.

### RT primer
The RT primer creates the "stem-loop" portion of the assay and is designed by adding the first 6-8 nucleotides of the _reverse complement_ of the GS to the _3'_ end of the **universal stem-loop sequence** _5' GTCGTATCCAGTGCAGGGTCCGAGGTATTCGCACTGGATACGAC 3'_.

### Forward primers and MGB (minor-groove binder) probes
The Forward primers are designed by taking the first 12-17 nucleotides of the GS and adding an additional semi-randomized _FLAP_ sequence to the _5'_ end to adjust the final primer _T<sub>m<sub>_ to 60 ± 1°C. This _FLAP_ is constructed from a pre-determined sequence of _5' TCATAA 3'_ and bases are slowly substituted from right to left with either a _G_ or _C_ nucleotide (this is determined randomly).  Since it is required the the MGB probe not overlap with the Forward primers, the MGB probes would be designed by taking the first 4-9 nucleotides (for a 21-mer GS) of the _reverse complement_ of the GS and adding the first 12 or more nucleotides of the _reverse complement_ of the **universal stem-loop sequence** such that final probe _T<sub>m<sub>_ with the MGB conjugation is at least 70°C. MGB probes are to be ordered with a MGB conjugation, 5' FAM, and 3' quencher.

### _In silico_ optimization
The Forward primers are designed using the pseudo-random algorithm **100 times** and the primer sets with the lowest free energy change (ΔG) for homo- and hetero-dimers are selected as the best sequences. These sequences are then used to design the probes. This whole process is then repeated another **50 times** to select RT primer, Forward primer, and MGB probe sets which fulfill the following conditions in order of importance:
  1. Contain 3 RT primers, 3 Forward primers, and 2 MGB probes
  2. Contain the longest MGB probes.
