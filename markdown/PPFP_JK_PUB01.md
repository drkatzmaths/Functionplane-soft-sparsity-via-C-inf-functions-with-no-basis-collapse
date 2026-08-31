---
title: "Primary Product Functionplane: The Mathematical Foundations and its Origins"
author: "Jeffrey Owen Katz, Ph.D."
orcid: "0009-0001-2777-6306"
date: "2026-06-26"
date-original: "1972-1975"
related_identifiers:
  - identifier: "10.5281/zenodo.21929585"
    relation: "isSupplementTo"
    scheme: "doi"
keywords: ["soft sparsity", "simplicity", "metric tensor", "differential geometry", "covariant", "contravariant", "manifold", "dual space", "approximate maximum likelihood estimator", "Occam's Razor", "IBM 360", "NT-SYS", "Fortran", "optimization", "smooth sparsity", "infinitely differentiable", "component loss functions", "gradient", "basis collapse", "collinearity", "variance inflation", "simple structure", "factor analysis", "oblique rotation", "redescending M-estimator", "general relativity", "epistemology" ]
abstract: |
  Primary Product Functionplane was the name given to a method for discovering simplicity [akin to *soft sparsity*] using an infinitely differentiable criterion function [a *component loss function*] together with geometry to make it adaptively averse to excessive collinearity or basis collapse without requiring user-tweaked *constraint parameters*. The method discovers the basis that maximizes the likelihood of the noise under a Gaussian model; signals, lying in the redescending tail, are left unconstrained. Simplicity [soft sparsity] and S/N follow as consequences. The system requires no user-specified *structural* regularization constraints, relying instead on the geometry and a single user-specified parameter defined strictly by the physical bandwidth of the noise floor (not affecting the geometric structure itself). The conceptual framework emerged from a quest to find a tractable Occam's Razor for complex multivariate data spaces.  During its development in the early 1970s, the method was tested to see how well it solved the oblique simple structure rotation problem in factor analysis. Note that here, and in all that follows, the author uses brackets to identify modern terminological mappings, recent notes and added material.
  The method, originally implemented in IBM 360 Fortran, was novel in 1973 in that:  
  1) It employed an infinitely differentiable intrinsically smooth criterion for simplicity [essentially *soft sparsity*], rather than a discontinuous or not everywhere differentiable criterion, such as one based on hyperplane counts or absolute values [in modern terminology, an $\mathcal{L}\_0$ or $\mathcal{L}\_1$ model], or a smoothed more tractable "kludge" thereof;
  2) It avoided excessive collinearity or basis collapse by utilizing a covariant metric tensor ($g_{\nu\lambda}$) and its contravariant inverse ($g^{\nu\lambda}$) to provide a fully adaptive, endogenous geometric control of collinearity without the need for user-adjusted parameters [in modern terminology, *hyperparameters*] for this purpose. The single parameter that did require user input was a noise bandwidth, which has a real physical meaning;
  3) It was highly robust to observational noise;
  4) It yielded an *approximate* Maximum Likelihood Estimation (MLE) [akin to what later became known as a *redescending M-estimator*] for simplicity [soft sparsity] under the assumption that small coefficients (noise) were roughly Gaussian, while large coefficients represented the true but relatively few [*sparse*] signals with an unknown distribution;
  5) It intrinsically accounted for the variance inflation (VIF) that occurs with increased basis collinearity; and
  6) It utilized gradient ascent with a simple self-adapting step size [essentially a *learning rate*] to maximize the optimization criterion.  
  In the early 1970s, as far as I know, no other method of self-regulated "parsimonious hidden pattern" [*sparse latent structure*] discovery or simple structure factor rotation that involved an oblique basis possessed these foundational elements.
  As will be seen, the underlying conceptual framework extends beyond historical data reduction and psychometrics: it arose from a compulsion to develop a mathematically and algorithmically tractable Occam's Razor, a compulsion that led to an intrinsic geometric governor and criterion function capable of recovering fundamental, hidden truths obscured by complexity and noise within large multivariate observation spaces.  [In modern terms, this may have been an early geometrically adaptive unsupervised soft-sparsity-inducing basis-discovery engine without user-specified regularization parameters beyond a single parameter for noise bandwidth].
  What follows in this document are: 1) the foundational matrix and tensor mathematics that underlie Primary Product Functionplane; 2) the method's adaptive geometric, optimization and statistical characteristics; 3) the historical development narrative (origin story); and 4) citations of earlier work, the original papers (with Rohlf), and work by others that built upon what appeared in the original Functionplane papers.
header-includes:
  - \usepackage{fontspec}
---

# Primary Product Functionplane: The Mathematical Foundations and its Origins

**Author:** Jeffrey Owen Katz, Ph.D.  
**Date:** 2026-06-26  
**Contact:** [katz@scientific-consultants.com](mailto:katz@scientific-consultants.com)  


## Abstract

Primary Product Functionplane was the name given to a method for discovering structural simplicity [akin to *soft sparsity*] using an infinitely differentiable criterion function [a *component loss function*] together with geometry to make it adaptively averse to excessive collinearity or basis collapse without requiring user-tweaked constraint parameters. The method discovers the basis that maximizes the likelihood of the noise under a Gaussian model; signals, lying in the redescending tail, are left unconstrained. Simplicity [soft sparsity] and S/N follow as consequences. The system required no user-specified *structural* regularization constraints, relying instead on the geometry and a single user-set parameter defined strictly by the physical bandwidth of the noise floor (not controlling the geometric structure itself). The conceptual framework emerged from a quest to find a tractable Occam's Razor for complex multivariate data spaces.  During its development in the early 1970s, the method was tested to see how well it handled the oblique simple structure rotation problem in factor analysis.  Note that here, and in what follows, brackets are used to identify modern terminological mappings, recent notes, and other added material.

The method, originally implemented in IBM 360 Fortran, was novel in 1973 in that:  

1) It employed an infinitely differentiable intrinsically smooth criterion for simplicity [*soft sparsity*], rather than a discontinuous or not everywhere differentiable criterion, such as one based on hyperplane counts or absolute values [in modern terminology, an $\mathcal{L}\_0$ or $\mathcal{L}\_1$ model] or a smoothed, more tractable "kludge" thereof;  
2) It avoided excessive collinearity or basis collapse by utilizing a covariant metric tensor ($g_{\nu\lambda}$) and its contravariant inverse ($g^{\nu\lambda}$) to provide a fully adaptive, endogenous geometric control of collinearity without the need for user-adjusted parameters [in modern terminology, *hyperparameters*] for this purpose.  The single parameter that did require user input was a noise bandwidth, which has a real physical meaning;     
3) It was highly robust to observational noise;  
4) It yielded an *approximate* Maximum Likelihood Estimation (MLE) [akin to what eventually came to be known as a *redescending M-estimator*] for simplicity under the assumption that small coefficients (noise) were roughly Gaussian, while large coefficients represented the true but relatively few [sparse] signals with an unknown distribution;  
5) It intrinsically accounted for the variance inflation (VIF) that occurs with increased basis collinearity; and  
6) It utilized gradient ascent with a simple self-adapting step size [akin to a *learning rate*] to maximize the optimization criterion.  

In the early 1970s, as far as I know, no other method of geometrically self-regulated "parsimonious hidden pattern" [*sparse latent structure*] discovery or simple structure factor rotation that involved an oblique basis possessed these foundational elements.

It will be seen that the underlying conceptual framework extends beyond historical data reduction and psychometrics: it arose from a compulsion to develop a mathematically and algorithmically tractable Occam's Razor, a compulsion that led to an intrinsic geometric governor and criterion function capable of recovering fundamental, hidden patterns obscured by complexity and noise within large multivariate observation spaces.  [In modern terms, this may have been an early geometrically adaptive unsupervised soft-sparsity-inducing basis-discovery engine without the need for user-specified regularization parameters beyond the single parameter required to set the noise bandwidth].

What follows in this document are: 1) the foundational matrix and tensor mathematics that underlie Primary Product Functionplane; 2) the method's adaptive geometric, optimization and statistical characteristics; 3) the historical development narrative (origin story); and 4) citations of earlier work, the original papers (with Rohlf), and work by others that built upon what appeared in the original Functionplane papers.

---

## Introduction

**First:** the mathematical notation herein derives directly from my original work in the early 1970s. However, mathematical notation and terminology has apparently undergone significant change since then and differs across domains.  In addition, I have "borrowed" conventions from several fields that existed at the time simply because they worked for what I was trying to accomplish. This can (and will) cause confusion for modern readers (including LLMs) in 2026. Hence the following preface to the mathematics:

1) I used $\mathbf{T'}$ to denote the transpose of $\mathbf{T}$, and $\mathbf{T'}^{-1}$ to denote the inverse of the transpose of $\mathbf{T}$. I consistently used $\mathbf{^\prime}$ for the simple transpose in this document. I suspect modern convention would be to employ a superscript (e.g., $\mathbf{T}^T$).  
2) Do not assume that T is symmetric or orthonormal: it is not! Do assume that the columns are unit length basis vectors.  
3) The way I used Einstein summation in the tensor formulation may also confound those working in machine learning (ML) and other fields today.  It should be noted that I did not employ Einstein summation consistently: some equations warranted explicit use of indices.  
4) For gradients, I used the classic unambiguous style: e.g., $\frac{\partial C}{\partial\mathbf{T}}$. I am uncertain as to whether this notation has changed, or differs from field to field, but given the confusion generated by my notation, I thought it best to mention it.  
5) My convention regarding rows and columns apparently also differs in many cases from the conventions used today, and may even differ from discipline to discipline.  So take note that in the matrix formulation:  a) the $m$ columns of $\mathbf{A}$ are associated with the $m$ singular values or eigenvalues and the rows with the $n$ data vectors; b) $\mathbf{A}$ is of full rank; c) the $m$ columns of $\mathbf{T}$ are the new basis vectors; and d) the other matrices are consistent with this by necessity.  
6) Being derived from an SVD or eigenvector decomposition, $\mathbf{A}$ is expressed relative to an orthonormal basis, and $\mathbf{A'A}$ is diagonal, but not the identity matrix. Because the ambient basis is orthonormal, the metric there is the identity---covariant and contravariant components coincide in that frame---so $\mathbf{A}$ may be paired with a metric or its inverse as required, and treated as covariant or contravariant depending on context.  $\mathbf{A}$ is also assumed to be non-degenerate, of full rank.  
7) The formulation involving $\mathbf{A}$ and $\mathbf{T}$ operates in a general oblique coordinate system. The basis vectors (columns of $\mathbf{T}$) are normalized (unit length) but not orthogonal. Therefore, the covariant components ($\mathbf{S}=\mathbf{AT}$, representing projections) and contravariant components ($\mathbf{P}=\mathbf{A{T'}^{-1}}$, representing linear coordinates) are distinct and related by the metric of the basis ($\mathbf{T'T}$), unlike in orthonormal systems where they coincide.  
8) Finally note that the tensor formulation is also consistent with all the conventions mentioned above and with the matrix formulation, just more general.  

I mostly retained my original notation in order to preserve historical accuracy and provide a "ground truth", as well as for consistency with my papers, Fortran code, and notes from that era.

The need for the preface became apparent during recent pre-publication testing, when I had  several modern AIs examine the text and the mathematics. The result was a series of blatant errors from the models that resisted repeated corrective prompts. It eventually became clear that these errors---stated with complete confidence---stemmed not from real issues with the mathematics, but rather from the LLMs becoming confounded by my notational and other conventions which are apparently unusual in modern disciplines (such as machine learning, sparse representation, and statistics) and in the AI's training corpora.  The fact that several advanced LLMs faltered when examining the mathematics gave me pause: If the AIs went astray to such an extent, modern human readers working in contemporary fields would likely encounter the exact same trouble. Consequently, I added the "preface to the mathematics" as an essential guide, a "prophylactic" against misinterpretation and confusion.

Once my notational patterns were prompted and established upfront, some LLMs praised the underlying matrix and tensor mathematics as elegant and rigorous (some serious sycophancy, yes?), but they mostly continued to generate incorrect responses when prompted to analyze an equation or to generate an explicit gradient using the chain rule! I had confidence that my mathematical formulations were correct, however, independent of any LLMs or human readers: the Fortran program based on those formulations converges smoothly, optimizes the criterion central to the model, and has done so for over 50 years---even with single-precision floating point on an IBM 360.  But, after witnessing the persistent errors made by LLMs when asked to derive the gradient, I felt the need to re-verify the old equations myself just in case I had made some kind of error. I thus wrote a small test script in Octave: it numerically confirmed that my original equations for the gradient were indeed correct, and that the AIs (not my mathematics) were the problem!


**Second:** Although I developed this in the early 70s, it seems to be more relevant today than at any time previously. As already noted, the underlying mathematics arose from a persistent effort to develop a tractable Occam's Razor: an algorithm that could, without subjective human intervention, find the "arcane yet parsimonious truth" hidden within complex multivariate observation spaces.  To place this in context, I have included a discussion on the origins and development of the mathematics as well as the Fortran implementation near the end of this document.

---

Let me begin abstractly, with just the mathematics.

## Matrix Formulation

Let $\mathbf{A}$ be a $n$ by $m$ matrix, with $n > m$, such as might result from a singular value or eigenvector decomposition, perhaps with rescaled columns.  Assume that $\mathbf{A}$ expresses the data vectors in terms of an ambient orthonormal basis, that $\mathbf{A}$ is of full rank, and that $\mathbf{A'A}$ is diagonal but not necessarily the identity matrix.  Assume that the rows of $\mathbf{A}$ are data vectors and the columns eigenvectors.  Finally, assume that $\mathbf{T}$ has unit length columns and that $\mathbf{T}$ is not symmetric.

Let $\mathbf{S}$ and $\mathbf{P}$ be $n$ by $m$ matrices.
Let $\mathbf{T}$ and $\mathbf{\Phi}$ be $m$ by $m$ matrices.

Now let

$$ \mathbf{S} = \mathbf{A} \mathbf{T} $$

$$ \mathbf{P} = \mathbf{A} \mathbf{T'}^{-1} $$

with

$$ \mathbf{\Phi} = \mathbf{T'} \mathbf{T} $$

$$ \mathbf{S} = \mathbf{P} \mathbf{\Phi} $$

$$ \mathbf{P} = \mathbf{S} \mathbf{\Phi}^{-1} $$

Finally, define the scalar $C$, a naturally smooth measure of simplicity [today I would refer to $C$ as an infinitely differentiable measure of *soft sparsity*]

$$C = \sum_{i,j} \exp \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right] = \sum_{i,j} \exp \left[ -\left( \frac{(\mathbf{A}\mathbf{T'}^{-1})_{ij}}{w} \right)^2 \right]$$

This defines a simplicity criteria in the form of an optimization surface on which gradient ascent (or gradient descent, with some small changes to the equations) may be used. Given the above, it can be seen that the gradient is simply

$$\nabla_{\mathbf{T}} C = \frac{\partial}{\partial \mathbf{T}} \sum_{i,j} \exp  \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right] = \frac{\partial}{\partial \mathbf{T}} \sum_{i,j} \exp \left[ -\left(\frac{(\mathbf{A} \mathbf{T'}^{-1})_{ij}}{w}\right)^2 \right]$$

If we define the matrix $\mathbf{F}$ element wise by

$$
\mathbf{F}_{ij} = \mathbf{P}_{ij} \text{ } \exp  \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right]
$$

And $\mathbf{\Psi}$ as

$$\mathbf{\Psi}=\mathbf{T}'^{-1}$$

the explicit gradient $\nabla_{\mathbf{T}} C$ becomes

$$
\nabla_{\mathbf{T}} C=\frac{2}{w^2}\mathbf{\Psi F' P} 
$$

Now consider some additional matrices.

$$\mathbf{D}_{jj}=\left[\left( \mathbf{\Psi}'\mathbf{\Psi} \right)_{jj} \right]^{-1/2} = \left[ {(\mathbf{\Phi}^{-1})}_{jj} \right]^{-1/2}$$

and

$$\mathbf{R}=\mathbf{A}\mathbf{\Psi}\mathbf{D}$$

where $\mathbf{D}$ is a diagonal matrix whose elements are closely related to the *Variance Inflation Factors* found in multiple regression theory.

$\mathbf{\Psi}$, $\mathbf{D}$, and $\mathbf{R}$ become relevant in later discussions, and when looking at the original Fortran implementation of the optimization implied by the mathematics.  


## Tensors and Metrics Formulation

The reader may have noticed the implicit geometry being expressed in the matrix equations shown above, and may even have suspected an underlying scheme involving covariant and contravariant representations, that is, dual spaces. He or she would have been correct.  A clear tell is the presence of an inverse of the transformation in the equation for the criterion.

Let the indices be defined as follows:
- Matrix/Data Vector indices: $i\in\{1,\dots,n\}$
- Basis/Component indices in the ambient orthonormal basis: $\mu\in\{1,\dots,m\}$
- Basis/Component indices in the new oblique basis: $\nu,\lambda,\rho\in\{1,\dots,m\}$

Note: Since $\mu$ indexes an ambient orthonormal basis, $\delta_{\mu\gamma}$ is its metric; consequently $\mu$ may be written upper or lower at will, and repeated $\mu$ contractions are valid regardless of the height at which $\mu$ appears on each tensor.

| Matrix Symbol | Tensor Notation | Description |
| :--- | :--- | :--- |
| $\mathbf{A}$ | $A_{i\mu}$ | Data components in the ambient orthonormal basis. |
| $\mathbf{T}$ | $T^\mu_\nu$ | **Basis Transformation**. Columns are the new basis vectors $\mathbf{t}_\nu$. |
| $\mathbf{\Phi}$ | $g_{\nu\lambda}$ | **Covariant Metric Tensor**. Defines inner products in the new basis. |
| $\mathbf{\Phi}^{-1}$ | $g^{\nu\lambda}$ | **Contravariant Metric Tensor** (Inverse Metric). |
| $\mathbf{P}$ | $P_i^\nu$ | **Contravariant Components** of data vectors in the new basis. |
| $\mathbf{S}$ | $S_{i\nu}$ | **Covariant Components** Projections of data vectors. |
| $\mathbf{\Psi}$ | $(T^{-1})^\nu_\mu$ | **Inverse Basis Map** Transformation to dual basis. |

The matrix product $\mathbf{\Phi} = \mathbf{T}'\mathbf{T}$ is essentially a metric tensor that defines the metric of the transformed space:

$$
g_{\nu\lambda} \equiv \Phi_{\nu\lambda} = T^\mu_\nu T^\rho_\lambda \delta_{\mu\rho} = \sum_{\mu=1}^m T^\mu_\nu T^\mu_\lambda
$$

The components that transform with the inverse of the basis matrix ($\mathbf{T}$) are contravariant (upper indices):

$$
P_i^\nu = A_{i\mu} (T^{-1})^\nu_\mu
$$

*Note: In the matrix formulation, this corresponds to* $\mathbf{P} = \mathbf{A}{\mathbf{T}'}^{-1}$.

The components that transform with the basis matrix itself are covariant (lower indices):

$$
S_{i\nu} = A_{i\mu} T^\mu_\nu
$$

*Note: In the matrix formulation, this corresponds to* $\mathbf{S} = \mathbf{A}\mathbf{T}$.

The covariant and contravariant components are related via the metric tensor:

$$
S_{i\nu} = g_{\nu\lambda} P_i^\lambda \quad \text{(Lowering)}
$$

$$
P_i^\nu = g^{\nu\lambda} S_{i\lambda} \quad \text{(Raising)}
$$

The scalar $C$ represents an infinitely differentiable measure of simplicity, interpreted simply as a sum of Gaussians for the contravariant coefficients.  Note that explicit summation is used for the indices $i$ and $\nu$ in the two equations below.

$$
C = \sum_{i=1}^n \sum_{\nu=1}^m \exp \left[ -\left(\frac{P_i^\nu}{w} \right)^2 \right]
$$

Substituting the tensor definition of $P_i^\nu$:

$$
C[\mathbf{T}] = \sum_{i, \nu} \exp \left[ - \left( \frac {A_{i\mu} (T^{-1})^\nu_\mu}{w} \right)^2 \right]
$$

[Recent Author's Note: This gaussian-based criterion was chosen as a natural measure of simplicity, with desirable statistical properties, and not as an approximation intended to make hyperplane counts and absolute values---in modern terminology: $\mathcal{L}\_0$ and $\mathcal{L}\_1$ models---amenable to gradient optimization methods.  It was chosen for its nice statistical and mathematical properties, among them robustness with respect to noise in the data.  In modern terminology, it might be classified as a measure of *soft sparsity*, more precisely as a *smooth, non-convex sparsity measure*. It also turns out that $C[\mathbf{T}]$ is now recognized as a robust *redescending M-estimator*, in this case embedded in a manifold and being the target of optimization.]

The gradient ascent optimization attempts to maximize $C$ with respect to the basis vectors $T^\mu_\nu$. Consequently, the system intrinsically resists basis collapse (singularity of $g_{\nu\lambda}$) because:

1.  As $\det(g) \to 0$, the inverse metric $g^{\nu\lambda}$ diverges.
2.  This causes the contravariant components $P_i^\nu$ to explode in magnitude.
3.  The exponential term $\exp[-(P_i^\nu/w)^2]$ vanishes, driving the objective function $C \to 0$.
4.  Consequently, the gradient $\frac{\partial C}{\partial T^\mu_\nu}$ drives the system away from singularity.  One can imagine singularities in this model as akin to "white holes" that repel geodesics (gradient step paths) thus preventing basis collapse.

Note that the use of a metric with covariant and contravariant spaces in the optimization process is implicit but manifest in the matrix formulation given earlier as well as in the Fortran code provided elsewhere.  All of these optimize the same criterion with identical resistance to basis collapse. 

---

## Some characteristics of the model

The metric tensor ($g_{\nu\lambda}$) encodes the collinearity of the basis. Diagonal elements represent the squared lengths of the basis vectors (in the current context, the basis vectors were constrained to unit length); off-diagonal elements represent cosines of angles between the basis vectors (that is, correlations).

The diagonal elements of the inverse metric, $g^{\nu\nu}$, are directly related to the Variance Inflation Factors (VIFs) found in multiple regression theory.

The algorithm attempts to find a basis $\mathbf{T}$ that maximizes the density of coefficients statistically indistinguishable from Gaussian noise (width $w$) in $\mathbf{P}$, effectively performing an approximate Maximum Likelihood Estimation of simplicity [akin to *soft sparsity*] of structure under a Gaussian noise assumption.

The adaptive aspect resists excessive collinearity selectively, allowing greater expansion in columns of P where simplicity is clear and noise is low, while being more averse to high levels of collinearity along dimensions where simplicity is less clear and the small coefficients in P are not quite so small.  In this sense, the "resistance" to collinearity is fully adaptive for each column of $\mathbf{P}$ in a way that relates directly to $\mathbf{D}$ and hence to Variance Inflation.  The inverse metric $g^{\nu\lambda}$ acts as an adaptive control ("local governor"). The balance between collinearity and orthogonality is not determined by an extrinsic constraint with a user-tweaked parameter, but is intrinsically determined by the criterion function and the geometry.  There are no kludges or fixes that need to be imposed after the fact.

The model is also not very sensitive to the precise value of $w$, the "noise bandwidth", which is the only user-set parameter.  Additionally, this parameter has an actual physical or statistical meaning, and in many cases may be set based on independent measurements (e.g., of baseline sensor or instrument noise).

---

## Modification of the simplicity criterion

During experimentation with the model on problems that involved oblique factor rotation circa 1973, a slightly modified simplicity criterion was found to provide marginally better results than the more basic one shown earlier.  Instead of

$$C = \sum_{j} \sum_{i} \exp \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right]$$

I used

$$C = \sum_{j} log \sum_{i} \exp \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right]$$

where i represents the row index, and j the column index.

This change moved the model a bit closer to a true (but still approximate) maximum likelihood estimation for simplicity under the assumption that small contravariant coefficients in P represent Gaussian noise, while large ones reflect sparse but real signals with an unknown distribution.  It is this slightly modified version that appears in my publications and Fortran code from that era.

The explicit gradient for this modified simplicity criterion is

$$
\nabla_{\mathbf{T}} C=\frac{2}{w^2}\mathbf{\Psi \tilde{F'} P} 
$$

where

$$
\mathbf{\tilde{F}}_{ij} = \frac {\mathbf{P}_{ij} \text{ } \exp \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right]} { \sum_{i} \exp \left[ -\left( \frac{\mathbf{P}_{ij}}{w} \right)^2 \right]}
$$

As can be seen, it is very similar to the gradient displayed earlier for the more basic measure of simplicity.

---

## Gradient projection onto the product of unit spheres

In the early 1970s Fortran implementation, I enforced the unit-length column constraint using a projection of the gradient from the $m \times m$ space of $\mathbf{T}$ to the $(m-1) \times m$ space of the non-pivot elements of $\mathbf{T}$, with the pivots being recomputed from the remaining elements.  Here is exactly how it worked:

The gradient $\nabla_{\mathbf{T}} C$ given above is the $m \times m$ gradient with respect to *all* elements of $\mathbf{T}$. In the Fortran implementation, the chain rule was used to obtain the gradient with respect to the $m-1$ free elements in each column (those that were not the pivots) from the full $m \times m$ gradient.

For each column $j$, let $k_j$ be the index of the pivot, the element of largest absolute value, reselected at each step. The pivot is not an independent variable. Given the remaining $m-1$ free elements and the sign $s_j = \pm 1$ of the current pivot, the pivot is reconstructed as

$$\mathbf{T}_{k_j,\,j} = s_j \sqrt{1 - \sum_{i \neq k_j} \mathbf{T}_{ij}^2}$$

The chain rule then yields, for $i \neq k_j$:

$$\frac{\partial C}{\partial \mathbf{T}_{ij}} = \frac{\partial C}{\partial \mathbf{T}_{ij}} + \frac{\partial C}{\partial \mathbf{T}_{k_j,\,j}} \cdot \frac{\partial \mathbf{T}_{k_j,\,j}}{\partial \mathbf{T}_{ij}}$$

where

$$\frac{\partial \mathbf{T}_{k_j,\,j}}{\partial \mathbf{T}_{ij}} = -\frac{s_j\, \mathbf{T}_{ij}}{\mathbf{T}_{k_j,\,j}}$$

and the two terms on the right are the contributions from the direct dependence of $C$ on $\mathbf{T}_{ij}$ and its indirect dependence through the pivot. The output is an $(m-1) \times m$ array.

The optimization loop is:

1. Select pivots (largest $|\mathbf{T}_{ij}|$ in each column).
2. Compute the $(m-1) \times m$ gradient by the chain rule above.
3. Take a small step in the direction of steepest ascent on the free elements.
4. Recompute the pivots from the updated columns.
5. Perform the entire next step in the optimization

Because the pivots are reconstructed exactly at every step in the optimization loop, the columns of $\mathbf{T}$ are maintained at precisely unit length — no separate renormalization pass is required. The computation is reduced from $m^2$ to $m(m-1)$ gradient evaluations per step, useful on the IBM-360 given no vector processing or extra costs for do-loops.

This product of spheres constraint is geometrically separate from the collinearity regulator encoded in $\mathbf{\Psi}$; the two act on different aspects of the basis, with the product of spheres being used strictly for implementing the optimization process.  [Today, in the age of efficient vectorized processing, I would probably just take a step in the direction of the full $m \times m$ gradient, and then renormalize the columns of T, repeating until convergence].

---

## ORIGIN STORY


**UNDER CONSTRUCTION**

---

## Citations (INCOMPLETE, UNDER CONSTRUCTION)

* **Cattell, R. B., & Muerle, J. L. (1960).** The “maxplane” program for factor rotation to oblique simple structure. *Educational and Psychological Measurement*, 20(3), 269–290. 
  [![DOI](https://shields.io)](https://doi.org)

* **Eber, H. W. (1966).** Toward oblique simple structure: Maxplane. *Multivariate Behavioral Research*, 1(1), 112–125. 
  [![DOI](https://shields.io)](https://doi.org)

* **Katz, J.O., & Rohlf, F.J. (1974).** Functionplane—A new approach to simple structure rotation. *Psychometrika*, 39(1), 37–51. 
  [![DOI](https://shields.io)](https://doi.org/10.1007/BF02291576)

* **Jennrich, R.I. (2004).** Rotation to simple loadings using component loss functions: The orthogonal case. *Psychometrika*, 69(2), 257–273. 
  [![DOI](https://shields.io)](https://doi.org/10.1007/BF02295943)



The original paper on Primary Product Functionplane was co-authored with F. James Rohlf and published in Multivariate Behavioral Research in 1975 (https://doi.org/10.1207/s15327906mbr1002_7).

An earlier version that did not implement the metric, and suffered from basis collapse and excessive collinearity, appeared in Psychometrika in 1974 (https://doi.org/10.1007/BF02291576).

Both the mathematics and the Fortran code was strictly my own work: it pre-dated the collaboration with F. James Rohlf on these papers.

