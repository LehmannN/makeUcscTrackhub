#!/usr/bin/env bash

# **************************************************************************** #
#                                                                              #
#                                                                              #
#    convert_BAM.sh                                                            #
#                                                                 IBENS        #
#    By: lehmann                                                 CSB team      #
#                                                                              #
#    Created: 2020/03/09 15:43:14 by lehmann                                   #
#    Updated: 2020/03/09 15:43:14 by lehmann                                   #
#                                                                              #
# **************************************************************************** #

ft_bamToBigWig () {
    out="$2/$(basename "$1").bw"
    echo Converting BAM to BigWig...
    bamCoverage -b $1 -o $out --numberOfProcessors=$3
    echo
}
