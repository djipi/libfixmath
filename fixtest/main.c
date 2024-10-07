#include "hiclock.h"
#include <inttypes.h>
#include <libfixmath/fixmath.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//#define EXP				// Difference between Visual Studio and GNU libm in case of inf. (0x7f800000 vs. 0x3f800000)
//#define ATAN
//#define SIN
#define SQRT

#ifdef TAN
#define fix_func     fix16_tan
#define fix_func_str "fix16_tan"
#define flt_func     tanf
#define flt_func_str "tanf"
#endif

#ifdef MOD
#define fix_func     fix16_mod
#define fix_func_str "fix16_mod"
#define flt_func     modf
#define flt_func_str "modf"
#endif

#ifdef FLOOR
#define fix_func     fix16_floor
#define fix_func_str "fix16_floor"
#define flt_func     floorf
#define flt_func_str "floorf"
#endif

#ifdef COS
#define fix_func     fix16_cos
#define fix_func_str "fix16_cos"
#define flt_func     cosf
#define flt_func_str "cosf"
#endif

#ifdef CEIL
#define fix_func     fix16_ceil
#define fix_func_str "fix16_ceil"
#define flt_func     ceilf
#define flt_func_str "ceilf"
#endif

#ifdef ACOS
#define fix_func     fix16_acos
#define fix_func_str "fix16_acos"
#define flt_func     acosf
#define flt_func_str "acosf"
#endif

#ifdef EXP
#define fix_func     fix16_exp
#define fix_func_str "fix16_exp"
#define flt_func     expf
#define flt_func_str "expf"
#endif

#ifdef ATAN
#define fix_func     fix16_atan
#define fix_func_str "fix16_atan"
#define flt_func     atanf
#define flt_func_str "atanf"
#endif

#ifdef ATAN2
#define fix_func     fix16_atan2
#define fix_func_str "fix16_atan2"
#define flt_func     atan2f
#define flt_func_str "atan2f"
#endif

#ifdef SIN
#define fix_func     fix16_sin
#define fix_func_str "fix16_sin"
#define flt_func     sinf
#define flt_func_str "sinf"
#endif

#ifdef SQRT
#define fix_func     fix16_sqrt
#define fix_func_str "fix16_sqrt"
#define flt_func     sqrtf
#define flt_func_str "sqrtf"
#endif

#if 1
#define args 1		// number of generated random values (max 256)
#define iter 1		// number of iteration loop on the desired function (exp, atan, etc.) using the random values (max 256)
#define pass 1		// number of pass on the iteration loops (max 256)
#endif

int main(int argc, char **argv)
{
	printf("libfixmath fixtest tool\n");

	hiclock_init();
	
#if 0
	uintptr_t args = (1 << 8);
	uintptr_t iter = (1 << 8);
	uintptr_t pass = (1 << 8);
#endif

	unsigned int i;
	srand(time(NULL));

	hiclock_t fix_duration = 0;
	hiclock_t flt_duration = 0;
	fix16_t   fix_error	= 0;

	unsigned int k;
	for (k = 0; k < pass; k++)
	{
		fix16_t fix_args[args];
		for (i = 0; i < args; i++)  fix_args[i] = (rand() ^ (rand() << 16)); 
		fix16_t   fix_result[args];
		hiclock_t fix_start = hiclock();
		for (i = 0; i < iter; i++)
		{
			unsigned int j;
			for (j = 0; j < args; j++)  fix_result[j] = fix_func(fix_args[j]); 
		}
		hiclock_t fix_end = hiclock();

		float flt_args[args];
		for (i = 0; i < args; i++) flt_args[i] = fix16_to_float(fix_args[i]);
		float flt_result[args];
		hiclock_t flt_start = hiclock();
		for (i = 0; i < iter; i++)
		{
			unsigned int j;
			for (j = 0; j < args; j++)  flt_result[j] = flt_func(flt_args[j]); 
		}
		hiclock_t flt_end = hiclock();

		for (i = 0; i < args; i++)
		 fix_error += abs(fix16_from_float(flt_result[i]) - fix_result[i]); 
		flt_duration += (flt_end - flt_start);
		fix_duration += (fix_end - fix_start);

		printf("Pass %u\n", k);
		for (i = 0; i < args; i++)
		{
		 printf("       fix_args[%u]: 0x%08x\n", i, (unsigned int)fix_args[i]);
		 printf("     fix_result[%u]: 0x%08x (%s)\n", i, (unsigned int)fix_result[i], fix_func_str);
		 printf("       flt_args[%u]: 0x%08x (fix16_to_float)\n", i, *(unsigned int*)&flt_args[i]);
		 printf("     flt_result[%u]: 0x%08x %s(fix16_to_float)\n", i, *(unsigned int*)&flt_result[i], flt_func_str);
		}
	}

	printf("                   %16s: %08" PRIuHICLOCK " @ %" PRIu32 "Hz\n", flt_func_str, flt_duration, HICLOCKS_PER_SEC);
	printf("                   %16s: %08" PRIuHICLOCK " @ %" PRIu32 "Hz\n", fix_func_str, fix_duration, HICLOCKS_PER_SEC);
	printf("      Difference: %08" PRIiHICLOCK " (% 3.2f%%)\n", (flt_duration - fix_duration), ((fix_duration * 100.0) / flt_duration));
	printf("                              Error: %f%%\n", ((fix16_to_dbl(fix_error) * 100.0) / (args * pass)));

	return EXIT_SUCCESS;
}
