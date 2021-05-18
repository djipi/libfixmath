#include "tests_basic.h"
#include "tests.h"

int test_abs_short(void)
{
	fix16_t a, result;
	double fa, fresult, min;
    unsigned int i;

    for (i = 0; i < TESTCASES_COUNT; ++i)
    {
        a      = testcases[i];
        fa      = fix16_to_dbl(a);
        result = fix16_abs(a);
        fresult = fabs(fa);
        min     = fix16_to_dbl(fix16_minimum);
        if (fa <= min)
        {
#ifndef FIXMATH_NO_OVERFLOW
            ASSERT_EQ_INT(result, fix16_overflow);
#endif
        }
        else
        {
            ASSERT_NEAR_DOUBLE(fresult, fix16_to_dbl(result), fix16_to_dbl(fix16_eps), "in: %f", fa);
        }
    }
    return 0;
}

int test_abs(void)
{
    TEST(test_abs_short());
    return 0;
}

int test_add_short(void)
{
	fix16_t a, b, result;
	double fa, fb, fresult, max, min;
    unsigned int i, j;

    for (i = 0; i < TESTCASES_COUNT; ++i)
    {
        for (j = 0; j < TESTCASES_COUNT; ++j)
        {
            a      = testcases[i];
            b      = testcases[j];
            result = fix16_add(a, b);

            fa      = fix16_to_dbl(a);
            fb      = fix16_to_dbl(b);
            fresult = fa + fb;

            max = fix16_to_dbl(fix16_maximum);
            min = fix16_to_dbl(fix16_minimum);
            if (((fa + fb) > max) || ((fa + fb) < min))
            {
#ifndef FIXMATH_NO_OVERFLOW
                ASSERT_EQ_INT(result, fix16_overflow);
#endif
            }
            else
            {
                ASSERT_NEAR_DOUBLE(fresult, fix16_to_dbl(result), fix16_to_dbl(fix16_eps), "%f + %f", fa, fb);
            }
        }
    }
    return 0;
}

int test_add(void)
{
    TEST(test_add_short());
    return 0;
}

int test_mul_specific(void)
{
    ASSERT_EQ_INT(fix16_mul(fix16_from_int(5), fix16_from_int(5)), fix16_from_int(25));
    ASSERT_EQ_INT(fix16_mul(fix16_from_int(-5), fix16_from_int(5)), fix16_from_int(-25));
    ASSERT_EQ_INT(fix16_mul(fix16_from_int(-5), fix16_from_int(-5)), fix16_from_int(25));
    ASSERT_EQ_INT(fix16_mul(fix16_from_int(5), fix16_from_int(-5)), fix16_from_int(-25));

    ASSERT_EQ_INT(fix16_mul(0, 10), 0);
    ASSERT_EQ_INT(fix16_mul(2, 0x8000), 1);
    ASSERT_EQ_INT(fix16_mul(-2, 0x8000), -1);
#ifndef FIXMATH_NO_ROUNDING
    ASSERT_EQ_INT(fix16_mul(3, 0x8000), 2);
    ASSERT_EQ_INT(fix16_mul(2, 0x7FFF), 1);
    ASSERT_EQ_INT(fix16_mul(-2, 0x8001), -1);
    ASSERT_EQ_INT(fix16_mul(-3, 0x8000), -2);
    ASSERT_EQ_INT(fix16_mul(-2, 0x7FFF), -1);
    ASSERT_EQ_INT(fix16_mul(2, 0x8001), 1);
#endif
    return 0;
}

int test_mul_short()
{
	fix16_t a, b, result;
	double fa, fb, fresult, max, min;
    unsigned int i, j;

    for (i = 0; i < TESTCASES_COUNT; ++i)
    {
        for (j = 0; j < TESTCASES_COUNT; ++j)
        {
            a      = testcases[i];
            b      = testcases[j];
            result = fix16_mul(a, b);

            fa      = fix16_to_dbl(a);
            fb      = fix16_to_dbl(b);
            fresult = fa * fb;

            max = fix16_to_dbl(fix16_maximum);
            min = fix16_to_dbl(fix16_minimum);

            if (((fa * fb) > max) || ((fa * fb) < min))
            {
#ifndef FIXMATH_NO_OVERFLOW
                ASSERT_EQ_INT(result, fix16_overflow);
#endif
            }
            else
            {
                ASSERT_NEAR_DOUBLE(fresult, fix16_to_dbl(result), fix16_to_dbl(fix16_eps), "%f * %f", fa, fb);
            }
        }
    }
    return 0;
}

int test_mul(void)
{
    TEST(test_mul_specific());
    TEST(test_mul_short());
    return 0;
}

int test_div_specific()
{
    ASSERT_EQ_INT(fix16_div(fix16_from_int(15), fix16_from_int(5)), fix16_from_int(3));
    ASSERT_EQ_INT(fix16_div(fix16_from_int(-15), fix16_from_int(5)), fix16_from_int(-3));
    ASSERT_EQ_INT(fix16_div(fix16_from_int(-15), fix16_from_int(-5)), fix16_from_int(3));
    ASSERT_EQ_INT(fix16_div(fix16_from_int(15), fix16_from_int(-5)), fix16_from_int(-3));

#ifndef FIXMATH_NO_ROUNDING
    ASSERT_EQ_INT(fix16_div(0, 10), 0);
    ASSERT_EQ_INT(fix16_div(1, fix16_from_int(2)), 1);
    ASSERT_EQ_INT(fix16_div(-1, fix16_from_int(2)), -1);
    ASSERT_EQ_INT(fix16_div(1, fix16_from_int(-2)), -1);
    ASSERT_EQ_INT(fix16_div(-1, fix16_from_int(-2)), 1);
    ASSERT_EQ_INT(fix16_div(3, fix16_from_int(2)), 2);
    ASSERT_EQ_INT(fix16_div(-3, fix16_from_int(2)), -2);
    ASSERT_EQ_INT(fix16_div(3, fix16_from_int(-2)), -2);
    ASSERT_EQ_INT(fix16_div(-3, fix16_from_int(-2)), 2);
    ASSERT_EQ_INT(fix16_div(2, 0x7FFF), 4);
    ASSERT_EQ_INT(fix16_div(-2, 0x7FFF), -4);
    ASSERT_EQ_INT(fix16_div(2, 0x8001), 4);
    ASSERT_EQ_INT(fix16_div(-2, 0x8001), -4);
#endif

    return 0;
}

int test_div_short()
{
	fix16_t a, b, result;
	double fa, fb, fresult, max, min;
    unsigned int i, j;

    for (i = 0; i < TESTCASES_COUNT; ++i)
    {
        for (j = 0; j < TESTCASES_COUNT; ++j)
        {
            a = testcases[i];
            b = testcases[j];
            // We don't require a solution for /0 :)
            if (b == 0)
                continue;
            result = fix16_div(a, b);

            fa      = fix16_to_dbl(a);
            fb      = fix16_to_dbl(b);
            fresult = fa / fb;

            max = fix16_to_dbl(fix16_maximum);
            min = fix16_to_dbl(fix16_minimum);

            if (((fa / fb) > max) || ((fa / fb) < min))
            {
#ifndef FIXMATH_NO_OVERFLOW
                ASSERT_EQ_INT(result, fix16_overflow);
#endif
            }
            else
            {
                ASSERT_NEAR_DOUBLE(fresult, fix16_to_dbl(result), fix16_to_dbl(fix16_eps), "%i / %i \n", a, b);
            }
        }
    }
    return 0;
}

int test_div(void)
{
    TEST(test_div_specific());
    TEST(test_div_short());
    return 0;
}

int test_sub_short()
{
	fix16_t a, b, result;
	double fa, fb, fresult, max, min;
    unsigned int i, j;

    for (i = 0; i < TESTCASES_COUNT; ++i)
    {
        for (j = 0; j < TESTCASES_COUNT; ++j)
        {
            a      = testcases[i];
            b      = testcases[j];
            result = fix16_sub(a, b);

            fa      = fix16_to_dbl(a);
            fb      = fix16_to_dbl(b);
            fresult = fa - fb;

            max = fix16_to_dbl(fix16_maximum);
            min = fix16_to_dbl(fix16_minimum);
            if ((fa - fb > max) || (fa - fb < min))
            {
#ifndef FIXMATH_NO_OVERFLOW
                ASSERT_EQ_INT(result, fix16_overflow);
#endif
            }
            else
            {
                ASSERT_NEAR_DOUBLE(fresult, fix16_to_dbl(result), fix16_to_dbl(fix16_eps), "%f - %f", fa, fb);
            }
        }
    }
    return 0;
}

int test_sub()
{
    TEST(test_sub_short());
    return 0;
}
