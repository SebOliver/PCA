;+
; :Author: pdh21
;-
pro PC_contributions, wave,flux, PC_contrib
;THIS PROGRAM TAKES AN INPUT SPECTRUM AND CALCULATES THE CONTRIBUTIONS 
;THE FIVE PRINCIPAL COMPONENTS DESCRIBED IN HURLEY ET AL. (2012)
;
;IF YOU USE THE PCS, PLEASE CITE THE PAPER HURLEY ET AL. (2012)

;INPUT
;wave (IN MICRONS)
;FLUX (IN JANSKYS)
;OUTPUT
;1x5 ARRAY CONTAINING CONTRIBUTIONS FROM EACH PC

;NOTE: REQUIRES 'PCs.dat' FILEPATH TO BE CORRECT
readcol, 'PCs.dat',lambda,meanspec,PC1,PC2,PC3,PC4,PC5
PCs=[[PC1],[PC2],[PC3],[PC4],[PC5]]

PC_contrib=fltarr(5)
;Interpolate onto PCA wavelength grid
new_flux=interpol(flux,wave,lambda)
;Normalise flux by mean
new_flux=new_flux/avg(new_flux)
norm_flux=new_flux-meanspec
;Get contribution from each PC
for i=0,4 DO BEGIN
PC_contrib[i]=total(norm_flux*PCs[*,i])
ENDFOR

return
END

;-------------------------------------------


pro CLASSIFY_spec, PC_contrib, prob
;Classify objects into HII,LINER, Sy2 and Sy1 as described in Hurley et al. 2012.
;INPUT:
;PC_contrib, as calculated in the PC_contributions program
;OUPUT;
;pdf values for HII,LINER,Sy2 and Sy1, the highest value corresponds
;to the most likely classification.

;Code requires the 'GMMdata.sav' file to run. Check filepath is correct


restore,'GMMdata.sav'
pos=PC_contrib
prob=fltarr(4)
for i=0,3 DO BEGIN
prob[i]=ajs_gaussnd(pos,amp=amp,mean=mean_sample[*,i],cov=cov[*,*,i])
ENDFOR
return
END

