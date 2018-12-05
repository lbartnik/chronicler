options(chronicler.attach = FALSE)

library(chronicler)
chronicler:::attach_to_repository(repository::iris_model())

identify(system.file('artifacts/iris-predictions.png', package = 'repository'))

path <- system.file('artifacts/iris-predictions.png', package = 'repository')
a <- identify_artifact(path)
explain(a)


library(chronicler)
library(utilities)
library(repository)
library(withr)
chronicler:::attach_to_repository(iris_model())
experiment <- find_experiments()[[1]]

library(mlflow)
mlflow_set_experiment("Exported from chronicler")
run <- mlflow_start_run()


    # extract parameters...
    prms <- unlist(lapply(experiment$path, `[[`, i = 'parameters'))
    cnt  <- counter(1)

    # ...log them and make sure they are all named
    imap(prms, function (value, name) {
      if (!is.character(name) || !nchar(name)) name <- paste0('parameter_', cnt())
      cat("Logging parameter: ", name, " = ", value, "\n", sep = '')
      mlflow_log_param(name, value)
    })

    # log the model
    mlflow_save_model(crate(~ stats::predict(model, .x), model = experiment$model))

    # finally, log all the downstream artifacts
    lapply(experiment$outcomes, function (outcome) {
      # if a plot, put in a PNG and report
      if (artifact_is(outcome, 'plot')) {
        path <- tempfile(fileext = ".png")
        with_png(path, plot(artifact_data(outcome)))
      } else {
        # if an R object, serialize to RDS and report
        path <- tempfile(fileext = ".rds")
        saveRDS(artifact_data(outcome), path)
      }
      stopifnot(file.exists(path))
      # report to mlflow
      mlflow_log_artifact(path)
    })
