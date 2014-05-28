#include <semaphore.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#define NTHREADS 2 
sem_t semaphore; 
void *before(void * param) { 
    // do something 
    for(int j=0;j<1000000;j++) { } 
    sem_post(&semaphore); 
    return(NULL); 
} 
void *after(void * param) { 
    sem_wait(&semaphore); 
    // do something 
    for(int j=0;j<1000000;j++) { } 
    return(NULL); 
} 
int main (int argc, char *argv[]) { 
    pthread_t thread[NTHREADS]; 
    void * (* func[])(void *)={before, after}; 
    int err; 
    err=sem_init(&semaphore, 0,0); 
    if(err!=0) { 
        error(err,"sem_init"); 
    } 
    for(int i=0;i<NTHREADS;i++) { 
        err=pthread_create(&(thread[i]),NULL,func[i],NULL); 
        if(err!=0) { 
            error(err,"pthread_create"); 
        } 
    } 
    for(int i=0;i<NTHREADS;i++) { 
        err=pthread_join(thread[i],NULL); 
        if(err!=0) { 
            error(err,"pthread_join"); 
        } 
    } 
    sem_destroy(&semaphore); 
    if(err!=0) { 
        error(err,"sem_destroy"); 
    } 
    return(EXIT_SUCCESS); 
}
