#!/usr/bin/env bash

ft_sort () {
    out="../data/$(basename "$1" .gtf).sorted.gtf"
    sort -k1,1 -k2,2n $1 > out.tmp
}

ft_gtfToGenePred () {
    gtfToGenePred \
        -genePredExt $1 \
        ../data/tmp.genePred
}

ft_genePredToBigGenePred () {
    genePredToBigGenePred \
        ../data/tmp.genePred \
        ../data/tmp.bigGenePred.txt
}

ft_bedToBigBed () {
    bedToBigBed \
        -type=bed12+8 \
        -tab \
        -as=bigGenePred.as \
        $1 \
        ../data/chrom.sizes $2
}

ft_gtfToBigGenePred () {
    ext=${1##*\.}
    out="../data/$(basename "$1" .gtf).bb"

    if [ $ext = 'gtf' ]
    then
        echo Processing file $1 with extension $ext
        echo Converting GTF to genePred...
        {
            ft_gtfToGenePred $1
        }
        echo Converting genePred to bigGenePred...
        {
            ft_genePredToBigGenePred ../data/tmp.genePred
        }
        echo Converting bigGenePred \(text\) to bigGenePred \(binary\) ...
        {
            ft_bedToBigBed ../data/tmp.bigGenePred.txt $out
        } || {
            echo Sorting file...
            echo $out
            ft_sort ../data/tmp.bigGenePred.txt
            #ft_bedToBigBed out.tmp ../data/Ensembl_stringtie_guided.bb
            ft_bedToBigBed out.tmp $out
            rm out.tmp
        }
    fi
     }

echo Read file convert.sh
