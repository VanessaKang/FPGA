#include "system.h"
#include <unistd.h>

int main()
{
	char * charmemspace = (char *) SRAM_CONTROLLER_0_BASE;
	int * intmemspace = (int *) SRAM_CONTROLLER_0_BASE;
	short *shortmemspace = (short *) SRAM_CONTROLLER_0_BASE;

	int i;

	// SRAM test for chars
	for (i = 0; i < 5; i = i +1) {
		*(charmemspace + 2*i) = (char) (i + 90);
		usleep(1000*1000);
	}

	//* charmemspace = SRAM_CONTROLLER_0_BASE;
	for (i = 0; i < 5; i = i + 1) {
		if (* (charmemspace + 2*i) != (char) (i + 90)) {
			printf("The test for int values failed");
		}

		else {
			printf("%c\n", *(charmemspace + 2*i));
		}
		usleep(1000*1000);
	}

	printf("\n");
//
//	// SRAM test for shorts
//
	for (i = 0; i < 5; i = i + 1) {
		* (shortmemspace + i) = (short) (i + 50);
		usleep(1000*1000);
	}

	//* shortmemspace = SRAM_CONTROLLER_0_BASE;

	for (i = 0; i < 5; i = i + 1) {
		if (* (shortmemspace + i) != (short)(i+50)) {
			printf("The test for short values failed");
		}

		else {
			printf("%i\n", *(shortmemspace + i));
		}
		usleep(1000*1000);
	}

	printf("\n");
//
//	// SRAM test for ints
//
	for (i = 0; i < 5; i = i + 1) {
		* (intmemspace + i) = i + 132566;
		usleep(1000*1000);
	}

	//* intmemspace = SRAM_CONTROLLER_0_BASE;

	for (i = 0; i < 5; i = i + 1) {
		if (* (intmemspace + i) !=  (i + 132566)) {
			printf("The test for int values failed");
		}

		else {
			printf("%i\n", *(intmemspace + i));
		}
		usleep(1000*1000);
	}
//
	return 0;
}
