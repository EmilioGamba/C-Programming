#include <pthread.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <errno.h>
#define NTHREADS 4 
void *neg (void * param) { 
    int *l; 
    l=(int *) param; 
    int *r=(int *)malloc(sizeof(int)); 
    *r=-*l; 
    return ((void *) r); 
} 
int main (int argc, char *argv[]) {
    pthread_t threads[NTHREADS]; 
    int arg[NTHREADS]; 
    int err; 
    for(long i=0;i<NTHREADS;i++) { 
        arg[i]=i; 
        err=pthread_create(&(threads[i]),NULL,&neg,(void *) &(arg[i])); 
        if(err!=0){
            error(err,"pthread_create");
        }
        
    } for(int i=0;i<NTHREADS;i++) { 
        int *r; 
        err=pthread_join(threads[i],(void **)&r); 
        printf("Resultat[%d]=%d\n",i,*r); 
        free(r); 
        if(err!=0){ 
            error(err,"pthread_join");
        }
    } return(EXIT_SUCCESS); 
}