# Estiamte tumor purity from matched tumor-normal BAMs input
# https://github.com/VanLoo-lab/ascat/blob/e42dc4fcbb3d279546c976d263c981b0d83b4ff3/ExampleData/README.md#processing-targeted-sequencing-data

library(ASCAT)

tumor_bam <- "TODO"
tumor_name <- "TODO"
normal_bam <- "TODO"
normal_name <- "TODO"

gender <- "TODO"
worksheet <- "TODO" # "myWorksheet.tsv", # A tab-separated file with specific information. Check format using ?ascat.prepareTargetedSeq
bed_file <- "TODO"  # 

allelecounter_exe <- "/usr/local/bin/alleleCounter"
genome <- "hg38"

ascat.prepareTargetedSeq(
  Worksheet = worksheet,
  alleles.prefix = "test",
  BED_file = bed_file,
  allelecounter_exe = allelecounter_exe,
  genomeVersion = genome,
  nthreads = 8)

ascat.prepareHTS(
  tumourseqfile = tumor_bam,
  normalseqfile = normal_bam,
  tumourname = tumor_name,
  normalname = normal_name,
  allelecounter_exe = allelecounter_exe,
  alleles.prefix = "./alleleData/Cleaned/alleleData_chr",
  loci.prefix = "./alleleData/Cleaned/loci_chr",
  gender = gender,
  genomeVersion = genome,
  nthreads = 8,
  tumourLogR_file = "Tumor_LogR.txt",
  tumourBAF_file = "Tumor_BAF.txt",
  normalLogR_file = "Germline_LogR.txt",
  normalBAF_file = "Germline_BAF.txt")
  
ascat.bc = ascat.loadData(Tumor_LogR_file = "Tumor_LogR.txt", Tumor_BAF_file = "Tumor_BAF.txt", Germline_LogR_file = "Germline_LogR.txt", Germline_BAF_file = "Germline_BAF.txt", gender = 'XX', genomeVersion = "hg19", isTargetedSeq=T)
ascat.plotRawData(ascat.bc, img.prefix = "Before_correction_")
ascat.bc = ascat.correctLogR(ascat.bc, GCcontentfile = "GC_file.txt", replictimingfile = "RT_file.txt")
ascat.plotRawData(ascat.bc, img.prefix = "After_correction_")
ascat.bc = ascat.aspcf(ascat.bc, penalty=25)
ascat.plotSegmentedData(ascat.bc)
ascat.output = ascat.runAscat(ascat.bc, gamma=1, write_segments = T)
QC = ascat.metrics(ascat.bc,ascat.output)
save(ascat.bc, ascat.output, QC, file = 'ASCAT_objects.Rdata')