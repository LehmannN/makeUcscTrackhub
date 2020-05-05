# Utility to make a UCSC trackhub easily
This is a small utility to build a UCSC trackhub to visualise your data in the genome browser.

## Install
The only way to use this tool (at least for the moment) is to clone the repository and run the source code:
```{bash}
git clone git@github.com:LehmannN/makeUcscTrackhub.git
cd makeUcscTrackhub/src/
```

## Run
Here are some examples of how to run this code. Your data to be include in the trackhub (BAM, GTF...) needs to be separated into 2 folders, one with files to convert (eg BAM to BigWig or GTF to BigBed) and the other one with files to keep without converting (BAM).

```{bash}
./main.sh -i ../data/convert -j ../data/noconvert -p 20 -n galGal6
```
