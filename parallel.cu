
#include "cuda_runtime.h"
#include "cuda_runtime_api.h"
#include "device_launch_parameters.h"

#include <stdio.h>      
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include<stdio.h>

#define COUNT 7
#define ROWS 12

struct returnObject{
	int omega[COUNT];
	int o[COUNT];
};

struct vertex{
	int x, y;
};


__device__ int findQueueSize(){
	return 0;
}

int findQueueSiz(){
	return 0;
}
struct returnObject *globalQueue;
__device__ void enqueue(struct returnObject *globalQueue, int *omega, int *o){
	int i;
	for (i = 0; i<COUNT; i++){
		globalQueue[findQueueSize()].omega[i] = omega[i];
		globalQueue[findQueueSize()].o[i] = o[i];
	}
}


__device__ int findSize(int a[]){
	int i = 0;
	int counter = 0;
	for (i = 0; i<COUNT; i++)
	if (a[i] == 1)
		counter++;
	return (counter);
}

__device__ int findGraph(struct vertex *a){
	//int i=0;
	//while(i<ROWS && a[i++][0]!=-1);
	return COUNT;
}

__device__ int lastBit(int a[]){
	int i;
	for (i = 0; i<COUNT; i++)
	if (a[i] == -1)
		return i;
	return i;
}

__device__ int firstSetBit(int a[]){
	int i;
	for (i = 0; i<COUNT; i++)
	if (a[i] == 1)
		return i;
	return i;
}


__device__ struct returnObject *colourise(struct vertex *graph, int* adjacentVertices){
	struct returnObject *returnobject = (returnObject *)malloc(sizeof(struct returnObject));
	int i;
	for (i = 0; i<COUNT; i++){
		returnobject->omega[i] = -1;
		returnobject->o[i] = -1;
	}
	int pDash[COUNT];
	int j = 0;
	for (i = 0; i<COUNT; i++){
		pDash[i] = adjacentVertices[i];
	}
	int om = 0;
	while (findSize(pDash)>0){
		om++;
		int q[COUNT];
		for (j = 0; j<COUNT; j++){
			q[j] = pDash[j];
		}
		while (findSize(q)>0){
			int v = firstSetBit(q);
			pDash[v] = -1;
			q[v] = -1;
			int neighbours[COUNT];
			for (j = 0; j<COUNT; j++)
				neighbours[j] = -1;
			int graphSize = findGraph(graph);
			for (j = 0; j <= graphSize; j++){
				if (graph[j].x == v){
					neighbours[graph[j].y] = 1;
				}
				else if (graph[j].y == v){
					neighbours[graph[j].x] = 1;
				}
			}
			for (j = 0; j<COUNT; j++)
			if (j != v && (neighbours[j] == 0 || neighbours[j] == -1))
				neighbours[j] = 1;
			else
				neighbours[j] = -1;
			for (j = 0; j<COUNT; j++){
				if (q[j] == neighbours[j] && q[j] == 1)
					q[j] = 1;
				else
					q[j] = -1;
			}
			returnobject->omega[lastBit(returnobject->omega)] = om;
			returnobject->o[lastBit(returnobject->o)] = v;
		}
	}
	return returnobject;
}


__device__ void expand1(struct vertex *graph, int* candidateClique, int* adjacentVertices, int* incumbentVertices,struct returnObject *globalQueue,int populate){
	//	struct returnObject *returnobject1=malloc(sizeof(struct returnObject));
	int i; 
	
	
	struct returnObject *returnobject = (returnObject *)malloc(sizeof(struct returnObject));
	
	for (i = 0; i<COUNT; i++){
		returnobject->omega[i] = -1;
		returnobject->o[i] = -1;
	}
	returnobject = colourise(graph, adjacentVertices);
	//	cudaMemcpy(returnobject,returnobject1,sizeof(returnObject),cudaMemcpyDeviceToDevice);
	int adjacentSize = findSize(adjacentVertices);
	for (i = adjacentSize - 1; i >= 0; i--){
		int candidateSize = findSize(candidateClique);
		int incumbentSize = findSize(incumbentVertices);
		if (candidateSize + returnobject->omega[i]>incumbentSize){
			int v = returnobject->o[i];
			candidateClique[v] = 1;
			int neighbours[10] = { -1 };
			int graphSize = findGraph(graph);
			int j = 0;
			for (j = 0; j <= graphSize; j++){
				if (graph[j].x == v){
					neighbours[graph[j].y] = 1;
				}
				else if (graph[j].y == v){
					neighbours[graph[j].x] = 1;
				}
			}
			int *newAdjacent = (int *)malloc(sizeof(int)*COUNT);
			for (j = 0; j<COUNT; j++)
				newAdjacent[j] = -1;
			for (j = 0; j<COUNT; j++)
			if (adjacentVertices[j] == neighbours[j] && neighbours[j] == 1)
				newAdjacent[j] = 1;
			int newAdjacentSize = findSize(newAdjacent);
			if (newAdjacentSize == 0){
				candidateSize = findSize(candidateClique);
				incumbentSize = findSize(incumbentVertices);
				if (candidateSize>incumbentSize){
					for (j = 0; j<COUNT; j++){
						incumbentVertices[j] = candidateClique[j];
					}
				}
			}
			else{
				if (populate == 1)
					enqueue(globalQueue, candidateClique, newAdjacent);
				else
					expand1(graph, candidateClique, newAdjacent, incumbentVertices,globalQueue,populate);
			}
			candidateClique[v] = -1;
			adjacentVertices[v] = -1;
		}
	}
}


int globalIncumbent[10][10] = { -1 };
int globalCounter = 0;

void newGlobal(int a[]){
	int i, j;
	globalCounter = 0;
	for (i = 0; i<COUNT; i++)
	for (j = 0; j<COUNT; j++)
		globalIncumbent[i][j] = -1;
	for (i = 0; i<COUNT; i++)
		globalIncumbent[globalCounter][i] = a[i];
	globalCounter++;
}

void appendGlobal(int a[]){
	int i;
	for (i = 0; i<COUNT; i++)
		globalIncumbent[globalCounter][i] = a[i];
	globalCounter++;
}

int findSize1(int a[]){
	int i = 0;
	int counter = 0;
	for (i = 0; i<COUNT; i++)
	if (a[i] == 1)
		counter++;
	return (counter);
}

int findGraph1(int a[10][2]){
	int i = 0;
	while (i<COUNT && a[i++][0] != -1);
	return i - 1;
}

int lastBit1(int a[]){
	int i;
	for (i = 0; i<COUNT; i++)
	if (a[i] == -1)
		return i;
}

int firstSetBit1(int a[]){
	int i;
	for (i = 0; i<COUNT; i++)
	if (a[i] == 1)
		return i;
}
struct returnObject *colourise(int graph[10][2], int* adjacentVertices){
	struct returnObject *returnobject =(struct returnObject*) malloc(sizeof(struct returnObject));
	int i;
	for (i = 0; i<COUNT; i++){
		returnobject->omega[i] = -1;
		returnobject->o[i] = -1;
	}
	int pDash[10] = { -1 };
	int j = 0, k = 0;
	for (i = 0; i<COUNT; i++){
		pDash[i] = adjacentVertices[i];
	}
	int om = 0;
	while (findSize1(pDash)>0){
		om++;
		int q[10] = { -1 };
		for (j = 0; j<COUNT; j++){
			q[j] = pDash[j];
		}
		while (findSize1(q)>0){
			int v = firstSetBit1(q);
			pDash[v] = -1;
			q[v] = -1;
			int neighbours[10] = { -1 };
			int graphSize = findGraph1(graph);
			k = 0;
			for (j = 0; j <= graphSize; j++){
				if (graph[j][0] == v){
					neighbours[graph[j][1]] = 1;
				}
				else if (graph[j][1] == v){
					neighbours[graph[j][0]] = 1;
				}
			}
			for (j = 0; j<COUNT; j++)
			if (j != v && (neighbours[j] == 0 || neighbours[j] == -1))
				neighbours[j] = 1;
			else
				neighbours[j] = -1;
			for (j = 0; j<COUNT; j++){
				if (q[j] == neighbours[j] && q[j] == 1)
					q[j] = 1;
				else
					q[j] = -1;
			}
			returnobject->omega[lastBit1(returnobject->omega)] = om;
			returnobject->o[lastBit1(returnobject->o)] = v;
		}
	}
	//	printf("about to return!!\n");
	return returnobject;
}


void expand(int graph[10][2], int* candidateClique, int* adjacentVertices, int* incumbentVertices){
	struct returnObject *returnobject =(struct returnObject*)malloc(sizeof(struct returnObject));
	int i;
	//	printf("adjacentVertices:");
	for (i = 0; i<COUNT; i++){
		//		printf("%d   ",adjacentVertices[i]);
		returnobject->omega[i] = -1;
		returnobject->o[i] = -1;
	}
	/*	printf("\ncandidateClique:");
	for (i = 0; i < COUNT; ++i){
	printf("%d   ",candidateClique[i]);
	}
	printf("\nincumbentVertices:");
	for (i = 0; i < COUNT; ++i){
	printf("%d   ",incumbentVertices[i]);
	}*/
	//	printf("\ncolourise\n");
	returnobject = colourise(graph, adjacentVertices);
	/*	for(i=0;i<COUNT;i++){
	printf("%d   ",returnobject->omega[i]);
	}
	printf("\n");
	for(i=0;i<COUNT;i++){
	printf("%d   ",returnobject->o[i]);
	}*/
	//	printf("\nexpand\n");
	int adjacentSize = findSize1(adjacentVertices);
	for (i = adjacentSize - 1; i >= 0; i--){
		int candidateSize = findSize1(candidateClique);
		int incumbentSize = findSize1(incumbentVertices);
		if (candidateSize + returnobject->omega[i]>incumbentSize){
			int v = returnobject->o[i];
			candidateClique[v] = 1;
			int neighbours[10] = { -1 };
			int graphSize = findGraph1(graph);
			int j = 0;
			for (j = 0; j <= graphSize; j++){
				if (graph[j][0] == v){
					neighbours[graph[j][1]] = 1;
				}
				else if (graph[j][1] == v){
					neighbours[graph[j][0]] = 1;
				}
			}
			int *newAdjacent = (int*)malloc(sizeof(int)* 10);
			for (j = 0; j<COUNT; j++)
				newAdjacent[j] = -1;
			for (j = 0; j<COUNT; j++)
			if (adjacentVertices[j] == neighbours[j] && neighbours[j] == 1)
				newAdjacent[j] = 1;
			int newAdjacentSize = findSize1(newAdjacent);
			if (newAdjacentSize == 0){
				candidateSize = findSize1(candidateClique);
				incumbentSize = findSize1(incumbentVertices);
				if (candidateSize>incumbentSize){
					newGlobal(candidateClique);
					for (j = 0; j<COUNT; j++){
						incumbentVertices[j] = candidateClique[j];
					}
				}
				else if (candidateSize == incumbentSize){
					appendGlobal(candidateClique);
				}
			}
			else{
				expand(graph, candidateClique, newAdjacent, incumbentVertices);
			}
			candidateClique[v] = -1;
			adjacentVertices[v] = -1;
		}
	}
}

__global__ void expand(struct vertex *graph, int* candidateClique, int* adjacentVertices, int* incumbentVertices,struct returnObject *globalQueue,int populate){
	int index = threadIdx.x + blockIdx.x*blockDim.x;
	if (populate == 0){
		int index = threadIdx.x + blockIdx.x*blockDim.x;
		candidateClique = globalQueue[index].omega;
		adjacentVertices = globalQueue[index].o;
		expand1(graph, candidateClique, adjacentVertices, incumbentVertices, globalQueue, populate);

	}
	else{
		expand1(graph, candidateClique, adjacentVertices, incumbentVertices, globalQueue, populate);
	}
}


int main(){
	globalQueue = (struct returnObject*)malloc(sizeof(struct returnObject)*COUNT);
	int *incumbentVertices = (int *)malloc(sizeof(int)*COUNT);
	int *candidateClique = (int *)malloc(sizeof(int)*COUNT);
	int *adjacentVertices = (int *)malloc(sizeof(int)*COUNT);
	int graph1[ROWS][2] = { { 4, 5 }, { 2, 5 }, { 5, 6 }, { 3, 5 }, { 2, 4 }, { 3, 4 }, { 2, 3 }, { 0, 1 }, { 0, 2 }, { 0, 6 }, { 1, 2 }, { 1, 6 } };
	struct vertex *graph = (struct vertex*)malloc(sizeof(struct vertex)*ROWS);
	int i;
	for (i = 0; i<ROWS; i++){
		graph[i].x = graph1[i][0];
		graph[i].y = graph1[i][1];
	}
	int populate = 1;
	int *cudaIncumbent, *cudaCandidate, *cudaAdjacent;
	struct vertex *cudaGraph;
	int sizeVertices = sizeof(int)*COUNT;
	int sizeGraph = sizeof(struct vertex)*ROWS;
	cudaMalloc((void **)&cudaIncumbent, sizeVertices);
	cudaMalloc((void **)&cudaCandidate, sizeVertices);
	cudaMalloc((void **)&cudaAdjacent, sizeVertices);
	cudaMalloc((void **)&cudaGraph, sizeGraph);

	for (i = 0; i<COUNT; i++){
		incumbentVertices[i] = -1;
		candidateClique[i] = -1;
		adjacentVertices[i] = -1;
	}
	for (i = 0; i < COUNT; ++i){
		adjacentVertices[i] = 1;
	}


	cudaMemcpy(cudaIncumbent, incumbentVertices, sizeVertices, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaAdjacent, adjacentVertices, sizeVertices, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaCandidate, candidateClique, sizeVertices, cudaMemcpyHostToDevice);
	cudaMemcpy(cudaGraph, graph, sizeGraph, cudaMemcpyHostToDevice);

	clock_t t;
	t = clock();
	expand << <1, 1 >> >(graph, candidateClique, adjacentVertices, incumbentVertices,globalQueue,populate);
	//if (queueFront <= queueRear)
	populate = 0;
		expand << <findQueueSiz() + 1, 1 >> >(graph, candidateClique, adjacentVertices, incumbentVertices, globalQueue,populate);

	cudaError_t e = cudaMemcpy(incumbentVertices, cudaIncumbent, sizeVertices, cudaMemcpyDeviceToHost);
	//if (e != cudaSuccess)
		//printf("%s", cudaGetErrorString(e));

	//	int incumbentSize=findSize(incumbentVertices);
	expand(graph1, candidateClique, adjacentVertices, incumbentVertices);
	printf("The maximum clique constitutes the vertices: ");
	for (i = 0; i<COUNT; i++){
		if (incumbentVertices[i] == 1)
			printf("%d   ", i + 1);
	}
	printf("\n");
	t = clock() - t;
	double time_taken = ((double)t) / CLOCKS_PER_SEC;
	printf("\nThe algorithm took %f seconds to find the maximum clique of the given graph!\n", time_taken);
	return 0;
}
