## rotfac.m
## Factor rotation (or simplicity-inducing basis discovery)
## using FORTRAN program rotatem_real8.for
##
## Usage:
##  [rfp, tmx, dmu] = rotfac (ufm, meth, nf)
##
## Returns:
##    rfp    - rotated primary pattern matrix (nv, nf)
##    tmx    - transformation matrix (nf, nf)
##    dmu    - d multipliers (nf)
##
## Inputs:
##    ufm    - unrotated factor matrix (nv, nc) 
##    meth   - rotation method (V=Varimax, O=Orthoblique,
##               M=Proportional Orthoblique, B=Oblisim,
##               P=Primary Product Functionplane)
##    nf     - factors to rotate (must be <= nc)
##    nv     - variables or channels
##    nc     - columns in ufm (nf <= nc)
##
## Added note: In the original mathematics rfp is the matrix P,
## tmx is the matrix (T')^-1 , dmu is a vector of D-multipliers
## (related to the VIFs), and ufm is the matrix A.  In the model,
## P = A * (T')^-1 where the columns of T are the new unit-length
## basis vectors, and S (not calculated here) would be A * T.  In
## the world of factor analysis, P (the contravariant representation)
## would be referred to as the Primary Pattern matrix, while S
## (the covariant representation) would be referred to as the
## Factor Structure matrix.
##
## Updated for double precision 20 July 2026.
## Written by: Jeffrey Owen Katz, Ph.D.
## email: jeffkatz@scientific-consultants.com

function [rfp, tmx, dmu] = rotfac (ufm, meth, nf)

  # Remove any existing temporary file(s)
  system ("rm -f /tmp/rot93???");

  # Write unrotated factor matrix (ufm) to temporary file
  fid = fopen ("/tmp/rot93ufm", "wt");
  if (fid < 0)
    error ("rotfac.m  cannot open /tmp/rot93ufm \n");
  end
  fprintf (fid, "%10d\n", rows (ufm));  # for larger problems
  fprintf (fid, "%10d\n", columns (ufm));
  fprintf (fid, "%18.10e\n", ufm);	# for increased precision
  fclose (fid);

  # Construct command line for FORTRAN rotation programme
  # Original
  #    cmd = sprintf("./rotatem meth=%s nf=%d ufm=%s", ...
  #             meth, nf, "/tmp/rot93ufm");
  # Updated below for double precision
  cmd = sprintf("./rotatem_real8 meth=%s nf=%d ufm=%s", ...
                 meth, nf, "/tmp/rot93ufm");
  cmd = [cmd " rfp=/tmp/rot93rfp tmx=/tmp/rot93tmx"];
  cmd = [cmd " dmu=/tmp/rot93dmu"];

  # Execute FORTRAN programme
  system (cmd);

  # Get matrices to be returned
  X = dlmread ("/tmp/rot93rfp");
  rfp = reshape (X (3 : end), X(1), X(2)); 
  X = dlmread ("/tmp/rot93tmx");
  tmx = reshape (X (3 : end), X(1), X(2)); 
  X = dlmread ("/tmp/rot93dmu");
  dmu = reshape (X (3 : end), X(1), X(2)); 
end

 
