#MERGING OF MULTIPLE VCF FILES FROM ONS VARIANT CALLING
#RUN IN TERMINAL
#Configure Channels
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --show channels

# Create Conda Environment & Installation Tools to Environment
conda create -n vcf_merge parallel tabix bcftools

#Activate environment
conda activate vcf_merge

#Choose right file location (file w/ depacked single vcf.files to merge)
cd /pathway/to/files/snv/OXTR

#Compress to vcf.gz file
parallel bgzip ::: *.vcf

#Create genome position index file for each Sample vcf.gz
parallel tabix -p vcf ::: *.vcf.gz

#Merging of files using bcftools merge function
#https://samtools.github.io/bcftools/bcftools.html
bcftools merge --force-samples -o merged_OXTR.vcf.gz -O z *.vcf.gz

#@--force-samples: otherwise 
#Error: Duplicate sample names (SAMPLE), use --force-samples to proceed #anyway.

#Annotation table (group, sex etc.) has to be Tab-delimited txt.file

#Proceed w/ IGV 
#software.broadinstitute.org/software/igv/home


#IGV -> File -> Load from File -> merged_OXTR.vcf.gz
#Switch reference genome: Human (GrCh38/hg38) 
#Specify chromosome region: 
#chr3:8750381-8770434
#IGV -> File -> Load from File -> annotation txt.file
#IGV -> View -> Select attributes to show -> select manually
#IGV -> Right click -> Display mode -> squished or expanded -> may be set manually: Change #squished row height
#IGV -> Right click -> Group by: select e.g. “group”
#Visually scan for group dependent differences in SNVs