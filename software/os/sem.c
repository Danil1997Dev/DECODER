#include <stdio.h>
#include "altera_avalon_sem_regs.h"
#include "alt_types.h"
#include "system.h"

#define LIMIT 2
int range [LIMIT] = {
		3000000,
		7000000
};

#define SET 5
float caff [SET] = {
/*		3.05482/10000000,
		6.10964/10000000,
		3.05482/10000000,
		-1.998436106,
		0.99843733*/
		0.000001,
		-1.483,
		0.553,
		-0.535,
		0.951
};

float Ku = 2*3.14*440000;

int main()
{ 
	int i,j;
	volatile float *p;
	volatile float *pk;
	volatile int *pr;

	pk = (float*) DECODER_BASE + 16;
	*pk = Ku;

	pr = (int*) DECODER_BASE + 16 + 8;
	for (j=0; j<LIMIT; j++)
		{
			*pr = range[j];
			pr++;
		}

	p = (float*) DECODER_BASE + 8;
	for (i=0; i<SET; i++)
		{
			*p = caff[i];
			p++;
		}
	//since we use pointers (cached data access) to write divisor RAM, 
	//and not direct i/o access with IOWR, we need to flush cache
	IOWR_ALTERA_AVALON_INIT_CTL(DECODER_BASE, 0x07);
	alt_dcache_flush();


	printf("Ready\n");

	while (1)
	{

	}
	
	return 0;
}
