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

Interaction Example

The program is interactive. Here is a sample workflow:

Enter the number of elements: 10

Would you like to enter the data mannually or randomly?

1. mannually
   
2. randomly
   
Your choice: 2

Would you like it to be in an ascending order or decending?

0. ascending
   
1. decending

Your choice: 0

Original: 45 12 99 2 8 15 67 33 1 10

Sorted:   1 2 8 10 12 15 33 45 67 99
