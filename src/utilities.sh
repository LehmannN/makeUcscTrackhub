#!/usr/bin/env bash

# From https://genome.ucsc.edu/goldenPath/help/bigGenePred.html
ft_get_helper_file () {
	echo Downloading missing file bigGenePred.as
	wget https://genome.ucsc.edu/goldenPath/help/examples/bigGenePred.as
	mv bigGenePred.as ../tmp/
}

ft_get_chrom_sizes () {
	echo Dowmloading missing file $1.chrom.sizes
	wget http://hgdownload.soe.ucsc.edu/goldenPath/$1/bigZips/$1.chrom.sizes
	mv $1.chrom.sizes ../tmp/chrom.sizes
}

ft_get_extension () {
	F=$(basename "$1")
	ext=${F##*\.}
	ext=$(echo $ext | awk '{print toupper($0)}')
	echo $ext
}

ft_check_extension_convert () {
	ext=$( ft_get_extension "$1" )
	out=-1
	case "$ext" in
		'GTF' )
			out=0 ;;
		'GFF' )
			out=1 ;;
		'BAM' )
			out=2 ;;
		* )
			printf "ERROR: this file format is not allowed. \n"
			printf "Please make sure you use GTF, GFF, or BAM file. \n"
			printf "Note it is note case sensitive (.gtf, .Gtf, .GTF are identical). Error number : \n" ;;
	esac
	echo $out
}

ft_check_extension_trackhub () {
	ext=$( ft_get_extension "$1" )
	out=-1
	case "$ext" in
		'bigWig' )
			out=0 ;;
		'bigBed' )
			out=1 ;;
		'bigGenePred' )
			out=2 ;;
		'bigChain' )
			out=3 ;;
		'bigNarrowPeak' )
			out=4 ;;
		'bigBarChart' )
			out=5 ;;
		'bigInteract' )
			out=6 ;;
		'bigPsl' )
			out=7 ;;
		'bigMaf' )
			out=8 ;;
		'hic' )
			out=9 ;;
		'BAM' )
			out=10 ;;
		'CRAM' )
			out=11 ;;
		'HAL' )
			out=12 ;;
		'VCF' )
			out=13 ;;
		* )
			printf "ERROR: this file format is not allowed. \n"
			printf "File format accepted by UCSC trackhub: bigWig, bigBed, bigGenePred, bigChain, bigNarrowPeak, bigBarChart, bigInteract, bigPsl, bigMaf, hic, BAM, CRAM, HAL or VCF. \n"
			printf "More info here https://genome.ucsc.edu/goldenPath/help/hgTrackHubHelp.html \n"
	esac
	echo $out

}

ft_convert_extension () {
	ext=$( ft_get_extension "$1" )
	case "$ext" in
		'BW' )
			out='bigWig' ;;
		'BB' )
			out='bigBed' ;;
	esac
	echo $out
}
