[![Build Status](https://travis-ci.org/Bart6114/jug.svg)](https://travis-ci.org/Bart6114/jug)
[![Coverage Status](https://coveralls.io/repos/Bart6114/jug/badge.svg?branch=master&service=github)](https://coveralls.io/github/Bart6114/jug?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/jug)](http://cran.r-project.org/web/packages/jug)
[![Downloads](http://cranlogs.r-pkg.org/badges/jug)](http://cran.rstudio.com/package=jug)

# jug: A Simple Web Framework for R

<img src="var/beer_jug.png" width="64">


Jug is a small web development framework for R which relies heavily upon the ```httpuv``` package. It’s main focus is to make building APIs for your code as easy as possible.

Jug is not supposed to be either an especially performant nor an uber stable web framework. Other tools (and languages) might be more suited for that. It focuses on maximizing the ease with wich you can create web APIs for your R code. However, the flexibility of Jug means that, in theory, you could built an extensive web framework with it.

See [http://bart6114.github.io/jug](http://bart6114.github.io/jug) for the development vignette version.


## Changes

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
