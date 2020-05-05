#!/usr/bin/env bash

# $1: file name
# $2: output path
# $3: number of cores
ft_bamToBigWig () {
	echo Converting BAM to BigWig...
	if [[ $(basename "$1") == stranded* ]]; then
		out="$2/$(basename "$1").forward.bw"
		bamCoverage -b $1 -o $out -p $3 --filterRNAstrand=forward
		out="$2/$(basename "$1").reverse.bw"
		bamCoverage -b $1 -o $out -p $3 --filterRNAstrand=reverse
	else
		out="$2/$(basename "$1").bw"
		bamCoverage -b $1 -o $out -p $3
	fi
	echo
}
