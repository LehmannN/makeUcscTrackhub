#!/usr/bin/env bash
source convert_GTF.sh

# **************************************************************************** #
# Define and check command line arguments
# **************************************************************************** #

usage() { echo "Usage: $0
    [-i input directory (no default, enter the folder name where you have your input files)]
    [-o output directory (default: ../trackhub)]
    [-c convert files to be readable in the UCSC genome browser: yes or no (default: yes)]
    [-u URL where the data will be stored (default: https://regin.ens.fr/lehmann/Public/tmp)]
    [-n name of the organism like described in UCSC (eg. hg38, mm9, galGal6) - (default: galGal6)]"
    1>&2; exit 1; }
o='../trackhub'
c='yes'
u='https://regin.ens.fr/lehmann/Public/tmp'
n='galGal6'
while getopts ":i:o:c:u:n:" opt; do
    case "${opt}" in
        i)
            i=${OPTARG}
            ;;
        o)
            o=${OPTARG}
            ;;
        c)
            c=${OPTARG}
            ;;
        u)
            u=${OPTARG}
            ;;
        n)
            n=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
if [ -z "$i" ] || [ -z "$o" ] || [ -z "$c" ] ||
    [ -z "$u" ] || [ -z "$n" ]; then
    usage
fi

# **************************************************************************** #
# Create or check existing folders
# **************************************************************************** #
if [ -d "$o" ]; then
    echo ERROR: you already have an output directory with the name $o.
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
    for FILE in ../data/*; do
        ext=${FILE##*\.}
        ext=$(echo $ext | awk '{print toupper($0)}')

        if [ $ext = 'GTF' ]; then
            echo Processing $ext file named $FILE
            ft_gtfToBigGenePred $FILE $o/$n
        fi
    done
fi

# **************************************************************************** #
# Create trackDb.txt
# **************************************************************************** #

if [ -f $o/trackDb.txt ]; then
    echo ERROR: you already have a trackDB.txt file in the ../output/ directory.
    echo Please delete it or keep it on an other folder to pursue the analysis.
    set -e
else
    touch $o/$n/trackDb.txt
fi

for FILE in $o/*; do
    if [ $FILE != 'trackDb.txt' ]; then
        F=$(basename "$FILE")
        echo Writing track for file $F in trackDb.txt
        echo track $F >> $o/$n/trackDb.txt
        echo bigDataUrl $u/$F >> $o/$n/trackDb.txt
        echo shortLabel $F >> $o/$n/trackDb.txt
        echo longLabel $F >> $o/$n/trackDb.txt
        echo type bam >> $o/$n/trackDb.txt
        echo itemRgb on >> $o/$n/trackDb.txt
    fi
done
