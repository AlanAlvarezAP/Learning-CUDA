#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "../config.h"
typedef unsigned int uint;

const uint Millon = 1 << 20;

__global__ void Sums(uint N, float* first, float* second, float* result) {
	for (uint i = 0;i < N;i++) {
		result[i] = first[i] + second[i];
	}
}

__global__ void Sums_OneBlock(uint N, float* first, float* second, float* result) {
	uint index = threadIdx.x;
	uint stride = blockDim.x;
	for (uint i = index;i < N;i+=stride) {
		result[i] = first[i] + second[i];
	}
}

__global__ void Sums_MultipleBlock(uint N, float* first, float* second, float* result) {
	uint index = (blockIdx.x*blockDim.x) + threadIdx.x;
	uint stride = blockDim.x*gridDim.x;
	for (uint i = index;i < N;i += stride) {
		result[i] = first[i] + second[i];
	}
}

class Basics {
private:
	uint matrixSize;
	float *matrix_A, *matrix_B,*matrix_Result;
public:
	Basics(uint matrixSiz, float* first, float* second, float* result) :matrixSize(matrixSiz),matrix_A(first),matrix_B(second)
	,matrix_Result(result){};

	void Compare_Sums(){
		uint blockSize = 256;
		Timer tiempo;
		tiempo.start_time();
		Sums <<<1,1>>> (matrixSize,matrix_A, matrix_B, matrix_Result);
		cudaDeviceSynchronize();
		tiempo.end_time();
		tiempo.print_diff("Simple");

		tiempo.start_time();
		Sums_OneBlock <<<1, blockSize >>> (matrixSize, matrix_A, matrix_B, matrix_Result);
		cudaDeviceSynchronize();
		tiempo.end_time();
		tiempo.print_diff("One block");
		
		uint numBlocks = (matrixSize + blockSize - 1) / blockSize;
		tiempo.start_time();
		Sums_MultipleBlock <<<numBlocks, blockSize >> > (matrixSize, matrix_A, matrix_B, matrix_Result);
		cudaDeviceSynchronize();
		tiempo.end_time();
		tiempo.print_diff("Multiple blocks");
	}
};
