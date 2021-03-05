#import "Object.h"


@interface DebugPrinter : Object
{
}

- (id) init;

- (void) putText: (const char*) str;

@end
