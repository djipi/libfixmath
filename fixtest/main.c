#include "hiclock.h"
#include <inttypes.h>
#include "fix_args.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//#define ACOS
//#define ATAN
//#define ATAN2
//#define CEIL
//#define COS
#define EXP				// Difference between Visual Studio and GNU libm in case of inf. (0x7f800000 vs. 0x3f800000)
//#define FLOOR
//#define MOD
//#define SIN
//#define SQRT
//#define TAN

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

#define args 256		// number of generated random values (max 256)
#define iter 1		// number of iteration loop on the desired function (exp, atan, etc.) using the random values
#define pass 1		// number of pass on the iteration loops

#ifndef FIXTEST_NO_GENARGS
fix16_t fix_args[args];
#endif
fix16_t fix_result[args];
float flt_args[args], flt_result[args];

int main(int argc, char **argv)
{
	hiclock_t fix_start = 0, fix_end = 0, fix_duration = 0;
	hiclock_t flt_start = 0, flt_end = 0, flt_duration = 0;
	fix16_t fix_error = 0;
	uintptr_t i, j, k;

#ifndef FIXTEST_NO_PRINT
	printf("libfixmath test tool\n");
#endif
	hiclock_init();

	srand(time(NULL));

	for (k = 0; k < pass; k++)
	{
#ifndef FIXTEST_NO_GENARGS
		for (i = 0; i < args; i++) { fix_args[i] = (fix16_t)(rand() ^ (rand() << 16)); }
#endif
		for (i = 0; i < args; i++) { flt_args[i] = fix16_to_float(fix_args[i]); }

		fix_start = hiclock();
		for (i = 0; i < iter; i++)
		{
			for (j = 0; j < args; j++) { fix_result[j] = fix_func(fix_args[j]); }
		}
		fix_end = hiclock();

		flt_start = hiclock();
		for (i = 0; i < iter; i++)
		{
			for (j = 0; j < args; j++) { flt_result[j] = flt_func(flt_args[j]); }
		}
		flt_end = hiclock();

		for (i = 0; i < args; i++) { fix_error += abs(fix16_from_float(flt_result[i]) - fix_result[i]); }
		flt_duration += (flt_end - flt_start);
		fix_duration += (fix_end - fix_start);
	}

#ifndef FIXTEST_NO_PRINT
	printf("                   %16s: %08" PRIuHICLOCK " @ %" PRIu32 "Hz\n", flt_func_str, flt_duration, HICLOCKS_PER_SEC);
	printf("                   %16s: %08" PRIuHICLOCK " @ %" PRIu32 "Hz\n", fix_func_str, fix_duration, HICLOCKS_PER_SEC);
	printf("Duration difference (float - fix16): %08" PRIiHICLOCK " (% 3.2f%%)\n", (flt_duration - fix_duration), ((fix_duration * 100.0) / flt_duration));
	printf("                              Error: %f%%\n", ((fix16_to_dbl(fix_error) * 100.0) / (args * pass)));
#else
	i = (fix16_to_dbl(fix_error) * 100.0) / (args * pass);
	while (1);
#endif
	return EXIT_SUCCESS;
}
