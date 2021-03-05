#import "Object.h"
#import "Clock.h"
#import "DebugPrinter.h"
#include <stdio.h>
#include </opt/devkitpro/libtonc/include/tonc_irq.h>


const int test_iters = 16192;


static int test_no_method_cache(id printer, id clk)
{
    [clk reset];

    int i;
    for (i = 0; i < test_iters; ++i) {
        // Just test a bunch of arbitrary calls, to measure dispatch overhead.
        [printer class];
    }

    int tics = [clk reset];


    char str[32];
    sprintf(str, "clk per send, no cache: %d\n", tics / test_iters);

    [printer putText: str];
}


static int test_with_method_cache(id printer, id clk)
{
    // create a method cache in the printer's class, to speed up msg sends.
    [[printer class] cache];
    [printer class]; // random call to prime the cache.

    [clk reset];

    int i;
    volatile int j = 0;
    for (i = 0; i < test_iters; ++i) {
        // Just test a bunch of arbitrary calls, to measure dispatch overhead.
        [printer class];
    }

    int tics = [clk reset];


    char str[32];
    sprintf(str, "clk per send, mtd cache: %d\n", tics / test_iters);

    [printer putText: str];
}


void __attribute__ ((noinline)) control()
{
}


static int test_control_1(id printer, id clk)
{
    [clk reset];

    int i;
    for (i = 0; i < test_iters; ++i) {
        control();
    }

    int tics = [clk reset];

    char str[32];
    sprintf(str, "clk per noinline C fn: %d\n", tics / test_iters);

    [printer putText: str];
}


int main()
{
    irq_init(NULL);
    irq_add(II_VBLANK, NULL);

    id printer = [[DebugPrinter alloc] init];

    id clk = [[HardwareClock alloc] init];


    test_no_method_cache(printer, clk);

    test_with_method_cache(printer, clk);


    [printer putText: "\nFor reference:\n\n"];

    test_control_1(printer, clk);

    [printer release];

    return 0;
}
