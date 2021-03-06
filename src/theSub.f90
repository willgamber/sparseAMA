MODULE linsolution_module
!
!
!Purpose: To declare functions that we use to solve linearized version of the New Keynesian model.
!      
!
!
!
!       
!              
!   Record of Revisions:
!
!       Date                 Description of Change                                                 Programmer
!     ========              =======================                                               ============
!     5-30-13                Original Code                                                            cjg
USE solution_module
IMPLICIT NONE

INTEGER, PARAMETER :: Nlin = 8  !number of variables in linear state space 
INTEGER, PARAMETER :: Nklin = 6   !number of linear state variables (including shocks)

CONTAINS

!-------------------------------------------------------------------------------------------------------------------------

SUBROUTINE linunconstrained(param,dlin,retco)
!
! 
!
!  Purpose: Uses linear equations to get unconstrained decision rule to NK model.  
!      
!
!
!                   Date                     Description of Change                                  Programmer
!                  ======                 =================================                        ===========
!                   11-21-12                  original code                                            cjg
!                   3-26-13                 exponential filter                                         cjg 
!                   5-30-13                 removed exponential filter                                 cjg
USE solab
IMPLICIT NONE


!Input/output variables
DOUBLE PRECISION, INTENT(IN)     :: param(Nparam)
DOUBLE PRECISION, INTENT(OUT)    :: dlin(Nlin,Nklin)
INTEGER, INTENT(OUT)             :: retco

!local variables
DOUBLE PRECISION :: beta,gamma,phi,ep,gampi,gamg,rhor,rhoe,sigmath,sigmar,sigmae,gr,pibar
DOUBLE PRECISION :: wss,gdpss,nomrss,gamtil
DOUBLE PRECISION :: flin(Nlin-Nklin,Nklin),plin(Nklin,Nklin)
DOUBLE PRECISION :: alin(Nlin,Nlin),blin(Nlin,Nlin)

beta = param(1); gamma = param(2); phi = param(3); ep = param(4)
gampi = param(5); gamg = param(6); rhor = param(7); rhoe = param(8)
sigmath = param(9); sigmar = param(10); sigmae = param(11); gr = param(12)-1
pibar = param(13)

!steady state
wss = (ep-1)/ep
gdpss = ((ep-1)/ep)/(1-gamma/exp(gr))
nomrss = log(exp(gr)*pibar/beta)
gamtil = gamma/exp(gr)

!!Our hope is to replace the 
!!following section with the parser
!!we'd call the code that the
!!parser generates here

alin = 0.0d0
blin = 0.0d0

!tech shock
alin(1,1) = 1.0d0

!demand shock
alin(2,2) = 1.0d0
blin(2,2) = rhoe

!monetary shock
alin(3,3) = 1.0d0

!marginal utility of consumption
blin(4,8) = -1.0d0
alin(4,5) = 1.0d0/(1.0d0-gamtil)
blin(4,5) = gamtil/(1.0d0-gamtil)
blin(4,1) = -gamtil/(1.0d0-gamtil)

!consumption euler
blin(5,8) = -1.0d0
alin(5,8) = -1.0d0
alin(5,4) = -1.0d0
alin(5,7) = 1.0d0
blin(5,2) = -1.0d0
alin(5,1) = 1.0d0

!pricing equation
blin(6,7) = -1.0d0
alin(6,7) = -beta
blin(6,8) = -(ep-1)/phi

!interest rate rule for national rate
alin(7,4) = 1.0d0
blin(7,4) = rhor
blin(7,7) = gampi


alin(7,5) = -gamg
blin(7,5) = -gamg
blin(7,1) = gamg
blin(7,3) = 1.0d0


alin(8,6) = 1.0d0

!!in lieu of zsolab
!!we'd call sparseAMA here

CALL zsolab(flin,plin,alin,blin,Nlin,Nklin,retco)
dlin(1:Nklin,:) = plin
dlin(Nklin+1:Nlin,:) = flin

!!convert sparse c matrix
!!to dense matrix in fortran

END SUBROUTINE linunconstrained


!--------------------------------------------------------------------------------------------------------------

SUBROUTINE decrlin(endogvarm1,currentshocks,polysolution,dlin,endogvar)   
!
!Purpose:  Linear decision rule for GLSS (2012) NK model without capital and sticky wages.
!         
!
!   Record of Revisions:
!
!       Date                  Description of Change                                     Programmer
!     =========              =======================                                   ==============
!      5-25-13                original program                                              cjg
IMPLICIT NONE
!Declare inputs/outputs
TYPE(polydetails), INTENT(IN)   :: polysolution
INTEGER,           INTENT(IN)   :: currentshocks(Nexog)
DOUBLE PRECISION, INTENT(IN)    :: endogvarm1(Nmsv+Ncontrol),dlin(Nlin,Nklin)
DOUBLE PRECISION, INTENT(OUT)   :: endogvar(Nmsv+Ncontrol)  

!Declare local variables
INTEGER          :: Nr,Nth,Ne
DOUBLE PRECISION :: xlinstate(Nklin),xlinstatep(Nlin)
DOUBLE PRECISION :: rshock(Nshock(3))
DOUBLE PRECISION :: thshock(Nshock(2))
DOUBLE PRECISION :: eshock(Nshock(1))

Ne = Nshock(1)
Nth = Nshock(2)
Nr = Nshock(3)
eshock = polysolution%shockvalues(1:Ne)
thshock = polysolution%shockvalues(Ne+1:Ne+Nth)
rshock = polysolution%shockvalues(Ne+Nth+1:Ne+Nth+Nr)

xlinstate = 0.0d0
xlinstate(1) = thshock(currentshocks(2))
xlinstate(2) = -eshock(currentshocks(1))  !make discount factor shock a discount rate shock as expected by linear solution).
xlinstate(3) = rshock(currentshocks(3))
xlinstate(4) = endogvarm1(1)  
xlinstate(5) = endogvarm1(3) 

CALL dgemv('N',Nlin,Nklin,1.0d0,dlin,Nlin,xlinstate,1,0.0d0,xlinstatep,1)

endogvar = 0.0d0
endogvar(1) = xlinstatep(4)
endogvar(2) = xlinstatep(7)
endogvar(3) = xlinstatep(5)
endogvar(4) = xlinstatep(8)
endogvar(5) = xlinstatep(4)

END SUBROUTINE decrlin   
   
!----------------------------------------------------------------------------------------------------------------------

SUBROUTINE get_linearstate(currentshocks,currentgrid,polysolution,dlin,solcoeff0)
!
!Uses linear model to construct initial guess at polynomial coefficients for a given state.
!
!         
!
!   Record of Revisions:
!
!       Date                  Description of Change                                Programmer
!     =========              =======================                              ==============
!      12-21-12                original program                                        cjg
!      3-12-13                 updated for ygap model                                  cjg
!      3-26-13                 updated for exp filter                                  cjg
!      4-16-13                 regression constant rewrite                             cjg
!      5-26-13                 derived data types                                      cjg

IMPLICIT NONE
!Declare inputs/outputs
INTEGER,          INTENT(IN)  :: currentshocks(Nexog)
DOUBLE PRECISION, INTENT(IN)  :: currentgrid(Nmsv,Ngrid),dlin(Nlin,Nklin)
TYPE(polydetails), INTENT(IN)  :: polysolution 
DOUBLE PRECISION, INTENT(OUT) :: solcoeff0(Nfunc*Npoly)


!Declare local parameters and variables
INTEGER          :: rr,ind,ipoly,order(Nmsv),indvar
DOUBLE PRECISION :: llam_new(Ngrid),ldp_new(Ngrid)
DOUBLE PRECISION :: y1(Ngrid),y2(Ngrid)
DOUBLE PRECISION :: xreg(Ngrid,Npoly-1),xx(Nmsv),xreg_dev(Ngrid,Npoly-1)
DOUBLE PRECISION :: resid(Ngrid),endogvar(Nmsv+Ncontrol),endogvarm1(Nmsv+Ncontrol)
DOUBLE PRECISION :: ldp_new_m,llam_new_m,xreg_m(Npoly-1)
DOUBLE PRECISION :: vpc(Npoly-1,Npoly-1)
DOUBLE PRECISION :: solcoeftilde(Nfunc*(Npoly-1))
DOUBLE PRECISION :: zreg_dev(Ngrid,Npoly-1),solcoeftemp(Nfunc*(Npoly-1))

llam_new = 0.0d0
ldp_new = 0.0d0
xreg = 0.0d0
DO ind = 1,Ngrid  !sum of regression points
   xx = currentgrid(:,ind)
   order = 0
   DO ipoly = 1,Npoly-1   !sum over regression coefficients
      order = nextpoly(order,Nmsv)
      xreg(ind,ipoly) = xx(1)**order(1)
      DO indvar = 2,Nmsv
         xreg(ind,ipoly) = xreg(ind,ipoly)*(xx(indvar)**order(indvar))
      END DO
   END DO

   endogvarm1(1:Nmsv) = xx
   CALL decrlin(endogvarm1,currentshocks,polysolution,dlin,endogvar)  
   llam_new(ind) = endogvar(4)
   ldp_new(ind) = endogvar(2)
END DO

!run PC regression to determine polynomial coefficients
solcoeff0 = 0.0d0
llam_new_m = SUM(llam_new)/Ngrid
ldp_new_m = SUM(ldp_new)/Ngrid
xreg_m = SUM(xreg,DIM=1)/Ngrid
y1 = llam_new-llam_new_m
y2 = ldp_new-ldp_new_m

DO ind = 1,Ngrid 
   xreg_dev(ind,:) = xreg(ind,:)-xreg_m
END DO

!principal component analysis and regression
CALL pcanalysis(xreg_dev,Ngrid,Npoly-1,vpc,rr)
solcoeftemp = 0.0d0
zreg_dev = 0.0d0
CALL dgemm('N','N',Ngrid,rr,Npoly-1,1.0d0,xreg_dev,Ngrid,vpc,Npoly-1,0.0d0,zreg_dev,Ngrid)
CALL ols_slope(y1,zreg_dev(:,1:rr),rr,Ngrid,solcoeftemp(1:rr),resid)
CALL ols_slope(y2,zreg_dev(:,1:rr),rr,Ngrid,solcoeftemp(Npoly:Npoly+rr-1),resid)
call DGEMV('N', Npoly-1, rr, 1.0d0, vpc, Npoly-1, solcoeftemp(1:rr), 1, 0.0d0, solcoeftilde(1:Npoly-1), 1)
call DGEMV('N', Npoly-1, rr, 1.0d0, vpc, Npoly-1, solcoeftemp(Npoly:Npoly+rr-1), 1, 0.0d0, solcoeftilde(Npoly:2*(Npoly-1)), 1)
solcoeff0(2:Npoly) = solcoeftilde(1:Npoly-1)
solcoeff0(Npoly+2:2*Npoly) = solcoeftilde(Npoly:2*(Npoly-1))
solcoeff0(1) = llam_new_m-DOT_PRODUCT(xreg_m,solcoeftilde(1:Npoly-1)) 
solcoeff0(1) = ldp_new_m-DOT_PRODUCT(xreg_m,solcoeftilde(Npoly:2*(Npoly-1)))

END SUBROUTINE get_linearstate

!----------------------------------------------------------------------------------------------------------------------

SUBROUTINE get_initialguess(polysolution,dlin)
!
!Purpose: Use linear model to construct starting guess for alphacoeff.
!         
!   Record of Revisions:
!
!       Date                  Description of Change                                     Programmer
!     =========              =======================                                  ==============
!      5-31-13                original program                                             cjg
USE omp_lib
IMPLICIT NONE
!Declare inputs/outputs
TYPE(polydetails), INTENT(INOUT) :: polysolution
DOUBLE PRECISION, INTENT(IN)     :: dlin(Nlin,Nklin)

!Declare local variables
INTEGER          :: ss,polyss,jgrid
DOUBLE PRECISION :: solcoeff(Nfunc*Npoly,Ns*2)

call OMP_SET_NUM_THREADS(Nthreads)

!$OMP PARALLEL DO DEFAULT(SHARED) PRIVATE(jgrid,polyss)
DO ss = 1,Ns
   IF (polysolution%statezlbinfo(ss) <= 2) THEN 
      jgrid = 1
      polyss = ss
   ELSE
      jgrid = 2 
      polyss = Ns+ss
   END IF

   CALL get_linearstate(polysolution%stateinfo(:,ss),polysolution%clustergrid(Nmsv*(jgrid-1)+1:Nmsv*jgrid,:),&
        polysolution,dlin,solcoeff(:,polyss))

   IF (polysolution%statezlbinfo(ss) .EQ. 2) THEN
      jgrid = 2 
      polyss = Ns+ss
      
      CALL get_linearstate(polysolution%stateinfo(:,ss),polysolution%clustergrid(Nmsv*(jgrid-1)+1:Nmsv*jgrid,:),&
        polysolution,dlin,solcoeff(:,polyss))
   END IF
END DO
!$OMP END PARALLEL DO

polysolution%alphacoeff = solcoeff
CALL alphafill(polysolution) 

END SUBROUTINE get_initialguess

!-----------------------------------------------------------------------------------------------------------------------------------------------------------------

END MODULE linsolution_module
