#' 
#' function for summarizing names by finding the one the best fits a match in another list
#' select is a list or vector of strings to select from.
#' against is a list or vector of strings to compare against
## librarian::shelf(tibble, foreach, doParallel, stringdist)
bestmatch <- function(select, against, ...) {
  tibble(var = select, mindist= foreach(i=1:length(var)) %dopar% {min(afind(against, var, ...)$distance[,i])} %>% unlist()) %>% filter(mindist == min(.$mindist)) %>% .$var
}

