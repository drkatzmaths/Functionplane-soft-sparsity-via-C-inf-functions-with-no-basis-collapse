# Code Directory

This directory contains:

- **Fortran source files** (`.for` files): Original 1973 algorithms (with somewhat updated code for F77 and now for gfortran) for Primary Product Functionplane & other rotations/models
- **Octave/Matlab wrapper files** (`.m` files): Modern wrappers for compatibility with Octave and Matlab

## Compilation Instructions

```bash
gfortran -O3 -std=legacy -fdefault-real-8 -fdefault-double-8 rotatem_real8.for -o rotatem_real8
```

## Usage with Octave/Matlab

Add this directory to your Octave/Matlab path, compile and link with gfortran, and call the wrapper function from within Octave.  You can read the comments in the wrapper function (rotfac.m) to see how to use this function within Octave.

[To be expanded with specific function descriptions, arguments, and examples]
