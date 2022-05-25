#include <stdio.h>
#include "altera_avalon_sem_regs.h"
#include "alt_types.h"
#include "system.h"

#define LIMIT 2
int range [LIMIT] = {
		1000000,
		50000000
};

#define SET 5
float caff [SET] = {
		1.0,
		-1.483589765,
		0.55343,
		-0.5367,
		0.95157
};

float Ku = 10000000.0;

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