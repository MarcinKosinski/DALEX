#' Exract info from model
#'
#' This generic function let user extract base information about model. The function returns a named list of class \code{model_info} that
#' contain about package of model, version and task type. For wrappers like \code{mlr} or \code{caret} both, package and wrapper inforamtion
#' are stored
#'
#' @param model - model object
#' @param ... - another arguments
#'
#' Currently supported packages are:
#' \itemize{
#' \item class `cv.glmnet` and `glmnet` - models created with `glmnet` package
#' \item class `glm` - generalized linear models
#' \item class `model_fit` - models created with `parsnip` package
#' \item class `lm` - linear models created with `stats::lm`
#' \item class `ranger` - models created with `ranger` package
#' \item class `randomForest` - random forest models created with `randomForest` package
#' \item class `svm` - support vector machines models created with the `e1071` package
#' \item class `train` - models created with `caret` package
#' \item class `gbm` - models created with `gbm` package
#' }
#'
#' @return A named list of class \code{model_info}
#'
#' @rdname model_info
#' @export
#'
#' @examples
#' aps_lm_model4 <- lm(m2.price ~., data = apartments)
#' model_info(aps_lm_model4)
#'
#' model_regr_rf <- randomForest::randomForest(m2.price~., data = apartments, ntree = 50)
#' model_info(model_regr_rf)
#'
model_info <- function(model, ...)
  UseMethod("model_info")


#' @rdname model_info
#' @export
model_info.lm <- function(model, ...) {
  type <- "regression"
  package <- "stats"
  ver <- as.character(utils::packageVersion("stats"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.randomForest <- function(model, ...) {
  type <- model$type
  package <- "randomForest"
  ver <- as.character(utils::packageVersion("randomForest"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.svm <- function(model, ...) {
  if (model$type == 0) {
    type <- "classification"
  } else {
    type <- "regression"
  }
  package <- "e1071"
  ver <- as.character(utils::packageVersion("e1071"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.glm <- function(model, ...) {
  type <- "regression"
  package <- "stats"
  ver <- as.character(utils::packageVersion("stats"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}


#' @rdname model_info
#' @export
model_info.glmnet <- function(model, ...) {
  type <- "regression"
  package <- "glmnet"
  ver <- as.character(utils::packageVersion("glmnet"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.cv.glmnet <- function(model, ...) {
  type <- "regression"
  package <- "glmnet"
  ver <- as.character(utils::packageVersion("glmnet"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.ranger <- function(model, ...) {
  if (model$treetype == "Regression") {
    type <- "regression"
  } else {
    type <- "classification"
  }
  package <- "ranger"
  ver <- as.character(utils::packageVersion("ranger"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.gbm <- function(model, ...) {
  if (model$distribution == "bernoulli") {
    type <- "classification"
  } else {
    type <- "regression"
  }
  package <- "gbm"
  ver <- as.character(utils::packageVersion("gbm"))
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}


#' @rdname model_info
#' @export
model_info.model_fit <- function(model, ...) {
  type <- model$spec$mode
  package_wrapper <- "parsnip"
  ver_wrapper <- as.character(utils::packageVersion("parsnip"))
  package <- model$spec$method$libs
  ver <- as.character(utils::packageVersion(package))
  model_info <- list(package = c(wrapper = package_wrapper, package = package), ver = c(wrapper = ver_wrapper, package = ver), type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.train <- function(model, ...) {
  type <- model$modelType
  package_wrapper <- "caret"
  ver_wrapper <- as.character(utils::packageVersion("caret"))
  package <- model$modelInfo$library
  if (is.null(package)) {
    package <- "stats"
  }
  ver <- as.character(utils::packageVersion(package))
  model_info <- c(package = list(wrapper = package_wrapper, package = package), ver = c(wrapper = ver_wrapper, package = ver), type = type)
  class(model_info) <- "model_info"
  model_info
}

#' @rdname model_info
#' @export
model_info.default <- function(model, ...) {
  type <- "regression"
  package <- paste("Model of class:", class(model), "package unrecognized")
  ver <- "Unknown"
  model_info <- list(package = package, ver = ver, type = type)
  class(model_info) <- "model_info"
  model_info
}

#' Print model_info
#'
#' Function prints object of class \code{model_info} created with \code{\link{model_info}}
#'
#' @param x - an object of class \code{model_info}
#' @param ... - other parameters
#' @rdname print.model_info
#' @export
print.model_info <- function(x, ...) {
 if (length(x$package) == 2) {
   cat(paste("Wrapper package:", x$package["wrapper"], "\n"))
   cat(paste("Wrapper package version:", x$ver["wrapper"], "\n"))
   cat(paste("Package:", x$package["package"], "\n"))
   cat(paste("Package version:", x$ver["package"], "\n"))
 } else {
   cat(paste("Package:", x$package, "\n"))
   cat(paste("Package version:", x$ver, "\n"))
 }
  cat(paste("Task type:", x$type))
}

