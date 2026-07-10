# CUDA-Accelerated Conway's Game of Life

A high-performance, hybrid-architecture simulation of Conway's Game of Life. This engine offloads computationally heavy cellular automata updates to thousands of parallel GPU cores via a custom C++/CUDA DLL, utilizing Python and Pygame strictly as a lightweight presentation layer.

##  Key Architectural Features

* **Cross-Language Interoperability:** Implements a flat C-style interface (`extern "C"`) to seamlessly bridge high-level managed memory environments (Python/NumPy) with raw hardware pointers using the `ctypes` library.
* **Parallel Core Mapping:** Maps 2D simulation coordinates directly onto hardware thread groups using CUDA's parallel execution configuration abstractions (`blockIdx`, `threadIdx`).
* **Explicit VRAM Lifecycle Control:** Eliminates CPU-bound bottlenecks by utilizing manual device memory pipelines (`cudaMalloc`, `cudaMemcpy`, and `cudaFree`) to stream grid structures at optimal hardware bus velocities.
* **Pre-Flight Validation Bridge:** Features a structural runtime validation function (`constructor`) to check pointer sanity and protect against Windows TDR (Timeout Detection and Recovery) GPU detachments.




