void _start() {
    unsigned *catalans = (unsigned *)4;
    catalans[0] = 1;
    for (int i = 1; i < 10; i++) {
        catalans[i] = 0;
        for (int j = 0; j < i; j++) {
            catalans[i] += catalans[j] * catalans[i - 1 - j];
        }
    }
    *(int *)0 = catalans[9];
}
