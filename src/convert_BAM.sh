#!/usr/bin/env bash

ft_bamToBigWig () {
	out="$2/$(basename "$1").bw"
	echo Converting BAM to BigWig...
	bamCoverage -b $1 -o $out --numberOfProcessors=$3
	echo
}
