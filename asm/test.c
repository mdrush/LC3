#include <stdio.h>

// int fib(int x) {
// 	if (x < 2) {
// 		return x;
// 	}
// 	return fib(x - 1) + fib(x - 2);
// }

int main()
{
	int x = 0;
	int i;
	int j;
	int k;
	int t;
	int u;
	int v;
	int s;

	scanf("%d", &x);
	// while (x < 15) {
	//printf("%d ", fib(x));
	// 	x = x + 1;
	// }
	for (i = 0; i < x; i++) {
		long y = 1;
		for (j = 1; j + i < x; j++) {
			printf(" ");
		}
		for (k = 0; k <= i; k++) {
			printf(" %d", y);
			u = (k + 1);
			s = (y * i);
			t = (y * k);
			v = s - t;
			y = v / u;

		}
		printf("\n");
	}
	
	return 0;
}

