#import "Clock.h"

 #include </opt/devkitpro/libtonc/include/tonc_irq.h>



static HardwareClock* hwClockSingleton;

// This tics var should really be a member of HardwareClock, but we shouldn't be
// doing objective-c message sends from a interrupt handler for a high-precision
// timer :)
static int timer3_tic_counter;


static void gba_timer3_isr()
{
    timer3_tic_counter += 0xffff;

    REG_TM3CNT_H = 0;
    REG_TM3CNT_L = 0;
    REG_TM3CNT_H = 1 << 7 | 1 << 6;
}



@implementation HardwareClock

+ (id) instance
{
    if (hwClockSingleton) {
        return hwClockSingleton;
    } else {
        hwClockSingleton = [super alloc];
        return hwClockSingleton;
    }
}


// + (id) alloc
// {
//     return nil;
// }


- (id) init
{
    if (self = [super init]) {
        init_ = YES;

        irq_add(II_TIMER3, gba_timer3_isr);
        REG_TM3CNT_L = 0;
        REG_TM3CNT_H = 1 << 7 | 1 << 6;
    }

    return self;
}


- (int) reset
{
    int result = timer3_tic_counter;

    timer3_tic_counter = 0;

    return result;
}


- (void) release
{
    // never release
}

@end
