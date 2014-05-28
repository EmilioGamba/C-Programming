#include <stdio.h>
#include <stdarg.h>
#include <pthread.h>
#include <stdlib.h> 
#include <string.h> 
#include <errno.h>
#define NTHREADS 4

long global=0; 
int increment(int i) { 
    
    return i+1; 
} 
void *func(void * param) { 
    for(int j=0;j<1000000;j++) { 
        global=increment(global); 
    } 
    return(NULL); 
}


int main (int argc, char *argv[]) { 
    pthread_t thread[NTHREADS]; 
    int err; 
    for(int i=0;i<NTHREADS;i++) { 
        err=pthread_create(&(thread[i]),NULL,&func,NULL); 
        //if(err!=0) error(err,"pthread_create"); 
    } /*...*/ 
    for(int i=NTHREADS-1;i>=0;i--) { 
        err=pthread_join(thread[i],NULL); 
        //if(err!=0) error(err,"pthread_join");
    } 
    printf("global: %ld\n",global); 
    return(EXIT_SUCCESS); 
} 
