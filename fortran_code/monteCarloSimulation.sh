#!/bin/bash
# This script compiles the program, runs it and generates output
# output is stored in monteCarloGOPAmin.dat and monteCarloGOPA.dat files for individual optimization

###########################################################################################################
echo "running Monte Carlo..."

#need to allow modifying txt file, otherwise cannot rewrite
chmod u+x config.txt

#cleanup some stuff
echo "cleanup..."
rm -rf ../results

#BEGIN USER MODIFIABLE DATA
dim=7 #Number of dimensions of the objective
SobolList=(40 70 100 200 400 800 1600) #List of quantities of sobol points to try
length=${#SobolList[@]} 
length=$((length-1)) # length of SobolList (minus 1 because indexation starts at 0)
imp=10   # number of trials per quantity of sobol points
#END USER MODIFIABLE DATA

# create folder results
mkdir ../results

# create one folder by algo (bobyqa and amoeba) and number of Sobol points
for j in $(seq 0 $length); do
 n=${SobolList[$j]}
 mkdir ../results/bobyqa_sobol$n
 mkdir ../results/amoeba_sobol$n
done

# create one folder by starting point
for j in $(seq 0 $length); do
 n=${SobolList[$j]}
 for i in $(seq 1 $imp); do
  mkdir ../results/bobyqa_sobol$n/startpoint_$i
  mkdir ../results/amoeba_sobol$n/startpoint_$i
 done
done


# copy everything in each folder and change config file appropriately
for i in $(seq 1 $imp); do
	
	# overwrite starting point on config file 
	#(using XX random starting points but always the same point for each step in performance profile)
	for k in $(seq 1 $dim); do
	  lineout=$((37+$dim+$k))
	  linein=$((($i-1)*$dim+$k))
	  sed -i "${lineout}s/.*/`sed -n "${linein}p" init_points.dat`/g" config.txt
	done

	# varying number of Sobol points
	for j in $(seq 0 $length); do
 		n=${SobolList[$j]}   # number of sobols generated
	 	m=$((n/10))	# number of sobols kept	

	 #################################### bobyqa ###########################################
	 # copy files in new folder
	 cd ..
	 cp -r fortran_code results/bobyqa_sobol$n/startpoint_$i 			#	 cp -r ./* ../results/bobyqa_$j
	 cp -r data results/bobyqa_sobol$n/startpoint_$i
	 cp -r SWEout results/bobyqa_sobol$n/startpoint_$i

	 # go to new folder
	 cd results/bobyqa_sobol$n/startpoint_$i/fortran_code

     # overwrite number of Sobol points generated / kept on config file
	 echo "bobyqa dim7 sobol is $n, kept is $m and iter is" $i
	 sed -i "28s/.*/7, 297, -1, ${n[@]}, ${m[@]}, 0, -1/g" config.txt
	 	 
	 # go back to original folder
	 cd ../../../../fortran_code



	 #################################### amoeba ###########################################
	 # copy files in new folder
	 cd ..
	 cp -r fortran_code results/amoeba_sobol$n/startpoint_$i
	 cp -r data results/amoeba_sobol$n/startpoint_$i
	 cp -r SWEout results/amoeba_sobol$n/startpoint_$i

	 # go to new folder
	 cd results/amoeba_sobol$n/startpoint_$i/fortran_code

      # overwrite number of Sobol points generated / kept on config file
	 echo "amoeba dim7 sobol is $n, kept is $m and iter is" $i
	 sed -i "28s/.*/7, 297, -1, ${n[@]}, ${m[@]}, 0, -1/g" config.txt
		 
	 #go back to original folder
	 cd ../../../../fortran_code


     done
done

cd ../results

# run optimimization in each folder
for i in $(seq 0 $length); do 
	for j in $(seq 1 $imp); do
 		n=${SobolList[$i]}
	
	 # go to new folder
	 cd bobyqa_sobol$n/startpoint_$j/fortran_code

	 # run minimization with dfls. comment this out if only running amoeba
	 ./GlobalSearch 0 config.txt b & 
	 
	 # go back to folder results
	 cd ../../../
	 
	 # go to new folder
	 cd amoeba_sobol$n/startpoint_$j/fortran_code

	 # run minimization with amoeba. comment this out if only running dfls
	 ./GlobalSearch 0 config.txt a & 
	 
	 # go back to folder results
	 cd ../../../

	 #wait
	 
     done
done

wait

echo "done."
