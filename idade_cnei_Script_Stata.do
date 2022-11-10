gen idade_cne=v0101-v3033 if v3032<=3
replace idade_cne=v0101-v3033-1 if v3032>3 & v3032<=12 & v3033!=v0101

gen idade_cnei=v8005 if idade_cne==.
replace idade_cnei=idade_cne if idade_cne<.
label variable idade_cnei "idade_cne com imputação da v8005"




