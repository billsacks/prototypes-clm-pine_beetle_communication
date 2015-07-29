# prototypes-clm-pine-beetle-communication

This prototype shows how we could do the communication needed for pine beetle
dispersal. Other key parts of the pine beetle implementation (such as setting
the dispersal array on each proc, and then using the final summed dispersal
array to update the beetle count for each grid cell) are glossed over here,
because the focus is on the mpi communication pattern.

To compile and run: On my laptop:

compile with: mpif90 pine_beetles.f90
mpirun -np 4 a.out
