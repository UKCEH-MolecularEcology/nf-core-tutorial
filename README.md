# nf-core-tutorial
 - We now have [nextflow](https://www.nextflow.io/) and [Singularity](https://osf.io/k89fh/wiki/Singularity/) on **neohuxley**.
 - Thanks to the efforts of [Milo Brooks](https://www.ceh.ac.uk/staff/milo-brooks).
 - `nextflow` provides easy-access to all of the [nf-core pipelines](https://nf-co.re/pipelines).

*Note: To install `nextflow` on your own machines, see [here](https://github.com/UKCEH-MolecularEcology/nf-core-tutorial/edit/main/README.md#manual-nextflow-installation). **For the brave of heart:** Additional nf-core [`tips and tricks`](https://nf-co.re/docs/usage/introduction#tips-and-tricks)*.

&nbsp;
## For the 16S/18S/ITS afficianados
 - Checkout [ampliseq](https://nf-ccarbon&empso.re/ampliseq/2.6.1)
 - A video on the usage and utility of `ampliseq` can be seen [here](https://youtu.be/a0VOEeAvETs).
&nbsp;
### How to Run [ampliseq](https://nf-ccarbon&empso.re/ampliseq/2.6.1) from [nf-core](https://nf-co.re/)
 - See the [Quick start](https://nf-co.re/ampliseq/2.6.1/docs/usage#quick-start) options. 
 - For additional details or options of running the pipeline, see [here](https://nf-co.re/ampliseq/2.6.1/docs/usage#running-the-pipeline).

&nbsp;
## :sparkles: Input data setup
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
# Clone the git repository
git clone git@github.com:UKCEH-MolecularEcology/nf-core-tutorial.git

# Setup executable permissions for the script
chmod +x ./scripts/make_samplesheet.sh

# Run the script by providing the folder path
./scripts/make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/ITS
```
 - The above script generates a table as shown below.
   
*Note*: The `run` column is optional and only needs to be provided if samples span multiple sequencing runs.

| sampleID | forwardReads | reverseReads      | run |
| ----------- | ----------- | ----------- | ----------- |
sample1 | ./data/S1_R1_001.fastq.gz | ./data/S1_R2_001.fastq.gz | A 
sample2 | ./data/S2_fw.fastq.gz | ./data/S2_rv.fastq.gz | A
sample3 | ./S4x.fastq.gz | ./S4y.fastq.gz | B
sample4 | ./a.fastq.gz | ./b.fastq.gz | B  

*Note*: Depending on the suffixes in your own raw fastq files, `line 23` of the [`make_samplesheet.sh`](https://github.com/UKCEH-MolecularEcology/nf-core-tutorial/blob/main/scripts/make_samplesheet.sh) script may need to be edited.  
*Note*: For example: replace `Exp8` in the `awk function` below with the first part of your sample name. This is usually a project ID or a sequencing run number. 
```bash
awk -v "OFS=\t" '{$1=$1; sub(/^.*Exp8/, "Exp8", $1); split($1, arr, "_"); $1=arr[1]}1'
```
&nbsp;
### Running **16S analyses**  on [ampliseq](https://nf-ccarbon&empso.re/ampliseq/2.6.1)
 - `Ampliseq` can be used for **16S analyses**run using [Singularity](https://osf.io/k89fh/wiki/Singularity/) as shown below.
```bash
nextflow run nf-core/ampliseq \
    -r 2.3.2 \
    -profile singularity \
    --input sample.tsv \
    --FW_primer GTGYCAGCMGCCGCGGTAA \
    --RV_primer GGACTACNVGGGTWTCTAAT \
    --metadata "data/Metadata.tsv"
    --outdir "ampliseq_output"
```
*Note: [Metadata](https://nf-co.re/ampliseq/2.6.1/docs/usage#metadata) information is **optional** and can be provided using the format described.
&nbsp;
### **Test run**
 - `nf-core` allows for running a quick test run to check if everything is in order.
 - To do this, run the following code:
```bash
nextflow run nf-core/ampliseq -profile test,singularity --outdir test_run
```   
 - To see how a *full test run* was performed with 16S data, see [test_run](https://github.com/UKCEH-MolecularEcology/nf-core-tutorial/blob/main/notes/test_run.md#errors-due-to-mismatch-between-samples-in-table-and-samples-in-metadata).
&nbsp;

### Dealing with common errors 
 - The best resource if you run into errors is the [**ampliseq issues page**](https://github.com/nf-core/ampliseq/issues).
 - If you run an error due to a `mismatch between samples in *sample.tsv* and samples in the metadata file`, see below:

&nbsp;
*Example*
- Removed missing samples from sample.tsv file and created _sample_filtered.tsv_ file
 - List of samples to be removed obtained from Ampliseq Error message
```bash
samples_to_remove=(         
    'Exp8-1-A-G-5-167Mac-16S-1'
    'Exp8-1-A-A-1-Acinoc-16S-1'
    'Exp8-1-A-F-5-167Mac-16S-1'
    'Exp8-1-A-G-4-167Kal-16S-1'
    'Exp8-1-A-C-1-Acinoc-16S-1'
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
    --metadata "data/Metadata.tsv"
    --outdir "ampliseq_output"
```

&nbsp;
### Running the pipeline with the ITS options
 - Running the ITS pipeline of ampliseq requires the use of the `--illumina_pe_its` flag.
 - For other ITS workflow options search for `ITS` in the [parameters](https://nf-co.re/ampliseq/2.6.1/parameters) page.
```bash
# Generating the sample sheet
# Note: edit the `make_samplesheet.sh` file to name the output file as `sample_ITS.tsv`
./scripts/make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/ITS

nextflow run nf-core/ampliseq \
    -r 2.6.1 \
    -profile singularity \     
    --input sample_ITS.tsv \
    --illumina_pe_its \
    --FW_primer GTGARTCATCGAATCTTTG \
    --RV_primer TCCTCCGCTTATTGATATGC \
    --metadata "metadata/ITS_Metadata.tsv" \
    --outdir "./ampliseq_ITS_output" 
```

&nbsp;
### Ampliseq Output
 - The tool generates several output files; see [here](https://nf-co.re/ampliseq/2.6.1/docs/output) for a description of all the files.
 - For example, the `qiime2` folder contains all the outputs from [Qiime2](https://qiime2.org/), including diversity plots, ancom, ordinations etc.
```
ampliseq_output
├── barrnap
├── cutadapt
├── dada2
├── fastqc
├── input
├── multiqc
├── overall_summary.tsv
├── pipeline_info
└── qiime2
```


&nbsp;
### Manual nextflow installation
 - For setting up `nextflow` on your own machines, see below.
&nbsp;  
#### Setting up nextflow conda environment
- Conda (can be used together w/ `nextflow`) (recommended)
  - [Conda](https://docs.conda.io/projects/conda/en/latest/index.html)
  - [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
  - [Anaconda](https://anaconda.org/)

Do the following to install `conda` on neohuxley.
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod u+x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh

# create the nextflow conda environment
conda create -n nextflow -c bioconda nextflow

# Activate nextflow
conda activate nextflow
```
