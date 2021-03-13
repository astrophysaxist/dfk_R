#Example R code
#This snippet is just meant to introduce some of the basic syntax and functions
#of R
#
#For more info on R functions use help(function)

#Read in a .simp file
#NOTE how <- operator is used to assign output of function to a variable
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
waves = simpdat[3:nrowdat,1]

#For all the ages plot the solar metallicity SSP, normalized to its value at wavelength 4020 Angstrom
#NOTE: IN R can do boolean expression inside indexing to create a boolean mask to select indices where expression is true
#Also, a blank for an index value like we see hear in the 2nd dim of fluxes  denotes ALL values--like a wildcard.
norm_fact = fluxes[,waves==4020]
fluxes_norm = fluxes/norm_fact


#Example user defined function in R
plot_ssps <- function(wave, flux, save){

    #Define k, num of spectra
    k = dim(flux)[1]

    #Plot first spectrum of solor metallicity with graphics settings to initialize the plot
    plot(wave, flux[1,], type="l", xlim=c(3600,8000),ylim=c(0,2),xlab="Wavelength (Angstroms)",ylab="Normalized Flux", main="DFK Protospectra")
    #Add the rest of the spectra to an existing plot using the lines function
    for(i in 2:k){
        lines(wave,flux[i,],col=i)
    }

    if(save){
        #Grabbing system time to add to filename
        timesuff = format(Sys.Date(),"%d%b%y")
        f1 = paste(c("dfk","_norm_4020_",timesuff,".png"),collapse='')
	dev.copy(png, f1)
	dev.off()
    }
}

#Run function to plot fluxes off all SSPS of all ages at solar Z = 0.02
plot_ssps(waves, fluxes_norm[t(metallicities==0.02)&t(ages)<13.5e9,],save='True')

#Stuff to try on you own
#Try plotting only SSPs aged 0 to 13.5e9 yrs old, as 13.5Gyr is the age of universe. Doesn't make much sense to look at older SSPs.
#Try a different normalization, e.g. normalize by the median or average flux of each SSP and see how the relationship to SSPs change.
