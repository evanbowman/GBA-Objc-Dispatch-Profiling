#import "DebugPrinter.h"
#include </opt/devkitpro/libtonc/include/tonc_tte.h>
#include </opt/devkitpro/libtonc/include/tonc_video.h>


@implementation DebugPrinter

- (id) init
{
    [super init];

    REG_DISPCNT = DCNT_MODE0 | DCNT_BG0;

    tte_init_se(
        0,
        BG_CBB(0)|BG_SBB(31),
        0,
        CLR_YELLOW,
        14,
        NULL,
        NULL);

    pal_bg_bank[1][15]= CLR_RED;
    pal_bg_bank[2][15]= CLR_GREEN;
    pal_bg_bank[3][15]= CLR_BLUE;
    pal_bg_bank[4][15]= CLR_WHITE;
    pal_bg_bank[5][15]= CLR_MAG;
    pal_bg_bank[4][14]= CLR_GRAY;

    return self;
}


- (void) putText: (const char*) str
{
    tte_write(str);
}

@end
