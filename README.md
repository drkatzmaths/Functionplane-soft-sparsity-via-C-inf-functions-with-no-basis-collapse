## 1970s Sparse Metric Tensors With Infinitely Differentiable Loss Functions: Representational Learning Engine

# Overview

This repository archives a pioneering geometrically adaptive Occam's engine that seeks a basis that optimizes soft sparsity in the contravariant representation.  It was originally implemented in IBM 360 Fortran in the early 1970s. The original code demonstrates very early work on:

- **Representational Learning**: Unsure of this.  AIs suggest this might be the first implementation of learning through representation discovery
- **Sparse Structures & Metric Tensors**: Advanced mathematical treatment of simplicity (soft sparsity) using dual spaces and a metric
- **Infinitely Differentiable Loss Functions**: Infinitely differentiable criterion (loss function) (no $\mathcal{L}\_0$ or $\mathcal{L}\_1$ "kludges") used to induce soft sparsity or simplicity, now recognized as a *redescending M-estimator*, in this case embedded in a manifold and serving as a target of optimization
- **Gradient Optimization**: Smooth, differentiable gradient optimization method with a simple adaptive stepsize (akin to a learning rate)
- **Adaptive Avoidance of Basis Collapse**: Adaptive intrinsic collinearity control emerging from the geometry without additional parameters (hyperparameters)
- **Approximate Maximum Likelihood Estimation**:  Under the assumption that small contravariant coefficients reflect gaussian noise, while large coefficients represent infrequent (sparse) signals with an unknown distribution
- **Modern Compatibility**: Fortran code has been updated over the years and may now be compiled with gfortran on Linux, with an Octave/Matlab-compatible wrapper file provided

The work was originally tested on the problem of oblique rotation in factor analysis, but is broader in its mathematical formulation and original test applications.  It arose out of the author's quest in the late 1960s for an algorithmically and mathematically tractable Occam's Razor.  Due to siloing, publication in psychometrics journals, and the most relevant fields not existing until decades after the material was published, the work became a so-called "sleeping beauty".  It was partially awakened by R. Jennrich (2004) who remarked that it was a "break through" that was mostly ignored for 30 years.  He went on to prove that even a simpler implementation of the method is guaranteed to recover perfect simple structure (sparsity) if it exists in the data, a rather strong conclusion from a famous mathematician. He missed the geometry because he did not read my second paper.  Ironically, his own paper went on to become another sleeping beauty.

I have posted the full mathematical development of the model (only parts of which appeared in the original publication), along with an origin story, on GitHub.  It can be found in the markdown subdirectory in this repository.  At some point soon, I will also place on GitHub several examples of how it may be used from within gnu Octave, along with several datasets, including those from my recent work in Raman spectroscopy.  The examples will include instructions, as well as heavily-commented Octave/Matlab code.  I am trying to re-awaken this work that today seems more relevant than I ever imagined it would be.

## Repository Structure

```
Functionplane-soft-sparsity-via-C-inf-functions-with-no-basis-collapse/
├── README.md                           # This file
├── code/                               # Fortran source (1970s, updated) + Octave/Matlab wrappers
│   ├── [Fortran .for files]
│   └── [Octave/Matlab .m wrapper files]
├── markdown/                           # Documentation
│   ├── PPFP_JK_PUB01.md                # Deep mathematics underlying the algorithm
│   └── [additional documents to be added]
├── citations/                          # Metadata, references, and journal articles
│   ├── CITATIONS.md                    # Formatted citations
│   └── [bibliography files]
└── zenodo/                             # Links and metadata for Zenodo records
    └── ZENODO_LINKS.md                 # DOI links and external references
```

## Building and Using the Code

### Compilation (Linux with gfortran)

```bash
cd code
gfortran -O3 -std=legacy -fdefault-real-8 -fdefault-double-8 rotatem_real8.for -o rotatem_real8
```

### Usage with Octave/Matlab

Load the wrapper files (`.m` files) found in the `code/` directory:

```octave
% In Octave/Matlab
addpath('code/')
% Call rotfac as you would any Octave function
```

## Key References

### Original Publications (1970s)

[Katz, J. O., & Rohlf, F. J. (1974). Functionplane—A new approach to simple structure rotation. Psychometrika, 39(1), 37–51.](https://doi.org/10.1007/BF02291576)

[Katz, J. O., & Rohlf, F. J. (1975). Primary product functionplane: An oblique rotation to simple structure. Multivariate Behavioral Research, 10(2), 219–231.](https://doi.org/10.1207/s15327906mbr1002_7)

## Zenodo Records

<a href="https://doi.org/10.5281/zenodo.21929585">
<img src="https://zenodo.org/badge/DOI/10.5281/zenodo.21929585.svg"></a>

Katz, J. O. (2026). Primary Product Functionplane and Other Factor Rotations
[https://doi.org/10.5281/zenodo.21929585](https://doi.org/10.5281/zenodo.21929585)

<a href="https://doi.org/10.5281/zenodo.22179765">
<img src="https://zenodo.org/badge/DOI/10.5281/zenodo.22179765.svg"></a>

Katz, J. O. (2026). Primary Product Functionplane: The Mathematical Foundations and its Origins
[https://doi.org/10.5281/zenodo.22179765](https://doi.org/10.5281/zenodo.22179765)

### Author Information
Jeffrey Owen Katz, Ph.D.  (AKA drkatzmaths)
[ORCID ](https://orcid.org/0009-0001-2777-6306)

[![ORCID](https://img.shields.io/badge/ORCID-0009--0001--2777--6306-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0001-2777-6306)

## Technical Summary

**Algorithm**: Primary Product Functionplane & Rotations (1973)
- Soft sparsity (simple structure) via $C\infty$ component loss functions (no $\mathcal{L}_0$ or $\mathcal{L}_1$ kludges or workarounds, not brittle, very robust to noise)
- Implements an approximate maximum likelihood estimator for optimal soft sparsity under the assumption that the small contravariant elements (noise) are roughly Gaussian and that large coefficients (signal) have an unknown distribution
- Gradient optimization with flow between contravariant and covariant components
- No need for externally imposed constraints: the metric endogenously provides adaptive resistance to excessive obliquity and basis collapse (singularity) which is avoided via a "white hole" repulsion mechanism
- Metric and its inverse elegantly avoid basis collapse without requiring any user-set parameters or external constraints
- Predates modern ML and the recent movement to use natively smooth functions to induce soft sparsity by decades
- Uses a redescending M-estimator embedded on a manifold as a target of optimization
- Originally programmed circa 1973 in Fortran on an IBM 360 and demonstrated working
- Included in NT-SYS (Numerical Taxonomy Systems Package)
- Described by Dr. Katz as the result of his quest to build a mathematically and algorithmically tractable Occam's Razor engine
- A "sleeping beauty" partially "awakened" by R. Jennrich [2004, Rotation to Simple Loadings Using Component Loss Functions: The Orthogonal Case](https://doi.org/10.1007/BF02295943) and [2006, Rotation to Simple Loadings Using Component Loss Functions: The Oblique Case](https://doi.org/10.1007/s11336-003-1136-B), who cites the first Functionplane paper, and explicitly recognizes (in 2004) the fact that it was a "break through" that was mostly ignored for 30 years, but missed the geometry which was only implicit in the second Primary Product Functionplane paper
- R. Jennrich offered a mathematical proof that even a simpler implementation of the method will recover "perfect" simple structure or sparsity if it exists, a very strong finding

Note.  Most of the code, mathematics and theory comes from the originator in 1973, hence the older terminology. Modern fields have independently rediscovered some of the foundational ideas: they use different terminology that essentially expresses many of the same mathematical insights employed by Dr. Katz in Primary Product Functionplane.  In the text here, I used a mix of both modern and old terminology, frequently distinguishing it, e.g., with parentheses.


## Modern Context & Implications

[To be filled in with discussion of how this work relates to contemporary representational learning, smooth sparsity, geometry aware optimization, LLMs, and epistemology]

## Contributing & Editing

This repository is under active curation. Feel free to:
- Suggest improvements to documentation
- Report issues with code compilation or compatibility
- Propose connections to modern research (important: this work was done over half a century ago and is now being independently rediscovered piece by piece or so it seems)
- Partly framed in the language of factor analysis (simplicity, simple structure, oblique bases), and more completely and generally developed in the language of metrics and tensors (all of the mathematics appears in the markdown directory in this repo)

Note: Some material here needs further tweaking by the original inventor (me); some bits above were suggested by GitHub Copilot with a gazillion prompts. It may be occasionally incorrect (I noted this with qualifiers).  The Technical summary was written by the originator of the work (me), with some help from AI when elaborating connections to current developments in ML, AI and statistics (with many steering and corrective prompts).

The original mathematics and the Fortran code (somewhat updated to compile with gfortran and for compatibility with gnu Octave) are posted here and on Zenodo, and have been thoroughly tested.  This material originated exclusively with the inventor (me), mostly circa 1973, without any assistance from AI (humor intended, AI did not exist back then!).  I verified that the mathematics in the published papers (1974, 1975), in my original mathematics, and in the Fortran code are all equivalent, maximizing the identical criterion.  I also tried verifying the equivalence using Hugging Chat to which I fed the raw mathematics in markdown, the 1975 Functionplane paper, and the relevant Fortran functions.  It did a good job, and came to the same conclusion as did I: that these items all were essentially equivalent, maximizing the identical criterion.  I prompted the materials in pairs to avoid overloading the AI.  I must say, that Hugging chat was one of the best AIs I had tried---I was impressed given that most of my experiences with AIs are frustrating.  It did make some errors, but these were mostly correctable with prompting, which was not the case with many other AIs on the Web.

## License

Creative Commons Attribution 4.0 International

---

**Last Updated**: 2026-09-04
**Maintained by**: @drkatzmaths

