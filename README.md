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

## where condition
```shell
awk -f sql.awk "WHERE age=20" data.csv
```

## group by
```shell
awk -f sql.awk "GROUP BY age" data.csv
```

## order by
```shell
awk -f sql.awk "ORDER BY age" data.csv
```
