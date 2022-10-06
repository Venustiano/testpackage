
# rvispack

<!-- badges: start -->
<!-- badges: end -->

This package is still development and includes several data
visualization techniques. Currently, the most complete function is to
create `violin` plots. However, other techniques are being implemented
such as `histograms` and `projections` as a result of applying
Principal component analysis.

## Containers

The easiest way to run the implemented data visualization techniques
is by installing [Docker](https://docs.docker.com/engine/install/)

### Testing the container

``` shell
docker run --rm venustiano/cds:rvispack-0.1.0
```

### Parameters

The functions implemented in this package receive two
parameters. First, the data visualization function to be exceuted,
namely, `histogram`, `pca` and `violin`. Second, a json file structure
including the required information to create the visualization.

```json
{
	"filename": "iris.csv",
	"variables: [],
	"y_variable": "sepal_length"
}
```


## Installation in R

You can install the development version of pcaprojection from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Venustiano/testpackage")
```

## Example

This is a basic example which shows you how to create projection:

``` r
library(pcaprojection)
## basic example code
```

