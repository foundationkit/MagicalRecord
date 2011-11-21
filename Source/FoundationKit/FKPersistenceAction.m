#import "FKPersistenceAction.h"

@implementation FKPersistenceAction

+ (void)persistData:(NSArray *)data 
         entityName:(NSString *)entityName
    dictionaryIDKey:(NSString *)dictionaryIDKey
      databaseIDKey:(NSString *)databaseIDKey
        updateBlock:(void(^)(id managedObject, NSDictionary *data, NSManagedObjectContext *localContext))updateBlock
         completion:(void(^)(void))callback {
    
    [MRCoreDataAction saveDataInBackgroundWithBlock:^(NSManagedObjectContext *localContext) {
        // get all IDs of the entities in the dictionary (new data)
        NSArray *entityIDs = [data valueForKey:dictionaryIDKey];
        
        if (entityIDs == nil) {
            entityIDs = [NSArray array];
        }
        
        // remove all entities that are not in the new data set
        [NSClassFromString(entityName) MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"NOT (%K IN %@)", databaseIDKey, entityIDs] inContext:localContext];
        
        // retreive all entities with one of these IDs in the database
        NSArray *entitiesAlreadyInDatabase = [NSClassFromString(entityName) MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"%K IN %@", databaseIDKey, entityIDs] inContext:localContext];
        
        // retreive only the new IDs that are not yet in the database by making a minusSet
        NSMutableSet *newEntityIDs = [NSMutableSet setWithArray:entityIDs];
        [newEntityIDs minusSet:[NSSet setWithArray:[entitiesAlreadyInDatabase valueForKey:databaseIDKey]]];
        
        
        // Update already present Entities
        for (id entityToUpdate in entitiesAlreadyInDatabase) {
            // get data-dictionary of entity to update
            NSDictionary *entityToUpdateDictionary = (NSDictionary *)[[data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", dictionaryIDKey, [entityToUpdate valueForKey:databaseIDKey]]] objectAtIndex:0];
            updateBlock(entityToUpdate, entityToUpdateDictionary, localContext);
        }
        
        // Insert new Entities
        for (NSString *newEntityID in newEntityIDs) {
            // get data-dictionary of new entity to insert
            NSDictionary *newEntityDictionary = (NSDictionary *)[[data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K = %@", dictionaryIDKey, newEntityID]] objectAtIndex:0];
            id newEntity = [NSClassFromString(entityName) createInContext:localContext];
            
            updateBlock(newEntity, newEntityDictionary, localContext);
        }
    } completion:callback];
}

@end
