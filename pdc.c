#include<stdio.h>
#include<stdlib.h>

int incumbentVertices[10]={0};
int candidateClique[10]={0};
int adjacentVertices[10]={1,1,1,1,1,1};
int graph[10][2]={{0,1},{0,2},{0,3},{0,5},{1,5},{2,3},{2,5},{3,4},{4,5}};
int omega[10]={0};
int o[10]={0};

#define COUNT 10
/*
int findSize(int a[]){
	int i=0;
	int counter=0;
	while(i<COUNT && ((a[i]==1 && counter++) || (a[i]!=1)) && ++i);
	return (counter-1);
}*/

int findSize(int a[]){
        int i=0;
        int counter=0;
        for(i=0;i<COUNT;i++)
                if(a[i]==1)
                        counter++;
        return (counter);
}

int findGraph(int a[10][2]){
	int i=0;
	while(i<COUNT && a[i++][0]!=0);
	return i-1;
}

int findOriginal(int a[]){
	int i=0;
	for(i;i<COUNT;i++)
		if(i==0)
			return i;
}

int lastBit(int a[]){
	int i;
	for(i=0;i<COUNT;i++)
		if(a[i]==0)
			return i;
}

int firstSetBit(int a[]){
	int i;
	for(i=0;i<COUNT;i++)
		if(a[i]==1)
			return i;
}

//void colourise(int graph[10][2],int adjacentVertices[10],int omega[10],int o[10]){
void colourise(){
//	printf("%d\n",zz++);
	int pDash[10]={0};
	int i=0,j=0,k=0;
	int adjacentSize=findSize(adjacentVertices);
	adjacentSize=COUNT;
	for(i=0;i<adjacentSize;i++){
		pDash[i]=adjacentVertices[i];
	}
	int om=0;
	while(findSize(pDash)>0){
//		printf("123213\n");
		om++;
		int q[10]={0};
		//for(j=0;j<findSize(pDash);j++){
		for(j=0;j<COUNT;j++){
			q[j]=pDash[j];
		}
		while(findSize(q)>0){
//			printf("found!\n");
			int v=firstSetBit(q);
			/*int swap=0;
			for(j=0;j<findSize(pDash)-1;j++){
				if(pDash[j]==v)
					swap=1;
				if(swap==1)
					pDash[j]=pDash[j+1];
			}
			pDash[findSize(pDash)-1]=0;
			swap=0;
			for(j=0;j<findSize(q)-1;j++){
				if(q[j]==v)
					swap=1;
				if(swap==1)
					q[j]=q[j+1];
			}
			q[findSize(q)-1]=0;*/
			pDash[v]=0;
			q[v]=0;
			int neighbours[10]={0};
			int graphSize=findGraph(graph);
			k=0;			
			for(j=0;j<=graphSize;j++){
				if(graph[j][0]==v){
				//	neighbours[k++]=graph[j][1];
					neighbours[graph[j][1]-1]=1;
				}
			}
			int newq[10]={0};
			int z=0;
			/*for(j=0;j<findSize(q);j++){
				for(k=0;k<findSize(neighbours);k++){
					if(q[j]==neighbours[k]){
						newq[z++]=q[j];
					}
				}
			}
			for(j=0;j<findSize(newq);j++)
				q[j]=newq[j];
			*/
			for(j=0;j<COUNT;j++){
				if(q[j]==neighbours[j] && q[j]==1)
					q[j]=1;
				else
					q[j]=0;
			}	
			omega[findOriginal(omega)]=om;
			o[lastBit(o)]=v;
		}
	}
//	printf("2");
	return;
}


//void expand(int graph[10][2],int candidateClique[10], int adjacentVertices[10],int incumbentVertices[10]){
//	printf("called expand from main\n");
void expand(){
//	int omega[10]={0};
//	int o[10]={0};
	printf("colourise\n");
//	colourise(graph,adjacentVertices,omega,o);
	colourise();
	printf("expand\n");
	int adjacentSize=findSize(adjacentVertices);
	int i=0;	
	for(i=adjacentSize-1;i>=0;i--){
		int candidateSize=findSize(candidateClique);
		int incumbentSize=findSize(incumbentVertices);
		if(candidateSize+omega[i]>incumbentSize){
			int v=o[i];
			candidateClique[v]=1;
			int neighbours[10]={0};
			int graphSize=findGraph(graph);
			int j=0,k=0,l=0,m=0;
			for(j=0;j<=graphSize;j++){
				if(graph[j][0]==v){
					neighbours[graph[j][1]-1]=1;
				}
			}
			int newAdjacent[10]={0};
			/*k=0;
			int neighbourSize=findSize(neighbours);
			int adjacentSize=findSize(adjacentVertices);
			for(j=0;j<neighbourSize;j++){
				for(l=0;l<adjacentSize;l++){
					if(adjacentVertices[l]==neighbours[j]){
						newAdjacent[m++]=adjacentVertices[l];
					}
				}
			}
			*/
			for(j=0;j<COUNT;j++)
				if(adjacentVertices[j]==neighbours[j] && neighbours[j]==1)
					newAdjacent[j]=1;
			int newAdjacentSize=findSize(newAdjacent);
			if(newAdjacentSize<=0){
				candidateSize=findSize(candidateClique);
				incumbentSize=findSize(incumbentVertices);
				if(candidateSize>incumbentSize){
					for(j=0;j<COUNT;j++){
						incumbentVertices[j]=candidateClique[j];
//						printf("123%d\n",incumbentVertices[j]);
					}
				}
			}
			else{
//				expand(graph,candidateClique,newAdjacent,incumbentVertices);
				printf("expand\n");
				expand();
			}
			/*int swap=0;
			candidateSize=findSize(candidateClique);
			for(j=0;j<candidateSize-1;j++){
				if(candidateClique[j]==v)
					swap=1;
				if(swap==1)
					candidateClique[j]=candidateClique[j+1];
			}
			candidateClique[candidateSize-1]=0;
			swap=0;
			adjacentSize=findSize(adjacentVertices);
			for(j=0;j<adjacentSize-1;j++){
				if(adjacentVertices[j]==v)
					swap=1;
				if(swap==1)
					adjacentVertices[j]=adjacentVertices[j+1];
			}
			adjacentVertices[adjacentSize-1]=0;*/
			candidateClique[v]=0;
			adjacentVertices[v]=0;
//			printf("1111\n");
//			for(j=0;j<adjacentSize;j++)
//				printf("%d\n",adjacentVertices[j]);
		}
	}
}


int main(){
//	int  incumbentVertices[10]={0};
//	int candidateClique[10]={0};
//	int adjacentVertices[10]={0};
//	int graph[10][2]={{1,2},{1,3},{1,4},{1,6},{2,6},{3,4},{3,6},{4,5},{5,6}};
//	printf("call expand from main\n");
//	expand(graph,candidateClique,adjacentVertices,incumbentVertices);
	expand();
	int i=0;
	int incumbentSize=findSize(incumbentVertices);
	for(i=0;i<COUNT;i++)
		//printf("%d\n",incumbentVertices[i]);
		if(incumbentVertices[i]==1)
			printf("%d   ",i+1);
	return 0;
}
		