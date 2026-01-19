## Hodge Decomposition of Brain Networks

The Hodge-decomposition is explained in Anand, D.V., El-Yaagoubi, A.B., Ombao, H., Chung, M.K. 2025 [Hodge decomposition of functional brain networks](https://arxiv.org/pdf/2211.10542), arXiv:2211.10542. The paper provides extensive validation and comparisions. Run  SIMULATION hodgedecompose.m to duplicate the simulations in the paper.

Shorter proof-of-concept conference paper is available:
Anand, D.V., Chung, M.K. 2024 [Hodge decomposition of brain networks](https://github.com/laplcebeltrami/hodge/blob/main/anand.2024.ISBI.pdf), ISBI. This is the first paper on the Hodge decomposion for brain networks in literature. Poster version is available [here](https://github.com/laplcebeltrami/hodge/blob/main/anand.2024.ISBI.poster.pdf). The script [Example-HodgeDecomposition.m](https://github.com/laplcebeltrami/hodge/blob/main/Example-HodgeDecomposition.m) explains how to perform the Hodge Decomposition of a given connectivity matrix. 

(C) 2024 Vijay D. Anand,Chung, M.K.
University of Wisconsin-Madison


## Hodge Laplacian of Brain Networks

The code performs the Hodge Laplacian based modeling of cycles in brain networks. 
The code also performs various Hodge Laplacian based computations.

References:

Hanyang Ruan, Moo K. Chung, Willem B. Bruin, Nadza Dzinalija, ENIGMA OCD Working Group, Guido van Wingen, Paul M. Thompson, Dan J. Stein, Odile A. van den, Heuvel, Kathrin Koch, 2026 [Disrupted Higher-Order Topology in OCD Brain Networks Revealed by Hodge Laplacian – an ENIGMA Study](https://github.com/laplcebeltrami/hodge/blob/main/OHBM_2026_ENIGMA-OCD.pdf), OHBM absctract

Anand and Chung 2023 [Hodge Laplacian of Brain Networks](https://github.com/laplcebeltrami/hodge/blob/main/anand.2023.pdf), IEEE Transactions on Medical Imaging 42:1563-1573. The script [EXAMPLE.hodgelaplacian.m](https://github.com/laplcebeltrami/hodge/blob/main/EXAMPLE.hodgelaplacian.m) explains how to compute the eigenvectors of the Hodge Laplacin using Figure 2 example given in the paper. The script [SIMULATION_Anand.2022.TMI.m](https://github.com/laplcebeltrami/hodge/blob/main/SIMULATION_Anand.2022.TMI.m) performs the simulation study given in the Validation section of the paper. 

A shorter MICCAI confernce version of the paper is published in 
Darkurah, S., Anand, D.V., Chen, Z., Chung, M.K., 2022 [Modelling cycles in brain networks with the hodge Laplacian](https://github.com/laplcebeltrami/hodge/blob/main/dakurah.2022.MICCAI.pdf), MICCAI, LNCS 13431:326-355, which received the travel award as one of the best papers in the conference. The script [SIMULATION_Dakurah.2022.MICCAI.m](https://github.com/laplcebeltrami/hodge/blob/main/SIMULATION_Dakurah.2022.MICCAI.m) reproduces the simulation study done in the MICCAI paper.

(C) 2022 Vijay D. Anand, Dakurah, S., Chen, Z., Chung, M.K.
University of Wisconsin-Madison



