
#include <stdio.h>
#include <stdlib.h>
#define LEN 1024 

int main(int argc, char *argv[]) { 
    int *v1;
    int *v2;
    int sum=0; 
    v1=(int *)malloc(sizeof(int)*LEN); 
    printf("v1 : %d\n", *(v1));
    for(int i=0;i<LEN;i++) { 
        sum+=*(v1+i); 
        *(v1+i)=1252; 

        
    } 
    printf("v1 : %d\n", &(v1));
    printf("Somme des éléments de v1 : %d\n", sum);
    sum=0; 
    free(v1); 
    v2=(int *)malloc(sizeof(int)*LEN); 
    printf("v2 : %d\n", &(v2));
    for(int i=0;i<LEN;i++) { 
        sum+=*(v2+i); 
    } 
    printf("Somme des éléments de v2 : %d\n", sum); free(v2); 
    return(EXIT_SUCCESS); 
} 