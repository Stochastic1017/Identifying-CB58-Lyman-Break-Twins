## Name: Shrivats Sudhir
## Email: ssudhir2@wisc.edu

## Initializing console
print('Initializing Console ...')
rm(list=ls())

## Input command line prompts
print('Inputing command line prompts ...')
args = (commandArgs(trailingOnly = TRUE))
if(length(args) == 2){
  template = args[1]
  dir = args[2]
} else {
  cat('usage: Rscript minkowski_spectra.R <template spectrum> <data directory>\n', file = stderr())
  stop()
}

if (require("FITSio"))
{
  print("Loading package FITSio.")
} else
{
  print("Failed loading package FITSio.")
}

## Standardize flux-values to match it to a gaussian distribution. (making it scale invariant)
standardize <- function(flux)
{
  return (scale(flux, center = mean(flux), scale = sd(flux)))
}

## Defining minkowski distance metric
minkowski  <- function(x, y, p)
{
  return (sum(abs((x-y)^p))^(1/p))
}

## Function to compute distance between two flux
standardize_minkowski <- function(cB58, spectra, p)
{
  n <- length(cB58)
  m <- length(spectra)
  dist  <-  c()

  if (n > m) # cB58 is larger than other spectra
  {
    next
  }
  
  else (m > n)
  {
    cB58 <- standardize(cB58)
    for (i in 1:(m-n+1))
    {
      temp  <- minkowski(cB58, standardize(spectra[i:(i+n-1)])[, 1], p)
      dist  <- append(dist, temp)
    }
  }
  return (c(min(dist), which(dist == min(dist))))
}

print('Reading cB58_Lyman_break.fit ...')
cB58  <- readFrameFromFITS(template) # Target spectrum

result  <-  data.frame(matrix(ncol = 3))
colnames(result) <- c('distance', 'i', 'spectrumID')

## Listing files
files <- list.files(dir, pattern = 'fit*') # save all files as a list

print('Starting main process ...')
for (file in files)
{
  cat("On File:", file, "\n")
  path_to_file = paste(sep = "", sprintf('%s/', dir), file)
  noisy = readFrameFromFITS(path_to_file) # Interested spectrum in this iteration
  result  <- rbind(result, c(standardize_minkowski(cB58$FLUX, noisy$flux, p = 2), file))
}

result <- na.omit(result)
write.csv(result, file = sprintf("%s.csv", dir), row.names = FALSE)
print('Job Complete!')