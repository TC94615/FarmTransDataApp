//
// Created by 李道政 on 14/11/6.
//

#import <Foundation/Foundation.h>


@interface Dao : NSObject

+ (id) sharedDao;

- (instancetype) initWithDatabaseName:(NSString *) databaseName;

- (void) createTable;

- (void) dropTable;

- (NSArray *) selectAll;

- (void) insert:(NSNumber *) shopId andJson:(NSDictionary *) shopArray;

@end