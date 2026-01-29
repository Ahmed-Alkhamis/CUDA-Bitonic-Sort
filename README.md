CUDA Bitonic Sort

A high-performance parallel implementation of the Bitonic Sort algorithm using NVIDIA CUDA. This program sorts integers on the GPU and includes a mechanism to handle arbitrary array sizes by automatically padding data to the nearest power of two.

Overview

Bitonic sort is a comparison-based sorting algorithm that focuses on converting a random sequence of numbers into a bitonic sequence (one that monotonically increases then decreases), which is then merged to produce a sorted 
sequence.
Because Bitonic sort relies on a butterfly network of comparisons, it is highly parallelizable, making it ideal for GPU architectures.

Key Features

-Parallel Execution: Offloads sorting comparisons to the GPU using CUDA kernels.

-Dynamic Padding: Automatically handles input sizes that are not powers of two by padding with sentinel values.

-Flexible Input:Manual entry of integers.

-Random generation of data.

-Sorting Direction: Supports both Ascending and Descending orders.
