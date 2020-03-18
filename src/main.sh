#!/usr/bin/env bash
source convert_GTF.sh
source convert_BAM.sh
source utilities.sh

# **************************************************************************** #
# Define and check command line arguments
# **************************************************************************** #
usage() { echo "Usage: $0
	[-i input directory (no default, enter the folder name where you have your input files)]
	[-o output directory (default: ../trackhub)]
	[-c convert files to be readable in the UCSC genome browser: yes or no (default: yes)]
	[-u URL where the data will be stored (default: https://regin.ens.fr/lehmann/Public/tmp)]
	[-n name of the organism like described in UCSC (eg. hg38, mm9, galGal6) - (default: galGal6)]
	[-m name of the experiment - (default: galGal6_2020)]
	[-p number of cores to use (default: max/2)]"
	1>&2; exit 1; }
	o='../trackhub'
	c='yes'
	u='https://regin.ens.fr/lehmann/Public/tmp'
	n='galGal6'
	m='galGal_2020'
	p='max/2'
	while getopts ":i:o:c:u:n:m:p:" opt; do
		case "${opt}" in
			i)
				i=${OPTARG} ;;
			o)
				o=${OPTARG} ;;
			c)
				c=${OPTARG} ;;
			u)
				u=${OPTARG} ;;
			n)
				n=${OPTARG} ;;
			m)
				m=${OPTARG} ;;
			p)
				p=${OPTARG} ;;
			*)
				usage ;;
		esac
	done
	shift $((OPTIND-1))
	if [ -z "$i" ] || [ -z "$o" ] || [ -z "$c" ] ||
		[ -z "$u" ] || [ -z "$n" ] || [ -z "$m" ] || [ -z "$p" ]; then
	usage
fi

# **************************************************************************** #
# Create or check existing folders
# **************************************************************************** #
if [ -d "$o" ]; then
	echo WARNING: you already have an output directory with the name $o.
	echo Please delete it or keep it somewhere else to pursue the analysis.
	set -e
else
	mkdir -p $o
fi

mkdir -p $o/$n

# **************************************************************************** #
# Convert data if necessary
# **************************************************************************** #
if [ $c = 'yes' ]; then
	mkdir -p ../tmp
	if [ ! -f ../tmp/bigGenePred.as ]; then
		ft_get_helper_file
	fi
	if [ ! -f ../tmp/$n.chrom.sizes ]; then
		ft_get_chrom_sizes $n
	fi
	for FILE in ../data/*; do
		ext=${FILE##*\.}
		ext=$(echo $ext | awk '{print toupper($0)}')
		case "$ext" in
			'GTF' )
				echo Processing $ext file named $FILE
				ft_gtfToBigGenePred $FILE $o/$n ;;
			'BAM' )
				echo Processing $ext file named $FILE
				ft_bamToBigWig $FILE $o/$n $p;;
		esac
	done
fi

# **************************************************************************** #
# Create trackDb.txt
# **************************************************************************** #
if [ -f $o/$n/trackDb.txt ]; then
	echo WARNING: you already have a trackDB.txt file in the $o/$n directory.
	echo Please delete it or keep it on an other folder to pursue the analysis.
	rm $o/$n/trackDb.txt
	set -e
else
	touch $o/$n/trackDb.txt
fi

FILES=$o/$n/*
for FILE in $FILES; do
	F=$(basename "$FILE")
	if [ $FILE != 'trackDb.txt' ]; then
		Fpath=$(readlink -f "$FILE")
		ext=${FILE##*\.}
		echo Writing track for file $F in trackDb.txt
		echo track $F >> $o/$n/trackDb.txt
		if [ $ext == 'bw' ] || [ $ext == 'bb' ] ; then
			ext=$(ft_convert_extension "$ext" )
		fi
		echo type $ext >> $o/$n/trackDb.txt
		echo bigDataUrl $u/$F >> $o/$n/trackDb.txt
		echo shortLabel $F >> $o/$n/trackDb.txt
		echo longLabel $F >> $o/$n/trackDb.txt
		echo itemRgb on >> $o/$n/trackDb.txt
		echo >> $o/$n/trackDb.txt
		#if [ $c = 'no' ]; then
		#   ln -s $Fpath $o/$n
		#fi
	fi
done

# **************************************************************************** #
# Create hub.txt
# **************************************************************************** #
if [ -f $o/hub.txt ]; then
	echo WARNING: you already have a hub.txt file in the $o directory.
	echo This file will be over-written.
	set -e
else
	touch $o/hub.txt
fi

echo hub $m > $o/hub.txt
echo shortLabel $m >> $o/hub.txt
echo longLabel $m >> $o/hub.txt
echo genomesFile genomes.txt >> $o/hub.txt
echo email myemail@gmail.com >> $o/hub.txt

# **************************************************************************** #
# Create genomes.txt
# **************************************************************************** #
if [ -f $o/genomes.txt ]; then
	echo WARNING: you already have a genomes.txt file in the $o directory.
	echo This file will be over-written.
	set -e
else
	touch $o/genomes.txt
fi

echo genome $n > $o/genomes.txt
echo trackDb $n/$o >> $o/genomes.txt
