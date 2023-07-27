# nf-core test run
## Data location:
- 16S and ITS fastqs: `/raid2/scratch/timgoo/SeqData/LockedUpExp8__`
## Primers
 - Required for Ampliseq input

| PrimerSet | Name | Sequence | Type |
| ----------- | ----------- | ----------- | ----------- |
16S | 515F | GTGYCAGCMGCCGCGGTAA | Forward |
16S | 806R | GGACTACNVGGGTWTCTAAT | Reverse | 
&nbsp;
ITS | ITS7 | GTGARTCATCGAATCTTTG | Forward | 
ITS | ITS4 | TCCTCCGCTTATTGATATGC | Reverse |

### Notes:
- Details obtained from Tim Goodall
- *16S primers*: Walters 2015 Improved Bacterial 16S rRNA Gene (V4 and V4-5) and Fungal Internal Transcribed Spacer Marker Gene Primers for Microbial Community.
- *ITS primers*: Ihrmark 2012 New primers to amplify the fungal ITS2 region – evaluation by 454-sequencing of artificial and natural communities.

## **16S Test run** 
 - Running the 16S analyses on `ampliseq`
```bash
# Generating the sample sheet
./make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/16S

# working directory
cd /hdd0/susbus/nf_ampliseq # change to wherever *your* data is stored

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


## **ITS Test run**
 - running the ITS pipeline of ampliseq
```bash
# Generating the sample sheet
# Note: edit the `make_samplesheet.sh` file to name the output file as `sample_ITS.tsv`
./make_samplesheet.sh /raid2/scratch/timgoo/SeqData/LockedUpExp8__/ITS
```

 - removing the missing samples as done for 16S
```bash
samples_to_remove=(
'Exp8-1-E-C-1-Acinoc-ITS-1'
'Exp8-1-E-B-5-167Kal-ITS-1'
'Exp8-1-E-H-5-167Mal-ITS-1'
'Exp8-1-E-E-1-Acinoc-ITS-1'
'Exp8-1-E-F-1-Alkinoc-ITS-1'
'Exp8-1-E-G-4-167Kal-ITS-1'
'Exp8-1-E-E-5-167Mac-ITS-1'
'Exp8-1-E-D-1-Acinoc-ITS-1'
'Exp8-1-E-D-6-167Mal-ITS-1'
'Exp8-1-E-F-5-167Mac-ITS-1'
'Exp8-1-E-B-1-Acinoc-ITS-1'
'Exp8-1-E-C-5-167Mac-ITS-1'
'Exp8-1-E-B-6-167Mal-ITS-1'
'Exp8-1-E-H-1-Alkinoc-ITS-1'
'Exp8-1-E-A-5-167Kal-ITS-1'
'Exp8-1-E-A-6-167Mal-ITS-1'
'Exp8-1-E-C-6-167Mal-ITS-1'
'Exp8-1-E-G-1-Alkinoc-ITS-1'
'Exp8-1-E-A-2-Alkinoc-ITS-1'
'Exp8-1-E-G-5-167Mac-ITS-1'
'Exp8-1-E-A-1-Acinoc-ITS-1'
'Exp8-1-E-H-4-167Kal-ITS-1'
'Exp8-1-E-B-2-Alkinoc-ITS-1'
'Exp8-1-E-D-5-167Mac-ITS-1'
'Exp8-1-E-F-4-167Kal-ITS-1'
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
