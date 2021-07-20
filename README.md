# Census Explorer

Australian Census data explorer. Using historic data from from
https://www.census.abs.gov.au/ inspired by the upcoming Tue 10th Aug 2021
census.

## TL;DR

```
make
make build
```

## Goal

Allow Census data to be easily loaded from any historical Census and displayed
in an interactive map and chart dashboard.

## Iterations

1. [ ] view an identifiable statistic
   > an identifiable statistic for **Census 2016**
   > Male Information Technology professional born in 1975 living around
   > latitude: -37.783153116511784 longitude: 144.996479117923
   >
   > from https://datapacks.censusdata.abs.gov.au/datapacks/
   >
   > `2016 Census Datapacks`
   >
   > -> `General Community Profile`
   >
   > -> `All Geographies`
   >
   > -> `Vic`
   >
   > stat M_InfoTech_35_44 from [DATA OVERVIEW](DATA_OVERVIEW.md)

| Geography           | Region ID     | Statistic        | Value  |
| :------------------ | :------------ | :--------------- | -----: |
| AUS_CODE_2016       | 36            | M_InfoTech_35_44 |  82634 |
| STE                 |               |                  |        |
| SA4                 |               |                  |        |
| SA3                 |               |                  |        |
| SA2                 |               |                  |        |
| SA1_7DIGITCODE_2016 | 21245:2111120 | M_InfoTech_35_44 |      3 |


1. ...

## Development

Iterative development steps are being documented here: [Development](DEVELOPMENT.md).

