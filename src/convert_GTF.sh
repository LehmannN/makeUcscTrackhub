#!/usr/bin/env bash

ft_sort () {
    sort -k1,1 -k2,2n $1 > ../tmp/tmp.sorted.genePred
}

ft_gtfToGenePred () {
    gtfToGenePred \
        -genePredExt $1 \
        ../tmp/tmp.genePred
}

ft_gff3ToGenePred () {
    gff3ToGenePred $1 \
        ../tmp/tmp.genePred
}

ft_genePredToBigGenePred () {
    genePredToBigGenePred $1 \
        ../tmp/tmp.bigGenePred
}

ft_bedToBigBed () {
    bedToBigBed \
        -type=bed12+8 \
        -tab \
        -as=../tmp/bigGenePred.as \
        $1 ../tmp/chrom.sizes $2
}

ft_gtfToBigGenePred () {
    out="$2/$(basename "$1").bb"

    # check extension (GTF or GFF)
    echo Converting GTF to genePred...
    ft_gtfToGenePred $1
    echo Converting genePred to bigGenePred...
    ft_genePredToBigGenePred ../tmp/tmp.genePred
    echo Converting bigGenePred \(text\) to bigGenePred \(binary\) ...
    {
        ft_bedToBigBed ../tmp/tmp.bigGenePred $out
    } || {
    echo Sorting file...
    ft_sort ../tmp/tmp.bigGenePred
    echo Converting bigGenePred \(text\) to bigGenePred \(binary\) ...
    ft_bedToBigBed ../tmp/tmp.sorted.genePred $out
    rm ../tmp/tmp.sorted.genePred
}
echo Removing tmp.genePred tmp.bigGenePred tmp.bigGenePred
rm ../tmp/tmp.genePred ../tmp/tmp.bigGenePred
echo Conversion from GTF to BigGenePred \( binary \) done !
echo
}
