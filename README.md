## TIKTAK algorithm

This website maintains the version of the TIKTAK algorithm described in our working paper, Arnoud, Guvenen, Kleineberg (2017).

### Description of the Algorithm
The algorithm is written in Fortran. It is a global optimization algorithm. Given a function of `n` parameters, the algorithm runs the domain space and tries to find a global minimum. The power of the algorithm is that it can be easily parallelized without knowledge of any parallel language such as openMP or MPI.


### Team
The algorithm intially developped by Fatih Guvenen is tested by Antoine Arnoud, Tatjana Kleineberg and Fatih Guvenen against other commonly used algorithms.
Research assistance was provided by Leo Stanek.
