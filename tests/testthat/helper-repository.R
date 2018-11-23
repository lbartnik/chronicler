sample_artifact_id <- function () {
  "57fbe7553e11c7b0149040f5781c209b266ed637"
}

sample_repository <- function() london_meters()

sample_artifact <- function () {
  as_artifacts(sample_repository()) %>% filter(id == sample_artifact_id()) %>% read_artifacts %>% first
}
