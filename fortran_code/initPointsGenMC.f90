PROGRAM initPointsGenMC
	! This program uses config.txt to generates 1000 random points
	! in the domain space defined in config.txt
	! The points are draw uniformely on the p_nx dimensional domain space.
	! The points are used for Monte Carlo simulation.

	IMPLICIT NONE

  CHARACTER(LEN=100) 	:: line
	REAL								:: mynumber
	INTEGER							:: p_nx, nmom, maxeval, qr_ndraw, maxpoints, searchType, lotteryPoints
	REAL, ALLOCATABLE		:: p_bound(:,:)
	LOGICAL							:: parsedLine
	INTEGER							:: i, jj


	! Read dimension and bounds from config file (config.txt)
  open(UNIT=222, FILE="config.txt", STATUS='old', ACTION='read')
	! Parse the dimension
  parsedLine = .FALSE.
	DO WHILE (parsedLine .eqv. .FALSE.)
    read(222,'(A100)') line

    IF (line(1:1)=='!') THEN  ! cycle as long as line starts with !
        cycle
    END IF
    parsedLine = .TRUE.
    read(line,*) p_nx, nmom, maxeval, qr_ndraw, maxpoints, searchType, lotteryPoints
	END DO

	! allocate matrix of lower and upper bounds of the domain
	allocate(p_bound(p_nx,2))

	!Parse the bounds (use the bounds for Sobol points, not for evaluation of function)
 	parsedLine = .FALSE.
  DO WHILE (parsedLine .eqv. .FALSE.)
    read(222,'(A100)') line

    IF (line(1:1)=='!') THEN   ! cycle as long as line starts with !
        cycle
    END IF
    parsedLine = .TRUE.
    read(line,*) p_bound(1,1), p_bound(1,2)
    DO i=2,p_nx
        read(222,*) p_bound(i,1), p_bound(i,2)
    END DO
  END DO
  close(222)

	! Generate 1000 initial points scaled to the bounds
	do jj = 1,1000
	  do i = 1,p_nx
			! generate a random number between 0 and 1
	    CALL RANDOM_NUMBER(mynumber)
			! scale the number to the bounds
			mynumber = mynumber * (p_bound(i,2) - p_bound(i,1)) + p_bound(i,1)
			! write the scaled number in dat file
    	open(unit = 111, file = "init_points.dat", position = "append", STATUS='unknown')
    		write(111,*) mynumber
    	close(111)
		enddo
  enddo
END PROGRAM
