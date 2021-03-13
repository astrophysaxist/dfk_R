#Example use of diffusion mapping

#Install latest version of diffusionMap by source
install.packages("./diffusionMap_1.2.0/diffusionMap_1.2.0.tar.gz",repos=NULL,type="source")

#Load in packages
library(Matrix)
library(igraph)
library(scatterplot3d)
library(MASS)
library(rgl)

#Source functions from diffusionMap
source("./diffusionMap_1.0-0/diffusionMap/R/diffuse.R")
source("./diffusionMap_1.0-0/diffusionMap/R/plot.dmap.R")

#We'll use diffusionMaps's diffuse function to form diffusion Maps of SSP fluxess
simpdat <- read.table("./library_simp_files/Stelib_Atlas_Chabrier_IMF_all_20171228.simp",header=F)

#Grab info about our simp file from its contents
#NOTE: R is indexed from 1 not 0
nspec = simpdat[1,1]
nrowdat = nrow(simpdat)
metallicities = simpdat[1,2:(nspec+1)]
ages = simpdat[2,2:(nspec+1)]

#Grab unique set of ages and metallicities from full lists
#Z is shorthand for metallicity in astronomy
#t() is the transpose; taking that here as metallicities has shape 1,1547 and unique works on row data
#You can always check dimensions of matrix/table-like data with dim()
Z = unique(t(metallicities))
#T is shorthand for time, or age
T = unique(t(ages))

#Grab spectra (fluxes)
fluxes = t(simpdat[3:nrowdat,2:(nspec+1)])
norm_fact = apply(fluxes, 1, median)
fluxes_norm = fluxes/norm_fact
waves = simpdat[3:nrowdat,1]


#but first we have to provide a pairwise difference matrix of data
#dist() uses a Euclidiean type pairwise distance by default
D = as.matrix(dist(fluxes_norm[t(metallicities==0.02),waves>3601&waves<8501]))

#Now create a diffusion map
#Create diffusion map
dmap = diffuse(D, eps=70)
plot(dmap)
#diffuse returns an R object with several key variables accesible by name
#You can see these using names() or summary()
#Details of the different variables are in the diffusionMap PDF manual
names(dmap)

#Stuff to try on your own
#Try different values for epsilon (e.g 1, 1e2, 1e3) the tuning parameter and see how it changes the 3D plot.
#Grab the diffusion map coordinates for a diffusion map and save to a variable, then calculate the mean pairwise distance between the SSPs in the diffusion space.


