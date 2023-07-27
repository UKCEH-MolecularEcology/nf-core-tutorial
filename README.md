# nf-core-tutorial
 - We now have [nextflow](https://www.nextflow.io/) on **neohuxley**.
 - Thanks to the efforts of [Milo Brooks](https://www.ceh.ac.uk/staff/milo-brooks).
 - `nextflow` provides easy-access to all of the [nf-core pipelines](https://nf-co.re/pipelines).

*Note*: To install `nextflow` on your own machines, see [here](https://github.com/UKCEH-MolecularEcology/nf-core-tutorial/edit/main/README.md#manual-nextflow-installation).

## For the 16S/18S/ITS afficianados
 - Checkout [ampliseq](https://nf-ccarbon&empso.re/ampliseq/2.6.1)
 - A video on the usage and utility of `ampliseq` can be seen [here](https://youtu.be/a0VOEeAvETs).
&nbsp;
### How to Run [ampliseq](https://nf-ccarbon&empso.re/ampliseq/2.6.1) from [nf-core](https://nf-co.re/)
 - See the [Quick start](https://nf-co.re/ampliseq/2.6.1/docs/usage#quick-start) options. 
 - For additional details or options of running the pipeline, see [here](https://nf-co.re/ampliseq/2.6.1/docs/usage#running-the-pipeline).
&nbsp;
## **Important**: Input data setup
 - `ampliseq` allows for multiple input options.
 - They include:
     1. [Direct FASTQ input](https://nf-co.re/ampliseq/2.6.1/docs/usage#direct-fastq-input)
     2. [ASV/OTU fasta](https://nf-co.re/ampliseq/2.6.1/docs/usage#asvotu-fasta-input)
     3. [Samplesheet](https://nf-co.re/ampliseq/2.6.1/docs/usage#samplesheet-input)
*Note*: The easiest of these would be the [Samplesheet](https://nf-co.re/ampliseq/2.6.1/docs/usage#samplesheet-input), especially 'cos we have a [script]() to generate the `Samplesheet` easily.
&nbsp;
### Generating the Samplesheet
 - Run the [`make_samplesheet.sh`](https://github.com/UKCEH-MolecularEcology/nf-core-tutorial/blob/main/scripts/make_samplesheet.sh) script and provide as a variable the folder where the raw `fastq.gz` files are located.
```bash
./make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/ITS
```
*Note*: Depending on the suffixes in your own raw fastq files


```bash
nextflow run nf-core/ampliseq \
    -r 2.3.2 \
    -profile singularity \
    --input "data" \
    --FW_primer GTGYCAGCMGCCGCGGTAA \
    --RV_primer GGACTACNVGGGTWTCTAAT \
    --metadata "data/Metadata.tsv"
    --outdir "./results"
```

*Note: Sample information can also be provided using a [`samplesheet`](https://nf-co.re/ampliseq/2.6.1/docs/usage#samplesheet-input)*.


For example, the samplesheet may contain:
| sampleID | forwardReads | reverseReads      | run |
| ----------- | ----------- | ----------- | ----------- |
sample1 | ./data/S1_R1_001.fastq.gz | ./data/S1_R2_001.fastq.gz | A 
sample2 | ./data/S2_fw.fastq.gz | ./data/S2_rv.fastq.gz | A
sample3 | ./S4x.fastq.gz | ./S4y.fastq.gz | B
sample4 | ./a.fastq.gz | ./b.fastq.gz | B  

&nbsp;
&nbsp;
# **Test run**
```bash
# working directory
cd /hdd0/susbus/nf_ampliseq # change to wherever *your* data is stored

# activate nextflow conda env
conda activate nextflow

# run ampliseq workflow on test samples
nextflow run nf-core/ampliseq \
    -r 2.6.1 \
    -profile singularity \     
    --input sample.tsv \
    --FW_primer GTGYCAGCMGCCGCGGTAA \
    --RV_primer GGACTACNVGGGTWTCTAAT \
    --metadata "metadata/edited_metadata_sequencing_timgoo.txt" \
    --outdir "./timgoo_16Sresults"
```
&nbsp;
## Errors due to mismatch between samples in table and samples in metadata
 - Removed missing samples from sample.tsv file and created sample_filtered.tsv file
 - List of samples to be removed obtained from Ampliseq Error message
```bash
samples_to_remove=(         
    'Exp8-1-A-G-5-167Mac-16S-1'
    'Exp8-1-A-A-1-Acinoc-16S-1'
    'Exp8-1-A-F-5-167Mac-16S-1'
    'Exp8-1-A-G-4-167Kal-16S-1'
    'Exp8-1-A-C-1-Acinoc-16S-1'
    'Exp8-1-A-B-6-167Mal-16S-1'
    'Exp8-1-A-F-1-Alkinoc-16S-1'
    'Exp8-1-A-B-1-Acinoc-16S-1'
    'Exp8-1-A-A-6-167Mal-16S-1'
    'Exp8-1-A-E-1-Acinoc-16S-1'
    'Exp8-1-A-G-1-Alkinoc-16S-1'
    'Exp8-1-A-D-5-167Mac-16S-1'
    'Exp8-1-A-A-2-Alkinoc-16S-1'
    'Exp8-1-A-B-5-167Kal-16S-1'
    'Exp8-1-A-B-2-Alkinoc-16S-1'
    'Exp8-1-A-H-1-Alkinoc-16S-1'
    'Exp8-1-A-C-6-167Mal-16S-1'
    'Exp8-1-A-H-5-167Mal-16S-1'
    'Exp8-1-A-A-5-167Kal-16S-1'
    'Exp8-1-A-C-5-167Mac-16S-1'
    'Exp8-1-A-H-4-167Kal-16S-1'
    'Exp8-1-A-E-5-167Mac-16S-1'
)

# Path to the original sample.tsv file
input_file="sample.tsv"

# Output file with filtered samples
output_file="sample_filtered.tsv"

# Create a pattern from the list of samples to remove
pattern=$(IFS="|"; echo "${samples_to_remove[*]}")

# Use grep to filter out unwanted samples and save to the output file
grep -Ev "($pattern)" "$input_file" > "$output_file"

# run ampliseq workflow on the matched samples
nextflow run nf-core/ampliseq \
    -r 2.6.1 \
    -profile singularity \     
    --input sample_filtered.tsv \
    --FW_primer GTGYCAGCMGCCGCGGTAA \
    --RV_primer GGACTACNVGGGTWTCTAAT \
    --metadata "metadata/edited_metadata_sequencing_timgoo.txt" \
    --outdir "./timgoo_16Sresults"
```

**For the brave of heart:** *Additional nf-core [`tips and tricks`](https://nf-co.re/docs/usage/introduction#tips-and-tricks)*


# ITS analyses
 - running the ITS pipeline of ampliseq
```bash
# Generating the sample sheet
# Note: edit the `make_samplesheet.sh` file to name the output file as `sample_ITS.tsv`
./make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/ITS
```

 - removing the missing samples as done for 16S
```bash
samples_to_remove=(         
    'Exp8-1-A-G-5-167Mac-16S-1'
    'Exp8-1-A-A-1-Acinoc-16S-1'
    'Exp8-1-A-F-5-167Mac-16S-1'
    'Exp8-1-A-G-4-167Kal-16S-1'
    'Exp8-1-A-C-1-Acinoc-16S-1'
    'Exp8-1-A-B-6-167Mal-16S-1'
    'Exp8-1-A-F-1-Alkinoc-16S-1'
    'Exp8-1-A-B-1-Acinoc-16S-1'
    'Exp8-1-A-A-6-167Mal-16S-1'
    'Exp8-1-A-E-1-Acinoc-16S-1'
    'Exp8-1-A-G-1-Alkinoc-16S-1'
    'Exp8-1-A-D-5-167Mac-16S-1'
    'Exp8-1-A-A-2-Alkinoc-16S-1'
    'Exp8-1-A-B-5-167Kal-16S-1'
    'Exp8-1-A-B-2-Alkinoc-16S-1'
    'Exp8-1-A-H-1-Alkinoc-16S-1'
    'Exp8-1-A-C-6-167Mal-16S-1'
    'Exp8-1-A-H-5-167Mal-16S-1'
    'Exp8-1-A-A-5-167Kal-16S-1'
    'Exp8-1-A-C-5-167Mac-16S-1'
    'Exp8-1-A-H-4-167Kal-16S-1'
    'Exp8-1-A-E-5-167Mac-16S-1'
)

# Path to the original sample.tsv file
input_file="sample_ITS.tsv"

# Output file with filtered samples
output_file="sample_ITS_filtered.tsv"

# Create a pattern from the list of samples to remove
pattern=$(IFS="|"; echo "${samples_to_remove[*]}")

# Use grep to filter out unwanted samples and save to the output file
grep -Ev "($pattern)" "$input_file" > "$output_file"
```

## running the pipeline with the ITS options
```bash
nextflow run nf-core/ampliseq \
    -r 2.6.1 \
    -profile singularity \     
    --input sample_ITS_filtered.tsv \
    --illumina_pe_its \
    --FW_primer GTGARTCATCGAATCTTTG \
    --RV_primer TCCTCCGCTTATTGATATGC \
    --metadata "metadata/edited_metadata_sequencing_timgoo_ITS.txt" \
    --outdir "./timgoo_ITSresults" 
```

nextflow run nf-core/ampliseq -profile test,singularity --outdir test_run
nextflow run nf-core/mag -profile test,singularity --outdir MAG_test_run

dryrun: `-n`

### Data location:
- 16S and ITS fastqs: `/raid2/scratch/timgoo/SeqData/LockedUpExp8__`


### Primers
 - Required for Ampliseq input

| PrimerSet | Name | Sequence | Type |
| ----------- | ----------- | ----------- | ----------- |
16S | 515F | GTGYCAGCMGCCGCGGTAA | Forward |
16S | 806R | GGACTACNVGGGTWTCTAAT | Reverse | 
&nbsp;
ITS | ITS7 | GTGARTCATCGAATCTTTG | Forward | 
ITS | ITS4 | TCCTCCGCTTATTGATATGC | Reverse |

&nbsp;
### Notes:
- Details obtained from Tim Goodall
- *16S primers*: Walters 2015 Improved Bacterial 16S rRNA Gene (V4 and V4-5) and Fungal Internal Transcribed Spacer Marker Gene Primers for Microbial Community.
- *ITS primers*: Ihrmark 2012 New primers to amplify the fungal ITS2 region – evaluation by 454-sequencing of artificial and natural communities.

&nbsp;
## Manual nextflow installation
 - For setting up `nextflow` on your own machines, see below.
&nbsp;  
### Setting up nextflow conda environment
### Install conda
- Conda (can be used together w/ `snakemake`) (recommended)
  - [Conda](https://docs.conda.io/projects/conda/en/latest/index.html)
  - [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
  - [Anaconda](https://anaconda.org/)

Do the following to install `conda` on neohuxley.
```bash
(node)$> wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
(node)$> chmod u+x Miniconda3-latest-Linux-x86_64.sh
(node)$> ./Miniconda3-latest-Linux-x86_64.sh
```

### Install nextflow (or any other workflow manager of choice)
- Pipelines
  - [nextflow](https://www.nextflow.io/)
  - [snakemake](https://snakemake.github.io/) (recommended)
  - [targets](https://books.ropensci.org/targets/) for `R`-pure pipelines
  
```bash
# create the nextflow conda environment
conda create -n nextflow -c bioconda nextflow
```

### Activate nextflow
```bash
conda activate nextflow
```
