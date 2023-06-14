process CELLRANGER_DEMULTIPLEX {
    time '96h'
    cpus 16
    memory '12 GB'
    label 'cellranger'

  input:
    path(reference)
    path(meta_yaml)
    path(gex_fastq, stageAs: "?/GEX/*")
    val(gex_id)
    path(cite_fastq, stageAs: "?/CITE/*")
    val(cite_id)
    val(jobmode)
    val(numcores)
  output:
    path("demultiplex_output/samples/*"), emit: per_sample_data
    path("demultiplex_output/"), emit: demultiplexed_output
  script:
    def cite_fastq_opt = cite_id != 'NODATA' ? " --cite_fastq ${cite_fastq}" : ''
    def cite_id_opt = cite_id != 'NODATA' ? " --cite_id ${cite_id}" : ''
    """
        demultiplexing_utils.py cellranger-multi \
        --reference $reference \
        --meta_yaml $meta_yaml \
        --gex_fastq $gex_fastq \
        --gex_id $gex_id \
        --outdir demultiplex_output \
        --tempdir temp \
        --numcores $numcores \
        --mempercore 10 \
        --jobmode $jobmode \
        --maxjobs 2000 \
        $cite_fastq_opt $cite_id_opt \

    """
  stub:
    """
    mkdir -p demultiplex_output/samples/SA123
    mkdir -p demultiplex_output/samples/SA456
    """
}