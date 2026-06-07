## rotfac.m
## Factor rotation using FORTRAN program rotatem.for
##
## Usage:
##  [rfp, tmx, dmu] = rotfac (ufm, meth, nf)
## Returns:
##    rfp    - rotated factor matrix (nv, nf)
##    tmx    - transformation matrix (nf, nf)
##    dmu    - d multipliers (nf)
## Inputs:
##    ufm    - unrotated factor matrix (nv, nc)
##    meth   - rotation method (V=Varimax, O=Orthoblique,
##               M=Proportional Orthoblique, B=Oblisim,
##               P=Primary Product Functionplane)
##    nf     - factors to rotate (must be <= nc)
##    nv     - variables
##    nc     - columns in ufm (keep nf <= nc)
##
## Written by: Jeffrey Owen Katz, Ph.D.
## email: jeffkatz@scientific-consultants.com

function [rfp, tmx, dmu] = rotfac (ufm, meth, nf)

  # Remove any existing file(s)
  system ("rm -f /tmp/rot93???");

  # Write unrotated factor matrix to temporary file
  fid = fopen ("/tmp/rot93ufm", "wt");
  if (fid < 0)
    error ("rotfac.m  cannot open /tmp/rot93ufm \n");
  end
  fprintf (fid, "%6d\n", rows (ufm));
  fprintf (fid, "%6d\n", columns (ufm));
  fprintf (fid, "%16.8e\n", ufm)
  fclose (fid);

  # Construct command line for FORTRAN rotation programme
  cmd = sprintf("./rotatem meth=%s nf=%d ufm=%s", ...
                 meth, nf, "/tmp/rot93ufm");
  cmd = [cmd " rfp=/tmp/rot93rfp tmx=/tmp/rot93tmx"];
  cmd = [cmd " dmu=/tmp/rot93dmu"];

  # Execute FORTRAN rotation programme
  system (cmd);

  # Get matrices to be returned
  X = dlmread ("/tmp/rot93rfp");
  rfp = reshape (X (3 : end), X(1), X(2)); 
  X = dlmread ("/tmp/rot93tmx");
  tmx = reshape (X (3 : end), X(1), X(2)); 
  X = dlmread ("/tmp/rot93dmu");
  dmu = reshape (X (3 : end), X(1), X(2)); 
end

 
