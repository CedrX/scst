#!/bin/bash

TEMPLATE=/etc/scst-template.conf
FILE_TO_WRITE=/etc/scst.conf
LSSCSI=/usr/bin/lsscsi
#set -x

make_device() {
	type_of_device=$1
	scst_statement=$2

	eval "devices=$($LSSCSI | awk 'BEGIN { indice=0 } \
			       /'$type_of_device'/  { sub(/\[/,"",$1); sub(/\]/,"",$1); tab[indice++]=$1 } \
			       END  { printf("("); \
				      for(i=0;i<indice;i++) { \
                  			if(i==0) printf("%s",tab[i]); \
                  			else printf(" %s",tab[i]); \
               			      } \
              			      printf(")\n") \
            			   }
		 ')"
	for ((i=0;i<${#devices[*]};i++)) ; do 
		str_to_add=$(echo  "DEVICE ${devices[$i]}")
		if [ $i -eq 0 ] ; then 
			sed -i '/HANDLER dev_'$scst_statement' {/ a  '"$str_to_add" $FILE_TO_WRITE
		else 
			sed -i '/DEVICE '${devices[i-1]}'/ a  '"   DEVICE ${devices[$i]}" $FILE_TO_WRITE
		fi
	done
}

make_lun() {
	type_of_device=$1
	eval "luns=$($LSSCSI | awk 'BEGIN { indice=0 } \
                               /'$type_of_device'/  { sub(/\[/,"",$1); sub(/\]/,"",$1); tab[indice++]=$1 } \
                               END  { printf("("); \
                                      for(i=0;i<indice;i++) { \
                                        if(i==0) printf("%s",tab[i]); \
                                        else printf(" %s",tab[i]); \
                                      } \
                                      printf(")\n") \
                                   }
               ')"
	
	for ((i=0;i<${#luns[*]};i++)) ; do
                str_to_add="LUN $i ${luns[$i]}"
		if [ $i -eq 0 ] ; then
			sed -i '/:storage-'$type_of_device' {/ a\\t\t\t '"$str_to_add" $FILE_TO_WRITE
		else
			 sed -i '/LUN '$((i-1))' '${luns[i-1]}'/ a\\t\t\t  '"$str_to_add" $FILE_TO_WRITE
		fi
	done
}


cp $TEMPLATE $FILE_TO_WRITE
make_device "mediumx" "changer"
make_device "tape" "tape"
make_lun "mediumx"
make_lun "tape"
			
