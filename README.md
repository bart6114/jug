[![Build Status](https://travis-ci.org/Bart6114/jug.svg)](https://travis-ci.org/Bart6114/jug)
[![codecov](https://codecov.io/gh/Bart6114/jug/branch/master/graph/badge.svg)](https://codecov.io/gh/Bart6114/jug)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/jug)](http://cran.r-project.org/web/packages/jug)
[![Downloads](http://cranlogs.r-pkg.org/badges/jug)](http://cran.rstudio.com/package=jug)

# jug: A Simple Web Framework for R

<img src="https://github.com/Bart6114/jug/blob/master/var/beer_jug.png?raw=true" width="64" alt="jug">

jug is a small web development framework for R which relies heavily upon the ```httpuv``` package. It’s main focus is to make building APIs for your code as easy as possible.

jug is not supposed to be either an especially performant nor an uber stable web framework. Other tools (and languages) might be more suited for that. It focuses on maximizing the ease with wich you can create web APIs for your R code. However, the flexibility of jug means that, in theory, you could built an extensive web framework with it.

Check out [http://bart6114.github.io/jug/articles/jug.html](http://bart6114.github.io/jug/articles/jug.html) for the vignette documentation.

Plugins:

- [`jug.parallel`](https://github.com/Bart6114/jug.parallel)

## Changes

### v0.1.7

- Fixed CORS preflight request bug (issue #15)
- Fixed masking of base::get

### v0.1.6

- Ability to specify `auto-unbox` value for json responses
- Added `strict_params` argument to `decorate`

### v0.1.5

- Added basic authentication functionality through `auth_basic`

### v0.1.4

- Fixed bug where missing content type would not auto-parse the query string


### v0.1.3

- Refactor request header processing
- Added CORS functionality
- Possible to specify `method` for `use` middleware
- Refactoring of request param parsing
- New error handling middleware (JSON response)
- Additional / refined testing
