<<<<<<<< algorithme de Peterson  >>>>>>>>>>>>>>>>>>>>

#define A 0 
#define B 1 
int flag[]; 
flag[A]=false; 
flag[B]=false;

// thread A 
flag[A]=true; 
turn=B; 
while((flag[B]==true)&&(turn==B)) 
    { /* loop */ } 
section_critique(); 
flag[A]=false; 

// Thread B 
flag[B]=true; 
turn=A; 
while((flag[A]==true)&&(turn==A)) { /* loop */ } 
section_critique(); flag[B]=false;


<<<<<<<<< INSTRUCTIONS ATOMIQUES >>>>>>>>>>>>>>>>>

xchg ;permet d’échanger, de façon atomique, le contenu 
      ;  d’un registre avec une zone de la mémoire

lock: ; étiquette, variable 
    .long 0 ; initialisée à 0 
enter: 
    movl $1, %eax ; %eax=1 
    xchgl %eax, (lock) ; instruction atomique, échange (lock) et %eax 
    ; après exécution, %eax contient la donnée qui était 
    ; dans lock et lock la valeur 1 
    testl %eax, %eax    ; met le flag ZF à vrai si %eax contient 0 jnz enter 
    ; retour à enter: si ZF n'est pas vrai 
    ret 
leave: 
    mov $0, %eax ; %eax=0 xchgl %eax, (lock) ; instruction atomique 
ret 

<<<<<<<<< Coordination par Mutex >>>>>>>>>>>>>>>>>

1. libre (ou unlocked en anglais). Cet état indique que la ressource est 
libre et peut être utilisée sans risquer de provoquer une violation d’exclusion mutuelle. 

2. réservée (ou locked en anglais). Cet état indique que la ressource
 associée est actuellement utilisée et qu’elle ne peut pas être utilisée par un autre thread.
 
#define NTHREADS 4 
long global=0; la ressource partagée
pthread_mutex_t mutex_global;représenté par une structure de données de type pthread_mutex_t
int increment(int i) { 
    return i+1; 
} 
void *func(void * param) { 
    int err; 
    for(int j=0;j<1000000;j++) { 
        err=pthread_mutex_lock(&mutex_global); 
        if(err!=0) 
        error(err,"pthread_mutex_lock"); 
        global=increment(global); 
        err=pthread_mutex_unlock(&mutex_global); 
        if(err!=0) error(err,"pthread_mutex_unlock"); 
    } return(NULL); 
} 
int main (int argc, char *argv[]) { 
    pthread_t thread[NTHREADS]; 
    int err; 
    err=pthread_mutex_init( &mutex_global, NULL); 
    if(err!=0) 
        error(err,"pthread_mutex_init"); 
    for(int i=0;i<NTHREADS;i++) { 
        err=pthread_create(&(thread[i]),NULL,&func,NULL); 
        if(err!=0) 
            error(err,"pthread_create"); 
    } 
    for(int i=0; i<1000000000;i++) { 
        /*...*/ 
    } 
    for(int i=NTHREADS-1;i>=0;i--) { 
        err=pthread_join(thread[i],NULL); 
        if(err!=0) 
            error(err,"pthread_join"); 
    } err=pthread_mutex_destroy(&mutex_global); 
    if(err!=0) 
        error(err,"pthread_mutex_destroy"); 
    printf("global: %ld\n",global); 
    return(EXIT_SUCCESS); 
}

<<<<<<<<< Les sémaphores >>>>>>>>>>>>>>>>>

sémaphore est une structure de données qui est maintenue 
par le système d’exploitation et contient :
1. un entier qui stocke la valeur, positive ou nulle, du sémaphore.
2. une queue qui contient les pointeurs vers les threads qui 
    sont bloqués en attente sur ce sémaphore.
initialisé à 1, un sémaphore peut être utilisé de la même façon qu’un mutex 

#include <semaphore.h> 

int sem_init(sem_t *sem, int pshared, unsigned int value); 
int sem_destroy(sem_t *sem); 
int sem_wait(sem_t *sem);
// section critique
int sem_post(sem_t *sem); 

<<<<<<<<< Problème du rendez-vous >>>>>>>>>>>>>>>>>

sem_t rendezvous; 
pthread_mutex_t mutex; 
int count=0; 
sem_init(&rendezvous,0,0);

premiere_phase(); 
// section critique 
pthread_mutex_lock(&mutex); 
count++; 
if(count==N) { 
    // tous les threads sont arrivés 
    sem_post(&rendezvous); 
} 
pthread_mutex_unlock(&mutex); // attente à la barrière 
sem_wait(&rendezvous); // libération d'un autre thread en attente 
sem_post(&rendezvous); 
seconde_phase();

<<<<<<<<< Problème des producteurs-consommateurs >>>>>>>>>>>>>>>>>

producteurs : Ce sont des threads qui produisent des données et 
    placent le résultat de leurs calculs dans une zone mémoire 
    accessible aux consommateurs
consommateurs : Ce sont des threads qui utilisent les valeurs 
    calculées par les producteurs
    
// Initialisation 
#define N 10 // slots du buffer 
pthread_mutex_t mutex; 
sem_t empty; sem_t full;
pthread_mutex_init(&mutex, NULL); 
sem_init(&empty, 0 , N); // buffer vide 
sem_init(&full, 0 , 0); // buffer vide

// Producteur
void producer(void)
{
  int item;
  while(true)
  {
    item=produce(item);
    sem_wait(&empty); // attente d'un slot libre
    pthread_mutex_lock(&mutex);
     // section critique
     insert_item();
    pthread_mutex_unlock(&mutex);
    sem_post(&full); // il y a un slot rempli en plus
  }
}

// Consommateur
void consumer(void)
{
 int item;
 while(true)
 {
   sem_wait(&full); // attente d'un slot rempli
   pthread_mutex_lock(&mutex);
    // section critique
    item=remove(item);
   pthread_mutex_unlock(&mutex);
   sem_post(&empty); // il y a un slot libre en plus
 }
}

<<<<<<<<< Problème des readers-writers >>>>>>>>>>>>>>>>>

lecteurs (readers):  threads qui lisent une structure de
 données (ou une base de données) mais ne la modifient pas
écrivains (writers):threads qui modifient une structure de données

/* Initialisation */
pthread_mutex_t mutex_readcount; // protège readcount
pthread_mutex_t mutex_writecount; // protège writecount
pthread_mutex_t z; // un seul reader en attente
sem_t wsem;       // accès exclusif à la db
sem_t rsem;       // pour bloquer des readers
int readcount=0;
int writecount=0;

sem_init(&wsem, 0, 1);
sem_init(&rsem, 0, 1);

/* Writer */
while(true)
{
  think_up_data();

  pthread_mutex_lock(&mutex_writecount);
    // section critique - writecount
    writecount=writecount+1;
    if(writecount==1) {
      // premier writer arrive
      sem_wait(&rsem);
    }
  pthread_mutex_unlock(&mutex_writecount);

  sem_wait(&wsem);
    // section critique, un seul writer à la fois
    write_database();
  sem_post(&wsem);

  pthread_mutex_lock(&mutex_writecount);
     // section critique - writecount
     writecount=writecount-1;
     if(writecount==0) {
       // départ du dernier writer
       sem_post(&rsem);
     }
  pthread_mutex_unlock(&mutex_writecount);
 }
 
 