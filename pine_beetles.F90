module pine_beetles_mod
  use mpi

  implicit none
  public
  save

  ! Information about parallelization. Analogous information is available in CLM,
  ! although it isn't quite this straightforward.
  integer, parameter :: gridcells_per_proc = 3
  integer :: nprocs
  integer :: myproc
  integer :: total_gridcells

contains

  subroutine init_gridcells
    integer :: error
    integer :: g

    call mpi_comm_size(MPI_COMM_WORLD, nprocs, error)
    call mpi_comm_rank(MPI_COMM_WORLD, myproc, error)
    total_gridcells = gridcells_per_proc * nprocs

  end subroutine init_gridcells

  ! ========================================================================
  ! The following subroutine is the focus of the prototype
  ! ========================================================================

  subroutine disperse_beetles
    ! This processor's beetle dispersal, on the global domain
    integer, allocatable :: dispersal_global_domain_mype(:)

    ! Sum of all processors' beetle dispersals, on the global domain
    integer, allocatable :: dispersal_global_domain_sum(:)

    integer :: g
    integer :: error

    ! ------------------------------------------------------------------------
    ! Allocate arrays to hold data on the global domain
    ! ------------------------------------------------------------------------

    allocate(dispersal_global_domain_mype(total_gridcells))
    allocate(dispersal_global_domain_sum(total_gridcells))

    ! ------------------------------------------------------------------------
    ! Compute each processor's dispersal; in reality this will be more complex: this
    ! algorithm is not the focus of this prototype
    ! ------------------------------------------------------------------------

    do g = 1, total_gridcells
       dispersal_global_domain_mype(g) = 100*myproc + g
    end do

    ! Format assumes 3 grid cells per proc, 4 procs
    write(*,'("My dispersal: Proc ", i0, ": ", 12i4)') myproc, dispersal_global_domain_mype

    ! ------------------------------------------------------------------------
    ! Communicate dispersal to all procs. This is the key part of the prototype.
    ! ------------------------------------------------------------------------

    ! In CLM, we want to use the CLM global communicator, rather than MPI_COMM_WORLD
    call mpi_allreduce(dispersal_global_domain_mype, dispersal_global_domain_sum, &
         total_gridcells, MPI_INTEGER, MPI_SUM, MPI_COMM_WORLD, error)
    
    ! Format assumes 3 grid cells per proc, 4 procs
    write(*,'("Total dispersal: Proc ", i0, ": ", 12i4)') myproc, dispersal_global_domain_sum

    ! ------------------------------------------------------------------------
    ! Next would come the addition of the dispersal to each grid cell. That is not the
    ! focus of this prototype, so is omitted here.
    ! ------------------------------------------------------------------------

  end subroutine disperse_beetles

end module pine_beetles_mod


program pine_beetles
  use pine_beetles_mod
  use mpi
  implicit none

  integer :: error

  call mpi_init(error)

  call init_gridcells
  call disperse_beetles

  call mpi_finalize(error)

end program pine_beetles
