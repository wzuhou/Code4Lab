# Code4Lab
## Author: Zhou Wu Time: 2021/09/29

### Nanodrop2sample_table.R

Codes for parsing reports and lab info, such as nanodrop report, and match it with your sample metadata.

Usage: 
```
[input1]    Nanodrop report file (can be excel \*.xlsx), preferable with a NOTE info column.
       
[input2]    Sample table for information(at least include Columns such as ID to use as the key). Metadata.
       
[output]    Seperate tables summarized in the way you required, such as group by Species, Stage, and Sex showen in this example.
```



### Make_BGI_sample_Table.R

Codes for parsing nanodrop report to make sample table and your meta file info.

Usage: 
```
[input]    Nanodrop report file (can be excel \*.xlsx), preferable with a NOTE info column.
       
[input2]    Sample table for information(at least include Columns such as ID to use as the key). Metadata.
       
[output1]    Tissue_myfile_meta.xlsx (may need some manually modification if volume has been adjusted during preparation)

[output2]    Tissue_Fianl_BGI.csv BGI sample table info
```

