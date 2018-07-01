#include<time.h>
#include<stdio.h>
#include<stdlib.h>

#define COUNT 7
#define ROWS 12

struct returnObject{
	int omega[COUNT];
	int o[COUNT];
};

int findSize(int a[]){
        int i=0;
        int counter=0;
        for(i=0;i<COUNT;i++)
                if(a[i]==1)
                        counter++;
        return (counter);
}

int findGraph(int a[ROWS][2]){
	int i=0;
	while(i<COUNT && a[i++][0]!=-1);
	return i-1;
}

int lastBit(int a[]){
	int i;
	for(i=0;i<COUNT;i++)
		if(a[i]==-1)
			return i;
}

int firstSetBit(int a[]){
	int i;
	for(i=0;i<COUNT;i++)
		if(a[i]==1)
			return i;
}


struct returnObject *colourise(int graph[ROWS][2],int* adjacentVertices){
	struct returnObject *returnobject=malloc(sizeof(struct returnObject));
	int i;
	for(i=0;i<COUNT;i++){
		returnobject->omega[i]=-1;
		returnobject->o[i]=-1;
	}
	int pDash[COUNT];
	int j=0,k=0;
	for(i=0;i<COUNT;i++){
		pDash[i]=adjacentVertices[i];
	}
	int om=0;
	while(findSize(pDash)>0){
		om++;
		int q[COUNT];
		for(j=0;j<COUNT;j++){
			q[j]=pDash[j];
		}
		while(findSize(q)>0){
			int v=firstSetBit(q);
			pDash[v]=-1;
			q[v]=-1;
			int neighbours[COUNT];
			for(j=0;j<COUNT;j++)
				neighbours[j]=-1;
			int graphSize=findGraph(graph);
			for(j=0;j<=graphSize;j++){
				if(graph[j][0]==v){
					neighbours[graph[j][1]]=1;
				}
				else if(graph[j][1]==v){
					neighbours[graph[j][0]]=1;
				}
			}
			for(j=0;j<COUNT;j++)
				if(j!=v && (neighbours[j]==0 || neighbours[j]==-1))
					neighbours[j]=1;
				else
					neighbours[j]=-1;
			for(j=0;j<COUNT;j++){
				if(q[j]==neighbours[j] && q[j]==1)
					q[j]=1;
				else
					q[j]=-1;
			}
			returnobject->omega[lastBit(returnobject->omega)]=om;
			returnobject->o[lastBit(returnobject->o)]=v;
		}
	}
	return returnobject;
}


void expand(int graph[ROWS][2],int* candidateClique, int* adjacentVertices,int* incumbentVertices){
	struct returnObject *returnobject=malloc(sizeof(struct returnObject));
	int i;
	for(i=0;i<COUNT;i++){
		returnobject->omega[i]=-1;
		returnobject->o[i]=-1;
	}
	returnobject=colourise(graph,adjacentVertices);
	int adjacentSize=findSize(adjacentVertices);
	for(i=adjacentSize-1;i>=0;i--){
		int candidateSize=findSize(candidateClique);
		int incumbentSize=findSize(incumbentVertices);
		if(candidateSize+returnobject->omega[i]>incumbentSize){
			int v=returnobject->o[i];
			candidateClique[v]=1;
			int neighbours[10]={-1};
			int graphSize=findGraph(graph);
			int j=0;
			for(j=0;j<=graphSize;j++){
				if(graph[j][0]==v){
					neighbours[graph[j][1]]=1;
				}
				else if(graph[j][1]==v){
					neighbours[graph[j][0]]=1;
				}
			}
			int *newAdjacent=malloc(sizeof(int)*COUNT);
			for(j=0;j<COUNT;j++)
				newAdjacent[j]=-1;
			for(j=0;j<COUNT;j++)
				if(adjacentVertices[j]==neighbours[j] && neighbours[j]==1)
					newAdjacent[j]=1;
			int newAdjacentSize=findSize(newAdjacent);
			if(newAdjacentSize==0){
				candidateSize=findSize(candidateClique);
				incumbentSize=findSize(incumbentVertices);
				if(candidateSize>incumbentSize){
					for(j=0;j<COUNT;j++){
						incumbentVertices[j]=candidateClique[j];
					}
				}
			}
			else{
				expand(graph,candidateClique,newAdjacent,incumbentVertices);
			}
			candidateClique[v]=-1;
			adjacentVertices[v]=-1;
		}
	}
}


int main(){
	int *incumbentVertices=malloc(sizeof(int)*COUNT);
	int *candidateClique=malloc(sizeof(int)*COUNT);
	int *adjacentVertices=malloc(sizeof(int)*COUNT);
	int graph[ROWS][2]={{4,5},{2,5},{5,6},{3,5},{2,4},{3,4},{2,3},{0,1},{0,2},{0,6},{1,2},{1,6}};
	int i,j;
	for(i=0;i<COUNT;i++){
		incumbentVertices[i]=-1;
		candidateClique[i]=-1;
		adjacentVertices[i]=-1;
	}
	for (i = 0; i < COUNT; ++i){
		adjacentVertices[i]=1;
	}
	clock_t t;
	t=clock();
	expand(graph,candidateClique,adjacentVertices,incumbentVertices);
	int incumbentSize=findSize(incumbentVertices);
	printf("The maximum clique constitutes the vertices: ");
	for(i=0;i<COUNT;i++){
		if(incumbentVertices[i]==1)
			printf("%d   ",i+1);
	}
	printf("\n");
	t=clock()-t;
	double time_taken=((double)t)/CLOCKS_PER_SEC;
	printf("\nThe algorithm took %f seconds to find the maximum clique of the given graph!\n",time_taken);
	return 0;
}
