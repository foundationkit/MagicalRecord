// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This class adds high-level persitence methods to FoundationKit's Fork of MagicalRecord
 */
@interface FKPersistenceAction : NSObject

/**
 This method persists an Array of Dictionaries in Core Data in the background.
 
 @param data an array of data, containing one NSDictionary for each entity
 @param entityName The name of the corresponding Core Data model-class
 @param dictionaryIDKey the name of the key for the unique ID in the dictionary of the element data
 @param databaseIDKey the name of the key for a unique ID of the entity with the given name in CoreData
 @param updateBlock the block that gets executed each time to update the given managedObject that was either
                    already persistent or newly created
 @param completion the block that gets executed when everything is finished
 */
+ (void)persistData:(NSArray *)data 
         entityName:(NSString *)entityName
    dictionaryIDKey:(NSString *)dictionaryIDKey
      databaseIDKey:(NSString *)databaseIDKey
        updateBlock:(void(^)(id managedObject, NSDictionary *data, NSManagedObjectContext *localContext))updateBlock
         completion:(void(^)(void))callback;

@end
