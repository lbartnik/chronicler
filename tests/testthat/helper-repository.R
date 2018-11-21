sample_artifact_id <- function () {
  "4756f19b61b5df2b5f7c8e85321d464142274ff9"
}

sample_repository <- function() london_meters()

sample_artifact <- function () {
  as_artifacts(sample_repository()) %>% filter(id == sample_artifact_id()) %>% read_artifacts %>% first
}
