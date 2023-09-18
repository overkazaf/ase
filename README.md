# Description

Toolkit based on awk that emulates simple SQL gramma execution


# USAGE
```shell
awk -f sql.awk "tiny sql statement" CSV_FILENAME [| PIPELINE COMMAND] 
```

## show csv headers
```shell
awk -f sql.awk "HEADER" data.csv
```

## show selected fields
```shell
awk -f sql.awk "SELECT name,age" data.csv
```
