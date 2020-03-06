#!/usr/bin/env bash

usage() { echo "Usage: $0 [-i data] [-d output_dir]" 1>&2; exit 1; }

# Set default value
d='.'

# Get arguments from command line
while getopts ":i:d:" opt; do
    case "${opt}" in
        i)
            i=${OPTARG}
            ;;
        d)
            d=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Check arguments
if [ -z "${i}" ] || [ -z "${d}" ]; then
    usage
fi

for f in ${i}*
do
    ext=${f##*\.}
    out="$(basename "$f" .gtf).bb"
    if [ $ext = 'gtf' ]
    then
        echo Processing file $f with extension $ext
        gtfToGenePred -genePredExt $f tmp.genePred
        genePredToBigGenePred tmp.genePred tmp.bigGenePredEx.txt
        bedToBigBed -type=bed12+8 -tab -as=bigGenePred.as tmp.bigGenePredEx.txt ../data/galGal6.fa.chrom.sizes $out
    fi
    #fb=$(basename "$f")
    #echo $f
    #echo track $fb
    #echo bigDataUrl https://regin.ens.fr/lehmann/Public/200301_symasym_ont/galGal6/$f
    #echo shortLabel $fb
    #echo longLabel $fb
    #echo type bam
    #echo itemRgb on
done

# wget https://genome.ucsc.edu/goldenPath/help/examples/bigGenePred.as
#if $f ext == .bam => bw
#if $f ext == fasta or fa
