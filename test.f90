PROGRAM MAIN
  IMPLICIT NONE

  TYPE :: list_modes
     INTEGER, ALLOCATABLE :: mode(:,:)
  END TYPE list_modes

  TYPE(list_modes), ALLOCATABLE :: lm(:)

  INTEGER,ALLOCATABLE::modes_dim(:)

  INTEGER::full_dim,ii,jj,rows,cols

  ALLOCATE(modes_dim(3))
  modes_dim=(/2,3,4/)

  full_dim=PRODUCT(modes_dim)
  
  ALLOCATE(lm(SIZE(modes_dim)))

  DO ii=1,SIZE(modes_dim)
     rows=modes_dim(ii)
     cols=full_dim/modes_dim(ii)
     ALLOCATE(lm(ii)%mode(rows,cols))
     lm(ii)%mode=0
  END DO

  DO ii=1,SIZE(modes_dim)
     PRINT*, "MODE ", ii
     DO jj=1,SIZE(lm(ii)%mode,1)
        PRINT*, lm(ii)%mode(jj,:)
     END DO
  END DO

end program main
