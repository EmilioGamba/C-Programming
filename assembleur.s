<<<<<<<<<<<<<<INSTRUCTION MOV >>>>>>>>>>>>>>>>>>>>>>>>>



MODE D'ADRESSAGE - MODE REGISTRE
movl %eax, %ebx ; déplacement de %eax vers %ebx 
movl %ecx, %ecx ; 
MODE D'ADRESSAGE - MODE IMMEDIAT
movl $0, %eax ; initialisation de %eax à 0 
movl $1252, %ecx ; initialisation de %ecx à 1252 

Adresse	    Valeur
------------------
0x10    |   0x04
0x0C	|   0x10
0x08	|   0xFF
0x04	|   0x00
0x00	|   0x04

MODE D'ADRESSAGE - MODE ABSOLU
movl 0x04, %eax ; place la valeur 0x00 (qui se trouve à l'adresse 0x04) dans %eax 
movl $1252, %ecx ; initialisation de %ecx à 1252 
movl %ecx, 0x08 ; remplace 0xFF par le contenu de %ecx (1252) à l'adresse 0x08
MODE D'ADRESSAGE - MODE INDIRECT
movl $0x08, %eax ; place la valeur 0x08 dans %eax 
movl (%eax), %ecx ; place la valeur se trouvant à l'adresse qui est 
                ; dans %eax dans le registre %ecx %ecx=0xFF 
movl 0x10, %eax ; place la valeur se trouvant à l'adresse 0x10 dans %eax 
movl %ecx, (%eax) ; place le contenu de %ecx, c'est-à-dire 0xFF à 
                ;l'adresse qui est contenue dans %eax (0x10)
MODE D'ADRESSAGE - MODE AVEC BASE ET DEPLACEMENT
movl $0x08, %eax ; place la valeur 0x08 dans %eax 
movl 0(%eax), %ecx ; place la valeur (0xFF) se trouvant à l'adresse 
                ; 0x08= (0x08+0) dans le registre %ecx 
movl 4(%eax), %ecx ; place la valeur (0x10) se trouvant à l'adresse 
                    ; 0x0C (0x08+4) dans le registre %ecx 
movl -8(%eax), %ecx ; place la valeur (0x04) se trouvant à l'adresse 
                    ; 0x00 (0x08-8) dans le registre %ecx 
                     
                      

<<<<<<<<<<<INSTRUCTION ARITHMETIQUES ET LOGIQUES>>>>>>>>>>>>>>>>>>>>
inc ; qui incrémente d’une unité la valeur stockée dans le registre/l’adresse 
    ;fournie en argument et sauvegarde le résultat de l’incrémentation au 
    ;même endroit. Cette instruction peut être utilisée pour 
    ;implémenter des compteurs de boucles.
dec ;est équivalente à inc mais décrémente son argument
not; qui applique l’opération logique NOT à son argument et stocke le résultat à cet endroit 
add; permet d’additionner deux nombres entiers. 
    ;add prend comme arguments une source et une destination et place 
    ;dans la destination la somme de ses deux arguments. 
sub; permet de soustraire le premier argument du second et stocke le résultat dans le second 
mul ;permet de multiplier des nombres entiers non-signés (imul est le pendant de mul 
    ;pour la multiplication de nombres signés)
div ;permet la division de nombres entiers non-signés. 
shl ;(resp. shr) permet de réaliser un décalage logique vers la gauche (resp. droite) 
xor; calcule un ou exclusif entre ses deux arguments et sauvegarde le résultat dans le second 
and ;calcule la conjonction logique entre ses deux arguments et
    ;sauvegarde le résultat dans le second

                Adresse	 Variable	Valeur
                --------------------------
                0x0C	    c        0x00
                0x08	    b	     0xFF
                0x04	    a	     0x02
                0x00	             0x01
                
movl 0x04, %eax ; %eax=a 
addl $1, %eax ; %eax++ 
movl %eax, 0x04 ; a=%eax 
movl 0x08, %eax ; %eax=b 
subl 0x0c, %eax ; %eax=b-c 
movl %eax, 0x04 ; a=%eax  

                int j,k,g,l; // ... 
                l=g^j;
                j=j|k; 
                g=l<<6;
movl g, %eax ; %eax=g 
xorl j, %eax ; %eax=g^j movl %eax, l ; l=%eax
movl j, %eax ; %eax=j 
orl k, %eax ; %eax=j|k 
movl %eax, j ; j=%eax 
movl l, %eax ; %eax=l 
shll $6, %eax ; %eax=%eax << 6 
movl %eax, g ; g=%eax

<<<<<<<<<<< LES INSTRUCTIONS DE COMPARAISON >>>>>>>>>>>>>>>>>>>>

sete ;met le registre argument à la valeur du drapeau ZF. 
;Permet d’implémenter une égalité.
sets; met le registre argument à la valeur du drapeau SF
setg ;place dans le registre argument la valeur ~SF & ~ZF 
    ;(tout en prenant en compte les dépassements éventuels avec OF). 
    ;Permet d’implémenter la condition >.
setl ;place dans le registre argument la valeur de SF 
    ;(tout en prenant en compte les dépassements éventuels avec OF).
    ;Permet d’implémenter notamment la condition <=.

r=(h>1); 
r=(j==0); 
r=g<=h; 
r=(j==h);

cmpl $1, h ; comparaison 
setg %al ; %al est le byte de poids faible de %eax 
movzbl %al, %ecx ; copie le byte dans %ecx 
movl %ecx, r ; sauvegarde du résultat dans r 

cmpl $0, j ; comparaison 
sete %al ; fixe le byte de poids faible de %eax 
movzbl %al, %ecx 
movl %ecx, r ; sauvegarde du résultat dans r 

movl g, %ecx 
cmpl h, %ecx ; comparaison entre g et h 
setl %al ; fixe le byte de poids faible de %eax 
movzbl %al, %ecx 
movl %ecx, r 

movl j, %ecx 
cmpl h, %ecx ; comparaison entre j et h 
sete %al 
movzbl %al, %ecx 
movl %ecx, r 

<<<<<<<<<<< LES INSTRUCTIONS DE SAUT >>>>>>>>>>>>>>>>>>>>
(goto, permettent de modifier la valeur du compteur du programme %eip)
jmp *%eax ;indique que l’exécution du programme doit se poursuivre 
;par l’exécution de l’instruction se trouvant à l’adresse qui est 
;contenue dans le registre %eax
je ; saut si égal (teste le drapeau ZF) (inverse : jne) 
js ; saut si négatif (teste le drapeau SF) (inverse : jns) 
jg ; saut si strictement supérieur (teste les drapeaux SF et ZF et 
    ;prend en compte un overflow éventuel) (inverse : jl) 
jge ; saut si supérieur ou égal (teste le drapeaux SF et 
    ;prend en compte un overflow éventuel) (inverse : jle) 

for(j=0;j<10;j++) { 
    g=g+h; 
} 
for(j=9;j>0;j=j-1) {
     g=g-h;
}

    movl $0, j ; j=0 
.LBB4_1: 
    cmpl $10, j 
    jge .LBB4_4 ; jump si j>=10 
    movl g, %eax ; %eax=g 
    addl h, %eax ; %eax+=h 
    movl %eax, g ; %eax=g 
    movl j, %eax ; %eax=j 
    addl $1, %eax ; %eax++ 
    movl %eax, j ; j=%eax 
    jmp .LBB4_1 
        
.LBB4_4: 
    movl $9, j ; j=9 
    
.LBB4_5: 
    cmpl $0, j jle .LBB4_8 ; jump si j<=0 
    movl g, %eax 
    subl h, %eax 
    movl %eax, g 
    movl j, %eax ; %eax=j 
    subl $1, %eax ; %eax-- 
    movl %eax, j ; j=%eax 
    jmp .LBB4_5 
.LBB4_8:

<<<<<<<<<<< MANIPULATION DE PILES>>>>>>>>>>>>>>>>>>>>

esp ; contient l'adresse du sommet de la pile
pushl %reg ; place le contenu du registre %reg au sommet 
;de la pile et décrémente dans le registre %esp l’adresse 
;du sommet de la pile de 4 unités. 
popl %reg ; retire le mot de 32 bits se trouvant 
;au sommet de la pile, le sauvegarde dans 
;le registre %reg et incrémente dans le registre %esp 
;l’adresse du sommet de la pile de 4 unités

                    pushl %ebx
subl $4, %esp ; ajoute un bloc de 32 bits au sommet de la pile
movl %ebx, (%esp) ; sauvegarde le contenu de %ebx au sommet
                    popl %ecx
movl (%esp), %ecx ; sauve dans %ecx la donnée au sommet de la pile 
addl $4, %esp ; déplace le sommet de la pile de 4 unites vers le haut

push %eax ; %esp contient 0x08 et M[0x08]=0x02 
push %ebx ; %esp contient 0x04 et M[0x04]=0xFF 
pop %eax ; %esp contient 0x08 et %eax 0xFF 
pop %ebx ; %esp contient 0x0C et %ebx 0x02 
pop %eax ; %esp contient 0x10 et %eax 0x04


<<<<<<<<<<< LES FONCTIONS ET LES PROCEDURES >>>>>>>>>>>

int g=0; 
int h=2; 
void increase() { 
    g=g+h; 
} 
void init_g() { 
    g=1252; 
} 
int main(int argc, char *argv[]) { 
    init_g(); 
    increase(); 
    return(EXIT_SUCCESS); 
}

increase: ; étiquette de la première instruction
movl g, %eax 
addl h, %eax 
movl %eax, g 
ret ; retour à l'endroit qui suit l'appel 

init_g: ; étiquette de la première instruction 
movl $1252, g 
ret ; retour à l'endroit qui suit l'appel

main: 
subl $12, %esp 
movl 20(%esp), %eax 
movl 16(%esp), %ecx 
movl $0, 8(%esp) 
movl %ecx, 4(%esp) 
movl %eax, (%esp) 
calll init_g ; appel à la procédure init_g 

A_init_g: 
calll increase ; appel à la procédure increase 

A_increase: 
movl $0, %eax 
addl $12, %esp ret ; fin de la fonction main 

g: ; étiquette, variable globale g 
.long 0 ; initialisée à 0 

h: ; étiquette, variable globale g 
.long 2 ; initialisée à 2