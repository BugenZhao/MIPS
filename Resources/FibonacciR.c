int fibonacci(int n);

void _start() {
    // *(int *)0 = 5;
    int n = *(int *)0;
    *(int *)4 = fibonacci(n);
}

int fibonacci(int n) {
    if (n <= 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
