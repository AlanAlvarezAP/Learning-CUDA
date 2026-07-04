
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include "C++/01-EasyIntro.cuh"

int main(){
    float* x, * y, *result;

    cudaMallocManaged(&x, Millon*sizeof(float));
    cudaMallocManaged(&y, Millon * sizeof(float));
    cudaMallocManaged(&result, Millon * sizeof(float));

    Basics prueba(Millon,x,y,result);
    prueba.Compare_Sums();

    return 0;
}

