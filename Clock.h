#import "Object.h"


@interface HardwareClock : Object
{
    BOOL init_;
}

// + (id) alloc;

+ (id) instance;

- (id) init;

- (void) release;

- (int) reset;

@end
