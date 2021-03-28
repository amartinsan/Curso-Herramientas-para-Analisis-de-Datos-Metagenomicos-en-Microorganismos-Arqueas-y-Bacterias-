#!/bin/bash
#$ -cwd

	RUTA='/scratch/landa/emmanuel_2016' #la ruta de los fastq
        for cosa in $(cat lista_sitios.txt); do
		/scratch/landa/scripts/FLASH-1.2.11-Linux-x86_64/./flash -m 7 -r 300 -f 550 -s 55 -t 16 \
        -o $cosa $RUTA/$cosa\_R1.fastq* $RUTA/$cosa\_R2.fastq*
        done  #se tiene que poner la ruta del scrito de flash y la terminación del archivo fastq.
