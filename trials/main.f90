PROGRAM MAIN

  USE DEBUGGER
  USE TENSOR_TYPES
  USE MODE_N
  USE SWAP_AXIS
  USE MAT_UTILS
  USE CPD_UTILS
  USE TUCKER
  USE MPS_MOD
  
  IMPLICIT NONE

  INTEGER,ALLOCATABLE::dimm(:)
  REAL*8,ALLOCATABLE::IN(:,:),boh1(:,:),boh2(:,:)
  INTEGER,ALLOCATABLE::vec(:),ranks(:)
  INTEGER::nn,rows,cols,kk,ii
  TYPE(DTENSOR3)::my_tens,copy,approx,core
  !JUST TO TRY...
  TYPE(matrix_list) :: lista(3)
  TYPE(tensor_list) :: tens_lista(3)
  
  INTEGER*4 :: rango
  REAL*8 :: threshold, error, array(3,3), cose(3)
  REAL*8, ALLOCATABLE :: lambdas(:)
  !OPEN(332,file='../data/mnist_1k.csv',status="old",action="read")
  OPEN(332,file='../data/land_112_240.csv',status="old",action="read")
  READ (332, *) nn
  ALLOCATE(dimm(nn))
  READ(332,*) dimm
  rows=dimm(1)
  cols=1
  DO kk=2,nn
     cols=cols*dimm(kk)
  END DO
  ALLOCATE(IN(cols,rows))
  READ(332,*) IN
  IN=TRANSPOSE(IN)
  CLOSE(332)
  my_tens=TENSOR3(dimm,IN,1) ! assuming mode 1

  !TUCKER DECOMPOSITION
  ALLOCATE(ranks(3))
  ranks = (/ 10,20,3 /)
  CALL HOSVD(my_tens,ranks,core,lista)
  !CALL HOOI3(my_tens,ranks,core,lista,error,randinit=.TRUE.)
  approx = RECO(core,lista)
  OPEN(333,file='../data/land_112_240_hosvd_10_20_3.csv',status="unknown",action="write")
  !OPEN(333,file='../data/mnist_1k_random_300_10_10.csv',status="unknown",action="write")
  DO ii=1,dimm(1)
     WRITE(333,*) approx%elems(ii,:,:) 
  END DO
  CLOSE(333)

  ! !CP DECOMPOSITION
  ! rango=10
  ! CALL CPD(my_tens,rango,lista,lambdas,error,numiter=2)
  ! !RECONSTRUCT
  ! core = TENSOR3( (/rango,rango,rango/) , TO_IDENTITY(lambdas,SIZE(my_tens%modes)) , 1 )
  ! approx = RECO3(core,lista)
  ! !SAVE ON FILE
  ! OPEN(333,file='../data/land_112_240_cpd_10_iter_2.csv',status="unknown",action="write")
  ! DO ii=1,dimm(1)
  !   WRITE(333,*) approx%elems(ii,:,:) 
  ! END DO
  ! CLOSE(333)

  !MPS? MAYBE!
  print*, "launching mps"
  CALL MPS(my_tens,tens_lista,eps=1D-2)  ! roughly half the parameters for 1% error
  print*, "Total cores size:", SIZE(tens_lista(1)%cores%elems)+SIZE(tens_lista(2)%cores%elems)+SIZE(tens_lista(3)%cores%elems)
  print*, "Original size:", SIZE(my_tens%elems)
END PROGRAM MAIN
  
