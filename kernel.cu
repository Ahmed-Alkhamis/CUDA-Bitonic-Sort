#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define THREADS_PER_BLOCK 512

__global__ void BitonicSort(int *d_data, int step, int stage, int decending) {
	int k = threadIdx.x + blockIdx.x * blockDim.x;
	if ((k % (int)pow(2, step - stage + 1)) < (int)pow(2, step - stage)) {
		int* x = &d_data[k];
		int* y = &d_data[k + (int)pow(2, step - stage)];
		if (((k / (int)pow(2, step)) % 2) == decending) {
			if (*x > *y) {
				int temp = *x;
				*x = *y;
				*y = temp;
			}
		}
		else {
			if (*x < *y) {
				int temp = *y;
				*y = *x;
				*x = temp;
			}
		}
	}
}
bool isItPowerOfTwo(int n) {
	if (n <= 0)
		return false;
	while (n % 2 == 0) {
		n /= 2;
	}
	if (n == 1)
		return true;
	return false;
}
int main(void) {
	int* data , *result;
	int* d_data;
	int nbElmts, paddingNumber = 1, choice, decending, min, max, realNbElmts;
	printf("Enter the number of elements: ");
	scanf("%d", &nbElmts);
	realNbElmts = nbElmts;
	data = (int*)malloc(nbElmts * sizeof(int));
	if (data == NULL) {
		printf("Memory allocation failed!\n");
		return 1;
	}
	printf("Would you like to enter the data mannually or randomly? \n");
	printf("1. mannually\n");
	printf("2. randomly\n");
	printf("Your choice: ");
	scanf("%d", &choice);
	printf("\n");
	while (choice != 1 && choice != 2) {
		printf("Please enter 1 or 2: ");
		printf("1. mannually\n");
		printf("2. randomly\n");
		printf("Your choice: ");
		scanf("%d", &choice);
		printf("\n");
	}
	if (choice == 1) {
		printf("Enter %d integers:\n", nbElmts);
		printf("Elment %d:", 0);
		scanf("%d", &data[0]);
		min = data[0];
		max = data[0];
		for (int i = 1; i < nbElmts; ++i) {
			printf("Elment %d:", i);
			scanf("%d", &data[i]);
			if (data[i] < min)
				min = data[i];
			if (data[i] > max)
				max = data[i];
			printf("\n");
		}
	}
	else {
		data[0] = rand() % 1000;
		min = data[0];
		max = data[0];
		for(int i = 1; i < nbElmts; ++i) {
			data[i] = rand() % 1000;
			if (data[i] < min)
				min = data[i];
			if (data[i] > max)
				max = data[i];
		}
	}
	printf("Would you like it to be in an ascending order or decending? \n");
	printf("0. ascending\n");
	printf("1. decending\n");
	printf("Your choice: ");
	scanf("%d", &decending);
	printf("\n");
	while (decending != 0 && decending != 1) {
		printf("Please enter a vaild number \n");
		printf("0. ascending\n");
		printf("1. decending\n");
		printf("Your choice: ");
		scanf("%d", &decending);
		printf("\n");
	}
	printf("Original: ");
	for (int i = 0; i < nbElmts; i++) {
		printf("%d ", data[i]);
	}
	if (!isItPowerOfTwo(nbElmts)) {
		while (paddingNumber < nbElmts) {
			paddingNumber *= 2;
		}
		int* temp = (int*)realloc(data, paddingNumber * sizeof(int));
		data = temp;
		for (int i = nbElmts; i < paddingNumber; i++) {
			if (decending == 0) {
				data[i] = max;
			}
			else {
				data[i] = min;
			}
		}
		nbElmts = paddingNumber;
		
	}
	int totNbSteps = log2(nbElmts);
	int size = nbElmts * sizeof(int);
	cudaMalloc((void**)&d_data, size);
	result = (int*)malloc(size);
	
	printf("\n");
	cudaMemcpy(d_data, data, size, cudaMemcpyHostToDevice);
	int blocks = (nbElmts + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;
	for(int i = 1; i <= totNbSteps; i++)
		for (int j = 1; j <= i; j++) {
			BitonicSort << <blocks, THREADS_PER_BLOCK >> > (d_data, i, j, decending);
			cudaDeviceSynchronize();
		}
	
	cudaMemcpy(result, d_data, size, cudaMemcpyDeviceToHost);
	if (paddingNumber != 1) {
		int* temp = (int*)realloc(result, realNbElmts * sizeof(int));
		result = temp;
	}
	printf("Sorted:   ");
	for (int i = 0; i < realNbElmts; i++) {
		printf("%d ", result[i]);	
	}
	printf("\n");
	free(data); free(result);
	cudaFree(d_data);
	return 0;
}
