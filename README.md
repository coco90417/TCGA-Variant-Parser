# TCGA-Variant-Parser
## Download

```
git clone https://github.com/coco90417/TCGA-Variant-Parser
```

## Usage
- -h, --help                      print help message   
- -m, --manual                    print manual message
-  -s, --subtype                   subtype of the cancer, valid options include "ACC", "BLCA", "BRCA", "CESC", "CHOL", "ESCA", "GBM", "HNSC", "KICH", "KIRC", "KIRP", "LAML", "LGG", "LIHC", "LUSC", "OV", "PAAD", "PCPG", "PRAD", "SARC", "SKCM", "STAD", "TGCT", "TGCA", "THYM", "UCEC", "UCS", "UVM". This option is case insensitive
-  -c, --crawldb                   location of crawl*.db
- --db                            path to the tcga-data.nci.nih.gov/ directory produced after downloading variants from TCGA
- -ann, --annovar                 output ANNOVAR file name

## Example
Download ACC somatic mutation variants
```
tcga_variant_parser.pl download -s ACC -c crawl_20140728.db
```
Parse ACC somatic mutation variants and generate an ANNOVAR input file acc.ann (last two columns are sample name and cancer subtype)
```
tcga_variant_parser.pl parse -s ACC -c crawl_20140728.db --db . -ann acc.ann 
```
