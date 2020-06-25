int add(int *, int *);

void _start(){
    *(int *)0 = 0xdead0000;
    *(int *)4 = 0x0000beef;
    *(int *)8 = add((int *)0, (int *)4);
}

int add(int *a, int *b){
    return *a + *b;
}
