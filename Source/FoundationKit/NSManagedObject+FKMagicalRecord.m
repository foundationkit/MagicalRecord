#import "NSManagedObject+FKMagicalRecord.h"
#import "CoreData+MagicalRecord.h"

@implementation NSManagedObject (FKMagicalRecord)

+ (id)existingOrNewObjectWithAttribute:(NSString *)attribute matchingValue:(id)value inContext:(NSManagedObjectContext *)context {
    id object = nil;
    
    if (value != nil) {
        object = [[self class] MR_findFirstByAttribute:attribute withValue:value inContext:context];
    }
    
    if (object == nil) {
        object = [[self class] MR_createInContext:context];
        [object setValue:value forKey:attribute];
    }
    
    return object;
}

+ (id)existingOrNewObjectWithAttribute:(NSString *)attribute matchingValue:(id)value {
    return [self existingOrNewObjectWithAttribute:attribute matchingValue:value inContext:[NSManagedObjectContext MR_defaultContext]];
}

@end
