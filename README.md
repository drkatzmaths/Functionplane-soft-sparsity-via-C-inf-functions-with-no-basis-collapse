## 1970s Sparse Metric Tensors With Infinitely Differentiable Loss Functions: Representational Learning Engine

# Overview

This repository archives a pioneering representational learning and sparsity engine originally implemented in IBM 360 Fortran in the early 1970s. The original code demonstrates very early work on:

- **Representational Learning**: Possibly the first implementation of learning through representation discovery
- **Sparse Structures & Metric Tensors**: Advanced mathematical treatment of sparsity using dual spaces and a metric
- **Infinitely Differentiable Loss Functions**: Infinitely differentiable loss function (no $\mathcal{L}\_0$ or $\mathcal{L}\_1$ "kludges") used to induce soft sparsity or simplicity
- **Gradient Optimization**: Smooth, differentiable gradient optimization method with a simple adaptive stepsize (learning rate)
- **Adaptive Avoidance of Basis Collapse**: Adaptive intrinsic collinearity control emerging from the geometry without hyperparameters
- **Approximate Maximum Liklihood Estimation**:  Under the assumption that sparse (small) coefficients are gaussian (noise)
- **Modern Compatibility**: Fortran code compiled with gfortran on Linux, with Octave/Matlab-compatible wrapper file.

The work was originally tested on the problem of oblique rotation in factor analysis, but is far broader in its mathematical formulation (which will be posted on GitHub in the near future) and application.  It arose out of the author's quest in the late 1960s for an algorithmically and mathematically tractable Occam's Razor.  Due to siloing, publication in psychometrics journals, and the most relevant fields not existing until decades after the material was published, the work became a so-called "sleeping beauty".  It was partially awakened by R. Jennrich (2004) who remarked that it was a "break through" that was mostly ignored for 30 years.  He went on to prove that even a simpler implementation of the method is guaranteed to recover perfect simple structure (sparsity) if it exists in the data, a rather strong conclusion from a famous mathematician. Ironically, his own paper went on to become another sleeping beauty.

I will be posting the full mathematical development of the model (only parts of which appeared in the original publication), along with its origin story, on GitHub soon.  At some point thereafter, I will also place on GitHub several examples of how it may be used from within gnu Octave, along with several datasets, including those from my recent work in Raman spectroscopy.  The examples will include instructions, as well as heavily-commented Octave/Matlab code.  I am trying to re-awaken this work that is today more relevant than I ever imaged it would be.

## Repository Structure

```
Functionplane-soft-sparsity-via-C-inf-functions-with-no-basis-collapse/
├── README.md                           # This file
├── code/                               # Fortran source (1970s) + Octave/Matlab wrappers
│   ├── [Fortran .f files]
│   └── [Octave/Matlab .m wrapper files]
├── markdown/                           # Contemporary documentation and analysis
│   ├── overview.md                     # High-level introduction
│   ├── technical-analysis.md           # Deep dive into algorithms and concepts
│   ├── modern-context.md               # Connections to LLMs and contemporary AI
│   └── [additional documents]
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
gfortran -O2 --std=legacy -o rotatem rotatem.for
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

<a href="https://doi.org/10.5281/zenodo.20391031">
<img src="https://zenodo.org/badge/DOI/10.5281/zenodo.20391031.svg"></a>

Katz, J. O. (2026). Primary Product Functionplane and Other Factor Rotations
[https://doi.org/10.5281/zenodo.20391031](https://doi.org/10.5281/zenodo.20391031)

### Author Information
[ORCID ](https://orcid.org/0009-0001-2777-6306)

[![ORCID](https://img.shields.io/badge/ORCID-0009--0001--2777--6306-A6CE39?logo=orcid&logoColor=white)](https://orcid.org/0009-0001-2777-6306)

## Technical Summary

**Algorithm**: Primary Product Functionplane & Rotations (1973)
- Soft sparsity (simple structure) via $C\infty$ component loss functions (no $\mathcal{L}_0$ or $\mathcal{L}_1$ kludges or workarounds, not brittle, very robust to noise)
- Implements an approximate MLE for optimal soft sparsity under the assumption that the small elements (noise) are roughly gaussian
- Gradient optimization with flow between contravariant and covariant components
- No need for external constraints: the metric endogenously provides adaptive resistance to excessive obliquity and basis collapse (singularity)
- Metric and its inverse elegantly avoid basis collapse without requiring any user-set parameters or external constraints
- Predates modern representational learning and the recent movement to use natively smooth functions to induce sparsity by decades
- Programmed in 1973 in Fortran on an IBM 360 and demonstrated working
- Described by Dr. Katz as the result of his quest to build a mathematically and algorithmically "tractable Occam's Razor"
- A "sleeping beauty" partially "awakened" by R. Jennrich [2004, Rotation to Simple Loadings Using Component Loss Functions: The Orthogonal Case](https://doi.org/10.1007/BF02295943) and [2006, Rotation to Simple Loadings Using Component Loss Functions: The Oblique Case](https://doi.org/10.1007/s11336-003-1136-B), who cites the original work, and explicity recognizes (in 2004) the fact that it was a "break through" that was mostly ignored for 3 decades
- R. Jennrich offered a mathematical proof that even a simpler implementation of the method will recover "perfect" simple structure or sparsity if it exists, a very strong finding

Note.  Most of the code and maths come from the originator in 1973, hence the older terminology; the modern fields that have independently rediscovered some of the foundational ideas use different terminology that essential expresses the same mathematical insights as used by Dr. Katz in Primary Product Functionplane.


## Modern Context & Implications

[To be filled in with discussion of how this work relates to contemporary representational learning, smooth sparsity, geometry aware optimization, LLMs, and epistemology]

## Contributing & Editing

This repository is under active curation. Feel free to:
- Suggest improvements to documentation
- Report issues with code compilation or compatibility
- Propose connections to modern research (important: this work was done half a century ago and is now being independently rediscovered piece by piece
- Partly framed in the language of factor analysis (matrices, simple structure), and more completely and generally developed in the language of metrics and tensors (to be posted on GutHub)

Note: Some material here needs further tweaking by the original inventor (me); some bits above were suggested by GitHub Copilot with a gazillion prompts. It may be occasionally incorrect.  The Technical summary was written by originator of the work (me), with some help from AI when elaborating connections to current developments (with many steering and corrective prompts).

The original maths (soon to be posted) and the Fortran code (somewhat updated to compile with gfortran and for comaptibility with gnu Octave, already posted here and on Zenodo) are thoroughly tested and correct, and originated with the inventor (me) mostly circa 1973, without any assistance from AI (humor intended).  I verified that the mathematics in the published papers (1974, 1975), in my original maths, and in the Fortran code are all equivalent, maximizing the identical criterion.  I also tried verifying the equivalence using Hugging Chat to which I fed the raw mathematics in markdown, the 1975 Functionplane paper, and the relevant Fortran functions.  It did an impressive job, and came to the same conclusion as did I: that these items all were essentially equivalent, maximizing the identical criterion.  I fed the materials in pairs to avoid overloading the AI.  I must say, that Hugging chat was one of the best AIs I ever tried--I was quite impressed given that most of my experiences with AI are usually frustrating and not that impressive.

## License

Creative Commons Attribution 4.0 International

---

**Last Updated**: 26 June 2026
**Maintained by**: @drkatzmaths
