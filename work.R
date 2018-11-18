options(chronicler.attach = FALSE)

library(chronicler)
chronicler:::attach_to_repository(repository::iris_model())

identify(system.file('artifacts/iris-predictions.png', package = 'repository'))

path <- system.file('artifacts/iris-predictions.png', package = 'repository')
a <- identify_artifact(path)
explain(a)

