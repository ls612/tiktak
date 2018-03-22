# Script (bash) to compile globalSearch program (without running it)

echo "Removing old files"
# Remove locked file
rm -f *lock 
# Remove old modules
rm -f *.mod
# Remove Montecarlo results files
rm -f monteCarloGOPAmin.dat
rm -f monteCarloGOPA.dat
rm -f resultsMC.dat

echo "Compiling"
#ifort -O3 -g -heap-arrays nrtype.f90 myParams.f90 stateControl.f90 genericParams.f90 utilities.f90 simplex.f90 objective.f90 minimize.f90 GlobalSearch.f90 -o GlobalSearch
gfortran -O3               nrtype.f90 myParams.f90 stateControl.f90 genericParams.f90 utilities.f90 simplex.f90 objective.f90 minimize.f90 GlobalSearch.f90 -o GlobalSearch
