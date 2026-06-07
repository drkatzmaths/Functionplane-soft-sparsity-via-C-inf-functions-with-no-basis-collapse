c  rotatem.for
c
c  Complete programme to compute a factor rotation using any
c  of several effective methods.  This version (rotatem.for)
c  has been modified for greater compatibility with gnu Octave.
c
c  Compile with:
c    gfortran -Os -std=legacy rotatem.for -o rotatem
c
c  Copyright (C) 1973, 1990, 2011, 2018.  All rights reserved
c  Jeffrey Owen Katz, Ph.D. <jeffkatz@scientific-consultants.com>
c  Tel: 631-696-3333

c  Declare fixed parameters

      parameter          (maxvar = 8200)        ! max. variables
      parameter          (maxfac = 120)         ! max. factors

      parameter          (maxff = maxfac * maxfac)
      parameter          (maxvf = maxvar * maxfac)

c  Declare arrays and strings

      real               ufmx (maxvf)           ! unrotated factor matrix
      real               rfmx (maxvf)           ! rotated factor pattern
      real               tmx (maxff)            ! transformation to pattern
      real               cmx (maxff)            ! interfactor correlations
      real               pmx (maxff)            ! primary vectors
      real               dmult (maxfac)         ! diagonal multipliers
      real               hsq (maxvar)           ! communalities

      integer            lwork (maxfac)         ! scratch vector
      integer            mwork (maxfac)         ! scratch vector

      character*128      ifufm                  ! unrotated factor filename
      character*128      ofrfp                  ! rotated factor filename
      character*128      oftmx			! transformation filename
      character*128      offfc			! interfactor r filename
      character*128      ofdmu			! d-multiplier filename
      character*128      ofhsq			! communalities filename
      character*128      chbuf			! character buffer
      character*128      blank			! empty string
      character*1        meth                   ! method specifier
      
      data blank / '  ' /			! empty string

c  Define saves and output-flags common

      save rfmx                  ! prevents use of stack space
      save ufmx                  ! ditto

      common /OFLAGS/ icvgf, idebf
      icvgf = 1                  ! set to 1 for convergence output
      idebf = 0                  ! set to 1 for debugging output

c  Get problem specifications from command line arguments

      n = IARGC ()
      hwp = 0.15
      nfac = 0
      meth = 'V'
      ifufm = blank
      ofrfp = blank
      oftmx = blank
      offfc = blank
      ofdmu = blank
      ofhsq = blank
      do 372 i = 1, n
          call GETARG (i, chbuf)
          if (chbuf .eq. '-h' .or. chbuf .eq. '--help') go to 567
          if (chbuf .eq. '-u') go to 563
          if (chbuf(1:4) .eq. 'ufm=') ifufm = chbuf(5:)
          if (chbuf(1:4) .eq. 'rfp=') ofrfp = chbuf(5:)
          if (chbuf(1:4) .eq. 'tmx=') oftmx = chbuf(5:)
          if (chbuf(1:4) .eq. 'ffc=') offfc = chbuf(5:)
          if (chbuf(1:4) .eq. 'dmu=') ofdmu = chbuf(5:)              
          if (chbuf(1:4) .eq. 'hsq=') ofhsq = chbuf(5:)
          if (chbuf(1:3) .eq. 'hw=') read (chbuf(4:), *) hwp
          if (chbuf(1:3) .eq. 'nf=') read (chbuf(4:), *) nfac
          if (chbuf(1:5) .eq. 'meth=') meth = chbuf(6:6)
372       continue
      go to 562
567   write (*,'(1x, ''Usage: Needs to be written!'')')
      stop

c  Or get problem specifications interactively

563   write (*,'(1x,''No. factors to rotate: ''$)')
      read (*,*) nfac
      write (*,743)
743   format (1x,'Select one of the following as the method:'/
     1   4x,'O = orthoblique, independent clusters solution'/
     2   4x,'M = orthoblique, proportional solution'/
     3   4x,'B = oblisim'/
     4   4x,'P = primary product functionplane'/
     5   4x,'V = standard normalized varimax (orthogonal)')
      write (*,'(1x,''Method [O,M,B,P, or V]: ''$)')
      read (*,'(a1)') meth
      write (*,'(1x,''Input file [unrotated factor matrix]: ''$)')
      read (*,'(a128)') ifufm
      write (*,'(1x,''Output file [rotated factor pattern]: ''$)')
      read (*,'(a128)') ofrfp
      write (*,'(1x,''Output file [transformation]: ''$)')
      read (*,'(a128)') oftmx
      write (*,'(1x,''Output file [factor correlations]: ''$)')
      read (*,'(a128)') offfc
      write (*,'(1x,''Output file [d-values]: ''$)')
      read (*,'(a128)') ofdmu
      write (*,'(1x,''Output file [communalities]: ''$)')
      read (*,'(a128)') ofhsq

562   continue

c  Test user-supplied parameters for validity

      if (ifufm .eq. blank) then
          write (*,*) 'Error: no unrotated factor matrix specified'
          stop
      elseif (nfac .gt. maxfac .or. nfac .lt. 2) then
          write (*,*) 'Error: number of factors out-of-range'
          stop
      elseif (meth .ne. 'O' .and. meth .ne. 'B' .and.
     1        meth .ne. 'P' .and. meth .ne. 'M' .and.
     2        meth .ne. 'V') then
          write (*,*) 'Error: invalid method specified'
          stop
      endif
      
c  Read unrotated factor matrix  (gnu Octave format)

      open (8, FILE = ifufm)
      read (8, '(i6)') nvar, ncol
      if (nfac .gt. ncol) stop 'nfac .gt. ncol'
      if (nvar .gt. maxvar) stop 'nvar .gt. maxvar'
      read (8, 102) ((ufmx(i+nvar*(j-1)), i=1,nvar), j=1,nfac)
 102  format (E16.8)
      close (8)

c  Debug code to verify read of input and write of output
c      write (*, *) 'INPUT MATRIX:  NVAR=',nvar,'  NFAC=',nfac
c      write (*, *) 'NCOL=', ncol
c      write (*, *) ufmx(2), ufmx(12)
c      call AWRITE ('TEST2.TMP', nvar, ncol, ufmx)
c      stop

c  Compute the required transformation matrix [tmx] in the form
c  of a transformation to reference structure.  Arrays [rfmx],
c  [pmx], [cmx] and [dmult] are used as scratch arrays here.
c  An initial transformation is required for the Oblisim and
c  Primary Product Functionplane methods; Orthoblique is used
c  to compute this initial transformation.

      if (meth .eq. 'O') then
          wcol = 0.0    ! orthoblique independent clusters solution
          wrow = 1.0
      elseif (meth .eq. 'M') then
          wcol = 0.5    ! orthoblique proportional solution
          wrow = 1.0
      elseif (meth .eq. 'V') then
          wcol = 1.0    ! standard orthogonal normalized varimax
          wrow = 0.0
      elseif (meth .eq. 'P') then
          write (*,'(1x,''Hyperplane width (0.15 is good): ''$)')
          read (*,*) hwp
      endif

      if (meth.eq.'O' .or. meth.eq.'M' .or. meth.eq.'V') then
          call ACOPY (ufmx, rfmx, nvar * nfac)
          call ORTOB (rfmx, tmx, wrow, wcol, nvar, nfac)
      elseif (meth .eq. 'B') then
          call ACOPY (ufmx, rfmx, nvar*nfac)
          call ORTOB (rfmx, tmx, 1.0, 0.0, nvar, nfac)
          call OBLIS (ufmx, rfmx, tmx, pmx, cmx, dmult, lwork,
     1                 mwork, crit, nvar, nfac)
      elseif (meth .eq. 'P') then
          call ACOPY (ufmx, rfmx, nvar*nfac)
          call ORTOB (rfmx, tmx, 1.0, 0.0, nvar, nfac)
          call PPFPL (ufmx, tmx, pmx, cmx, dmult, lwork,
     1                 mwork, hwp, nvar, nfac)
      else
          write (*,*) 'Error: invalid method specification'
          stop
      endif

c  The transformation to a reference structure solution is now
c  available in array [tmx].  Using that solution, compute the
c  transformation to primary pattern [tmx], the rotated,
c  factor pattern matrix [rfmx], the interfactor correlations
c  [cmx], the array of primary row-vectors [pmx], and
c  the d-multiplier values [dmult].

      call FTPCD (ufmx, rfmx, tmx, pmx, cmx, dmult,
     1             lwork, mwork, nvar, nfac)

c  Compute the communalities in [hsq]

      if (ofhsq .ne. blank) then
          do 10 ivar = 1, nvar
              hsq(ivar) = 0.0
              do 10 ifac = 1, nfac
                  ip = ivar + (ifac - 1) * nvar
10                hsq(ivar) = hsq(ivar) + ufmx(ip)**2
      endif

c  Write the results to output files

      if (ofrfp .ne. blank) call AWRITE (ofrfp, nvar, nfac, rfmx)
      if (oftmx .ne. blank) call AWRITE (oftmx, nfac, nfac, tmx)
      if (offfc .ne. blank) call AWRITE (offfc, nfac, nfac, cmx)
      if (ofdmu .ne. blank) call AWRITE (ofdmu, nfac, 1, dmult)
      if (ofhsq .ne. blank) call AWRITE (ofhsq, nvar, 1, hsq)

c  Terminate programme

      stop
      end

c----------------------------------------------------------------------

C UTILITY SUBROUTINES USED IN FACTOR ROTATION PROGRAMME
C WRITTEN BY JEFFREY OWEN KATZ, PH.D.
C MODIFIED 5/10/1998

C CALLED FROM SUBROUTINE PPFPL (PRIMARY PRODUCT FUNCTIONPLANE)

       SUBROUTINE PPFX1(C,PF,T,M,I,NV,NF)
       DIMENSION C(NF,NF),PF(NV,NF)
       DO 132 L=1,NF
  132  C(L,M)=C(L,M)+PF(I,L)*T
       RETURN
       END

       SUBROUTINE PPFX2(C,P,T,U,I,M,NF)
       DIMENSION C(NF,NF),P(NF,NF)
       DO 137 L=1,NF
  137  C(L,I)=C(L,I)+P(M,L)*T
       DO 139 L=1,NF
  139  C(L,M)=C(L,M)+P(I,L)*U
       RETURN
       END

C CALLED FROM SUBROUTINE MINV (GENERAL MATRIX INVERSION)

       SUBROUTINE MBGA(A,IW,JW,BIGA,K,N)
       DIMENSION A(N,N)
       BIGA=0.0
       DO 100 J=K,N
       DO 100 I=K,N
       IF(ABS(A(I,J)).LE.ABS(BIGA)) GO TO 100
       BIGA=A(I,J)
       IW=I
       JW=J
  100  CONTINUE
       RETURN
       END

       SUBROUTINE MRDU(A,X,K,N)
       DIMENSION A(N,N)
       DO 55 I=1,N
       IF(I.EQ.K) GO TO 55
       A(I,K)=A(I,K)*X
  55   CONTINUE
       DO 65 I=1,N
       IF(I.EQ.K) GO TO 65
       HOLD=A(I,K)
       DO 66 J=1,N
       IF(J.EQ.K) GO TO 66
       A(I,J)=A(I,J)+A(K,J)*HOLD
  66   CONTINUE
  65   CONTINUE
       X=-X
       DO 75 J=1,N
       IF(J.EQ.K) GO TO 75
       A(K,J)=A(K,J)*X
  75   CONTINUE
       RETURN
       END

       SUBROUTINE MXSW(A,B,SKIP,N)
       DIMENSION A(*),B(*)
       INTEGER SKIP
       I=1
       J=1
       DO 100 K=1,N
       HOLD=-A(I)
       A(I)=B(J)
       B(J)=HOLD
       I=I+SKIP
  100  J=J+SKIP
       RETURN
       END

C CALLED FROM SUBROUTINES VARMX AND ORTOB (VARIMAX AND ORTHOBLIQUE)

       SUBROUTINE MXAR(A,B,XCOS,XSIN,N)
       DIMENSION A(N),B(N)
       DO 100 I=1,N
       AI=A(I)
       A(I)=AI*XCOS+B(I)*XSIN
  100  B(I)=-AI*XSIN+B(I)*XCOS
       RETURN
       END

       SUBROUTINE MXSP(FA,FB,AA,BB,CC,DD,NV)
       DIMENSION FA(NV),FB(NV)
       AA=0.0
       BB=0.0
       CC=0.0
       DD=0.0
       DO 100 I=1,NV
       U=(FA(I)+FB(I))*(FA(I)-FB(I))
       T=(FA(I)+FA(I))*FB(I)
       BB=BB+T
       AA=AA+U
       DD=DD+(U+U)*T
  100  CC=CC+(U+T)*(U-T)
       RETURN
       END

C CALLED FROM SUBROUTINE OBLIS (OBLISIM)

       SUBROUTINE OBLX1(A,T,B,D,R,NV,NF)
       DIMENSION A(NV,NF),T(NF,NF),B(NV,NF),D(NF),R(NF,NF)
       DO 120 I=1,NV
       DO 125 J=1,NF
       B(I,J)=0.0
       DO 125 K=1,NF
  125  B(I,J)=B(I,J)+A(I,K)*T(K,J)
       DO 120 K=1,NF
       D(K)=B(I,K)**2
       DO 120 J=1,K
  120  R(J,K)=R(J,K)+D(J)*D(K)
       RETURN
       END

       SUBROUTINE OBLX2(A,B,G,D,R,NV,NF)
       DIMENSION A(NV,NF),B(NV,NF),G(NF,NF),D(NF),R(NF,NF)
       DO 140 I=1,NV
       DO 150 J=1,NF
  150  D(J)=B(I,J)**2
       DO 140 J=1,NF
       PSI=0.0
       DO 141 K=1,NF
  141  PSI=PSI+D(K)*R(K,J)
       PSI=B(I,J)*PSI
       DO 140 K=1,NF
  140  G(K,J)=G(K,J)+PSI*A(I,K)
       RETURN
       END

C CALLED FROM SEVERAL SUBROUTINES

       subroutine INPR (a, b, c, ia, ib, n)
c
c Caclulates the scalar product between two vectors
c
c   a   - input vector
c   b   - input vector
c   c   - output scalar product
c   ia  - input stride factor for vector a
c   ib  - input stride factor for vector b
c   n   - input number of elements
c
       dimension a(*), b(*)
       c = 0.0
       ipa = 1
       ipb = 1
       do 10 i = 1, n
           c = c + a(ipa) * b(ipb)
           ipa = ipa + ia
  10       ipb = ipb + ib
       return
       end

c----------------------------------------------------------------------

      subroutine ORTOB (fmx, tmx, wrow, wcol, nvar, nfac)
      dimension fmx(nvar,nfac), tmx(nfac,nfac)
      common /OFLAGS/ icvgf, idebf

c Calculates a general Orthoblique solution, which includes standard
c Varimax as a special case.  The required transformation matrix
c is returned.
c
c  fmx     unrotated orthogonal factor matrix (destroyed)
c  tmx     transformation (columns have arbitrary scale)
c  wrow    row 'warp' coefficient  (1.0 = no warp, 0.0 = normalized)
c  wcol    col 'warp' coefficient  (1.0 = no warp, 0.0 = normalized)
c  nvar    no. variables
c  nfac    no. factors
c  icvgf   convergence output flag
c
c  standard orthogonal normalized Varimax:  wrow=0.0, wcol=1.0
c  Orthoblique independent clusters: wrow=1.0, wcol=0.0
c  Orthoblique proportional solution: wrow=1.0, wcol=0.5

c  Generate identity matrix in [tmx]

      do 10 jfac = 1, nfac
          do 10 ifac = 1, nfac
10            tmx(ifac,jfac) = 0.0
      do 12 ifac = 1, nfac
12        tmx(ifac,ifac) = 1.0

c  Stretch or contract ('warp') columns of [fmx] and adjust [tmx]

      if (wcol .lt. 0.9999) then
          do 20 ifac = 1, nfac
              call INPR (fmx(1,ifac), fmx(1,ifac), temp, 1, 1, nvar)
              if (temp .gt. 0.0) then
                  temp = temp ** (0.5 * wcol - 0.5)
                  do 22 ivar = 1, nvar
22                    fmx(ivar,ifac) = fmx(ivar,ifac) * temp
              endif
20            tmx(ifac,ifac) = temp
      endif

c  Stretch or contract ('warp') rows of [fmx]

      if (wrow .lt. 0.9999) then
          do 30 ivar = 1, nvar
              call INPR (fmx(ivar,1), fmx(ivar,1), temp,
     1                    nvar, nvar, nfac)
              if (temp .gt. 0.0) then
                  temp = temp ** (0.5 * wrow - 0.5)
                  do 31 ifac = 1, nfac
31                    fmx(ivar,ifac) = temp * fmx(ivar,ifac)
              endif
30            continue
      endif

c  Begin main iteration loop

      do 40 iter = 1, 200

c  Compute varimax criterion (on 'warped' matrix) if required

          if (icvgf .eq. 1) then
              vmcr = 0.0
              do 50 ifac = 1, nfac
                  b2sum = 0.0
                  b4sum = 0.0
                  do 52 ivar = 1, nvar
                      b2 = fmx(ivar,ifac)**2
                      b2sum = b2sum + b2
52                    b4sum = b4sum + b2**2
50                vmcr = vmcr + (b4sum - b2sum**2 / nvar) / nvar
          endif

c  Set convergence test flag

          icflag = 1

c  Loop through all pairs of factors

          do 60 ifac = 1, nfac - 1
              do 60 jfac = ifac + 1, nfac

c  Compute the necessary angle of rotation

                  call MXSP (fmx(1,ifac), fmx(1,jfac), a, b,
     1                        c, d, nvar)
                  e = d - 2.0 * a * b / nvar
                  f = c - (a * a - b * b) / nvar
                  fourp = ATAN2 (e, f)
                  phi = fourp / 4.0

c  Clear convergence flag if any rotation is non-trivial

                  if (abs(phi) .gt. 0.0001) icflag = 0

c  Rotate pair of factors

                  cosp = COS (phi)
                  sinp = SIN (phi)
                  call MXAR (fmx(1,ifac), fmx(1,jfac),
     1                        cosp, sinp, nvar)

c  Rotate corresponding columns of transformation

                  call MXAR (tmx(1,ifac), tmx(1,jfac),
     1                        cosp, sinp, nfac)

c  Next pair of factors

60                continue

c  Display convergence information

          if (icvgf .eq. 1) write(*, '(1x,i6,f15.8)') iter, vmcr

c  Test for convergence

          if (icflag .eq. 1) go to 70

c  No convergence so continue with rotations

40        continue

c  Solution has converged so return.  To obtain the factor
c  pattern matrix, call subroutine FTPCD with the original,
c  unrotated factor matrix and the transformation obtained
c  from this subroutine (ORTOB).

70    return
      end

c----------------------------------------------------------------------

      SUBROUTINE MINV(A,N,D,L,M)
      DIMENSION A(N,N),L(N),M(N)
C
C INVERT A GENERAL MATRIX USING FULL PIVOTING.
C
C   A    GENERAL MATRIX, RETURNED INVERTED
C   N    DIMENSION OF MATRIX A (INPUT)
C   D    DETERMINANT OF A (OUTPUT)
C   L    SCRATCH VECTOR
C   M    SCRATCH VECTOR
C
      IF(N-1) 1002,1001,1000
1000  D=1.0
      DO 80 K=1,N
      IW=K
      JW=K
      CALL MBGA(A,IW,JW,BIGA,K,N)
      D=D*BIGA
      IF(ABS(D).LT.1.0E-30) GO TO 1003
      L(K)=IW
      M(K)=JW
      IF(IW.NE.K) CALL MXSW(A(K,1),A(IW,1),N,N)
      IF(JW.NE.K) CALL MXSW(A(1,K),A(1,JW),1,N)
      X=-1.0/BIGA
      CALL MRDU(A,X,K,N)
80    A(K,K)=X
      K=N-1
100   I=L(K)
      IF(I.NE.K) CALL MXSW(A(1,I),A(1,K),1,N)
      J=M(K)
      IF(J.NE.K) CALL MXSW(A(J,1),A(K,1),N,N)
      K=K-1
      IF(K.GE.1) GO TO 100
      RETURN
1001  D=A(1,1)
      A(1,1)=1.0/A(1,1)
      RETURN
1002  WRITE(*,1101) N
1101  FORMAT(1X,'MINV: INVALID N =',I8)
      STOP
1003  WRITE(*,1102)
1102  FORMAT(1X,'MINV: SINGULAR MATRIX')
      STOP
      END

c----------------------------------------------------------------------

c Subroutine computes a Primary Product Functionplane factor rotation
c to oblique simple structure.  This is one of the best hyperplane-fit
c type rotations available as of 2002.  See my article "Primary Product
c Functionplane: An Oblique Rotation To Simple Structure" (Katz &
c Rohlf, 1975) in Multivariate Behavioural Research.  The code here is
c a modified and updated version of the original code developed in 1973
c to run on an IBM-360 mainframe, and upon which the Functionplane
c paper was based.
c
c  PF  - UNROTATED ORTHOGONAL FACTOR MATRIX (INPUT)
c  TX  - TRANSFORMATION TO REFERENCE STRUCTURE
c          1) ON INPUT IT MUST CONTAIN AN INITIAL SOLUTION
c               (AN ORTHOBLIQUE SOLUTION WORKS WELL)
c          2) IT IS RETURNED WITH THE PPFP SOLUTION
c  HW  - HYPERPLANE WIDTH PARAMETER (INPUT)
c          1) GOOD VALUES OFTEN FALL BETWEEN 0.12 AND 0.18
c          2) THE ROUTINE IS ROBUST AND NOT VERY SENSITIVE TO
c               THE EXACT VALUE OF THE HYPERPLANE WIDTH
c  NV  - NUMBER OF VARIABLES (INPUT)
c  NF  - NUMBER OF FACTORS (INPUT)
c
c  ALL OTHER ARGUMENTS ARE SCRATCH ARRAYS

      SUBROUTINE PPFPL(PF,TX,P,C,D,MW,LW,HW,NV,NF)
      DIMENSION PF(NV,NF),TX(NF,NF),P(NF,NF),C(NF,NF)
      DIMENSION D(NF),MW(NF),LW(NF)
      COMMON /OFLAGS/ ICVGF, IDEBF
C...MAKE SURE COLUMNS OF TRANSFORMATION ARE NORMALIZED
      DO 105 J=1,NF
      CALL INPR(TX(1,J),TX(1,J),AA,1,1,NF)
      AA=SQRT(AA)
      DO 105 I=1,NF
105   TX(I,J)=TX(I,J)/AA
C...INITIALIZE VARIABLES AND CONSTANTS
      STPSIZ=0.01
      PSTEP=STPSIZ
      PCR=-1.0E20
      PDCR=1.0
      AA=-1.0/HW**2
      BB=-2.0*AA
C...BEGIN ITERATION LOOP
115   CR=0.0
C...COMPUTE GRADIENT, NORM OF GRADIENT, AND CRITERION VALUE
      DO 120 J=1,NF
      DO 120 I=1,NF
      C(I,J)=0.0
120   P(I,J)=TX(I,J)
      CALL MINV(P,NF,DD,MW,LW)
      DO 130 M=1,NF
      CALL INPR(P(M,1),P(M,1),B,NF,NF,NF)
      CC=B*AA
      PSI2EM=0.0
      SUMEM=0.0
      DO 132 I=1,NV
      CALL INPR(PF(I,1),TX(1,M),PSI,NV,1,NF)
      TT=CC*PSI**2
      T=0.0
      IF(TT.GT.-25.0) T=EXP(TT)
      SUMEM=SUMEM+T
      T=T*PSI
      PSI2EM=PSI2EM+PSI*T
132   CALL PPFX1(C,PF,T,M,I,NV,NF)
      PSI2EM=PSI2EM*BB/SUMEM
      CR=CR+ALOG(SUMEM)
      DD=2.0*CC/SUMEM
      T=PSI2EM*B
      DO 136 L=1,NF
136   C(L,M)=C(L,M)*DD+P(M,L)*T
      D(M)=PSI2EM
      IF(M.EQ.1) GO TO 130
      J=M-1
      DO 137 I=1,J
      CALL INPR(P(I,1),P(M,1),DD,NF,NF,NF)
      T=DD*PSI2EM
      U=DD*D(I)
137   CALL PPFX2(C,P,T,U,I,M,NF)
130   CONTINUE
      DD=0.0
      DO 180 J=1,NF
      CC=0.0
      DO 181 I=1,NF
      IF(ABS(TX(I,J)).LE.CC) GO TO 181
      CC=ABS(TX(I,J))
      L=I
181   CONTINUE
      MW(J)=L
      CC=-C(L,J)/TX(L,J)
      DO 180 I=1,NF
      IF(I.EQ.L) GO TO 180
      C(I,J)=C(I,J)+TX(I,J)*CC
      DD=DD+C(I,J)**2
180   CONTINUE
      DCR=SQRT(DD)
C...UPDATE STEP SIZE
      IF(CR-PCR.LT.0.40*PDCR*PSTEP) THEN
        STPSIZ=STPSIZ/2.5
      ELSE
        STPSIZ=STPSIZ*1.189207
      ENDIF
C...TAKE A STEP IN THE DIRECTION OF STEEPEST ASCENT AS
C...DEFINED BY THE GRADIENT
      T=STPSIZ/DCR
      DO 190 J=1,NF
      L=MW(J)
      U=0.0
      DO 191 I=1,NF
      IF(I.EQ.L) GO TO 191
      TX(I,J)=TX(I,J)+C(I,J)*T
      U=U+TX(I,J)**2
191   CONTINUE
190   TX(L,J)=SIGN(SQRT(1.0-U),TX(L,J))
C...DISPLAY CONVERGENCE FOR TEST PURPOSES
      IF(ICVGF.EQ.1) THEN
          WRITE(*,762) PSTEP,CR,DCR,(CR-PCR)/(PSTEP*PDCR)
762       FORMAT(1X,4F16.8)
      ENDIF
C...SAVE PREVIOUS VALUES FOR NEXT ITERATION
      PCR=CR
      PDCR=DCR
      PSTEP=STPSIZ
C...TEST CONVERGENCE
      IF(STPSIZ.GT.0.000001) GO TO 115
C...RETURN TO CALLING PROGRAMME
      RETURN
      END

c----------------------------------------------------------------------

c Subroutine computes an Oblisim rotation.  This is another very good
c method of oblique factor rotation.  Primary Product Functionplane
c (above) and Oblisim (below) represent the two best methods known
c for oblique simple-structure rotation.  They are not available in
c statistics packages.

      SUBROUTINE OBLIS(A,B,T,G,R,D,MW,LW,CR,NV,NF)
      DIMENSION A(NV,NF),B(NV,NF),T(NF,NF),G(NF,NF),R(NF,NF)
      DIMENSION D(NF),MW(NF),LW(NF)
      COMMON /OFLAGS/ ICVGF, IDEBF
C...INSURE THAT COLUMNS OF TRANSFORMATION ARE NORMALIZED
      DO 110 J=1,NF
      CALL INPR(T(1,J),T(1,J),X,1,1,NF)
      X=SQRT(X)
      DO 110 I=1,NF
110   T(I,J)=T(I,J)/X
C...INITIALIZE VARIABLES AND CONSTANTS
      STPSIZ=0.01
      PSTEP=STPSIZ
      PCR=-1.0E20
      PDCR=1.0
C...BEGIN ITERATION LOOP
115   CONTINUE
C...COMPUTE THE GRADIENT OF THE OBLISIM CRITERION FUNCTION
      DO 116 I=1,NF
      DO 116 J=1,NF
116   R(I,J)=0.0
      CALL OBLX1(A,T,B,D,R,NV,NF)
      DX=1.0
      DO 130 K=1,NF
      D(K)=R(K,K)
      DX=R(K,K)*DX
      DO 130 J=1,K
130   R(K,J)=R(J,K)
      CALL MINV(R,NF,DET,LW,MW)
      DO 135 K=1,NF
135   R(K,K)=R(K,K)-1.0/D(K)
      CR=DET/DX
      DO 137 I=1,NF
      DO 137 J=1,NF
137   G(I,J)=0.0
      CALL OBLX2(A,B,G,D,R,NV,NF)
      DD=0.0
      DO 180 J=1,NF
      CC=0.0
      DO 185 I=1,NF
      IF(ABS(T(I,J)).LE.CC) GO TO 185
      CC=ABS(T(I,J))
      L=I
185   CONTINUE
      MW(J)=L
      CC=-G(L,J)/T(L,J)
      DO 180 I=1,NF
      IF(I.EQ.L) GO TO 180
      G(I,J)=G(I,J)+CC*T(I,J)
      DD=DD+G(I,J)**2
180   CONTINUE
      DCR=4.0*SQRT(DD)
C...ADJUST THE STEP SIZE FOR THIS ITERATION
      IF(CR-PCR.LE.0.05*PSTEP*PDCR) THEN
        STPSIZ=STPSIZ/2.5
      ELSE
        STPSIZ=STPSIZ*1.189207
      ENDIF
C...TAKE A STEP IN THE DIRECTION OF STEEPEST ASCENT
C...AS DEFINED BY THE GRADIENT
      X=4.0*STPSIZ/DCR
      DO 190 J=1,NF
      L=MW(J)
      U=0.0
      DO 195 I=1,NF
      IF(I.EQ.L) GO TO 195
      T(I,J)=T(I,J)+X*G(I,J)
      U=U+T(I,J)**2
195   CONTINUE
190   T(L,J)=SIGN(SQRT(1.0-U),T(L,J))
C...PRINT OUT CONVERGENCE DATA
      IF(ICVGF.EQ.1) THEN
          WRITE(*,769) PSTEP,CR,DCR,(CR-PCR)/(PSTEP*PDCR)
769       FORMAT(1X,4F16.7)
      ENDIF
C...SAVE PREVIOUS VALUES
      PCR=CR
      PDCR=DCR
      PSTEP=STPSIZ
C...TEST CONVERGENCE
      IF(STPSIZ.GT.0.000001) GO TO 115
C...RETURN TO CALLING PROGRAMME
      RETURN
      END

c----------------------------------------------------------------------

      subroutine VARMX (nvar, nfac, fmx, trns, hsq)

      integer      nvar
      integer      nfac
      real         fmx (nvar, nfac)
      real         trns (nfac, nfac)
      real         hsq (nvar)

c  Standard Varimax orthogonal factor rotation.
c  nvar   no. variables
c  nfac   no. factors
c  fmx    factor matrix (returned rotated)
c  trns   transformation matrix
c  hsq    communalities

c  Normalize rows of fmx

      do 10 ivar = 1, nvar
          hsq(ivar) = 0.0
          do 12 ifac = 1, nfac
12            hsq(ivar) = hsq(ivar) + fmx(ivar,ifac)**2
          temp = SQRT (hsq(ivar))
          do 10 ifac = 1, nfac
10            fmx(ivar,ifac) = fmx(ivar,ifac) / temp

c  Generate identity matrix in trns

      do 16 icol = 1, nfac
          do 16 irow = 1, nfac
16            trns(irow,icol) = 0.0
      do 18 icol = 1, nfac
18        trns(icol,icol) = 1.0

c  Begin iteration loop

      do 20 iter = 1, 100

c  Compute varimax criterion

          vmcr = 0.0
          do 30 ifac = 1, nfac
              b2sum = 0.0
              b4sum = 0.0
              do 32 ivar = 1, nvar
                  b2 = fmx(ivar,ifac)**2
                  b2sum = b2sum + b2
32                b4sum = b4sum + b2**2
30            vmcr = vmcr + (b4sum - b2sum**2/nvar) / nvar

c  Set convergence test flag

          icflag = 1

c  Loop through all pairs of factors

          do 40 ifac = 1, nfac - 1
              do 40 jfac = ifac + 1, nfac

c  Compute the necessary angle of rotation

                  a = 0.0
                  b = 0.0
                  c = 0.0
                  d = 0.0
                  do 50 ivar = 1, nvar
                      x = fmx(ivar,ifac)
                      y = fmx(ivar,jfac)
                      u = x*x - y*y
                      v = (x+x) * y
                      a = a + u
                      b = b + v
                      c = c + (u*u - v*v)
50                    d = d + (u+u)*v
                  e = d - 2.0*a*b/nvar
                  f = c - (a*a - b*b)/nvar
                  fourp = ATAN2 (e, f)
                  phi = fourp / 4.0

c  Clear convergence flag if any rotation non-trivial

                  if (abs(phi) .gt. 0.001) icflag = 0

c  Rotate pair of factors

                  cosp = COS (phi)
                  sinp = SIN (phi)
                  do 60 ivar = 1, nvar
                      x = fmx(ivar,ifac)
                      y = fmx(ivar,jfac)
                      fmx(ivar,ifac) = x*cosp + y*sinp
60                    fmx(ivar,jfac) = -x*sinp + y*cosp

c  Rotate columns of transformation

                  do 62 irow = 1, nfac
                      x = trns(irow,ifac)
                      y = trns(irow,jfac)
                      trns(irow,ifac) = x*cosp + y*sinp
62                    trns(irow,jfac) = -x*sinp + y*cosp

c  Next pair of factors

40            continue

          write (*, '(1x,i6,f15.8)') iter, vmcr

c  Test for convergence

          if (icflag .eq. 1) go to 70

c  No convergence so continue with rotations

20        continue

c  Solution converged so denormalize fmx and return

70    do 82 ivar = 1, nvar
          temp = SQRT (hsq(ivar))
          do 82 ifac = 1, nfac
82            fmx(ivar,ifac) = temp * fmx(ivar,ifac)

      return
      end

c----------------------------------------------------------------------

      SUBROUTINE FTPCD(FA,FX,TX,P,C,D,MW,LW,NV,NF)
      DIMENSION FA(NV,NF),FX(NV,NF),TX(NF,NF)
      DIMENSION P(NF,NF),C(NF,NF),D(NF),MW(NF),LW(NF)

c Given an unrotated orthogonal factor matrix [FA], and a
c transformation to reference structure [TX], this subroutine
c calculates and returns the primary pattern factor matrix [FX],
c the transformation to primary pattern [TX], the primary reference
c vectors [P], the interfactor correlations [C], and the so-called
c d-multiplier values [D].  Additional arguments are the number of
c variables NV, the number of factors NF, and two scratch
c arrays [LW] and [MW].

      DO 10 J=1,NF
        CALL INPR(TX(1,J),TX(1,J),AX,1,1,NF)
        AX=SQRT(AX)
        DO 10 I=1,NF
          TX(I,J)=TX(I,J)/AX
10        P(I,J)=TX(I,J)
      CALL MINV(P,NF,AX,MW,LW)
      DO 20 J=1,NF
        CALL INPR(P(J,1),P(J,1),AX,NF,NF,NF)
        AX=SQRT(AX)
        D(J)=1.0/AX
        DO 20 I=1,NF
          P(J,I)=P(J,I)/AX
20        TX(I,J)=TX(I,J)*AX
      DO 25 J=1,NF
        DO 25 I=1,J
          CALL INPR(P(I,1),P(J,1),C(I,J),NF,NF,NF)
25        C(J,I)=C(I,J)
      DO 30 J=1,NF
        DO 30 I=1,NV
30        CALL INPR(FA(I,1),TX(1,J),FX(I,J),NV,1,NF)
      RETURN
      END

c----------------------------------------------------------------------

c Writes a general matrix (e.g., a factor matrix) in the format used
c by this programme.  Modified in this version (rotatem.for) for use
c with gnu Octave.

      subroutine AWRITE (ofile, nrow, ncol, array)
      character ofile*(*)
      dimension array(nrow,ncol)
      open(9, FILE=ofile)
      write(9,191) nrow, ncol
 191  format(i6)
      write(9,192) ((array(i,j),i=1,nrow),j=1,ncol)
 192  format(e16.8)
      close(9)
      return
      end

c Copies data from one array to another

      subroutine ACOPY (array1, array2, nelts)
      dimension array1(nelts), array2(nelts)
      do 10 i = 1, nelts
 10   array2(i) = array1(i)
      return
      end


