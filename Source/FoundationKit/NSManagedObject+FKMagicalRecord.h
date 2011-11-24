// Part of FoundationKit http://foundationk.it

#import <CoreData/CoreData.h>

@interface NSManagedObject (FKMagicalRecord)

+ (id)existingOrNewObjectWithAttribute:(NSString *)attribute matchingValue:(id)value inContext:(NSManagedObjectContext *)context;
+ (id)existingOrNewObjectWithAttribute:(NSString *)attribute matchingValue:(id)value;

@end
