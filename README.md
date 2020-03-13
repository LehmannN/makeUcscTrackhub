# Utility to make a UCSC trackhub easily
This is a small utility to build a UCSC trackhub to visualise your data in the genome browser.

## Install
The only way to use this tool (at least for the moment) is to clone the repository and run the source code:
```{bash}
git clone git@github.com:LehmannN/makeUcscTrackhub.git
cd makeUcscTrackhub/src/
```

## Run
Here are some examples of how to run this code. Your data to be include in the trackhub (BAM, GTF...) needs to be in a folder called "../data/".

```{bash}
./main.sh -i ../data/ -p 20 -n galGal6
```
