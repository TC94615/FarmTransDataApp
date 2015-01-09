//
// Created by 李道政 on 14/11/6.
//

#import "Dao.h"
#import "FMDatabase.h"
#import "RowObject.h"

static NSString *const DATABASE_NAME = @"db.sqlite";


@interface Dao()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation Dao

+ (id) sharedDao {
    static Dao *sharedMyDao = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyDao = [[Dao alloc] initWithDatabaseName:DATABASE_NAME];
    });
    return sharedMyDao;
}

- (instancetype) initWithDatabaseName:(NSString *) databaseName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:databaseName];
    _database = [FMDatabase databaseWithPath:writableDBPath];
    [_database open];
    return self;
}

- (void) createTable {
    [self.database executeUpdate:@"CREATE TABLE FARM_TRANS_DATA "
      "(identifier INTEGER  PRIMARY KEY NOT NULL,"
      "json TEXT NOT NULL,"
      "insert_time INTEGER NOT NULL)"];

}

- (void) dropTable {
    [self.database executeUpdate:@"DROP SHOP"];
}

- (NSArray *) selectAll {
    NSMutableArray *result = [NSMutableArray array];

    FMResultSet *queried = [self.database executeQuery:@"SELECT * FROM TABLE FARM_TRANS_DATA ORDER BY insert_time"];
    while ([queried next]) {
        RowObject *rowObject = [[RowObject alloc] init];
        rowObject.id = @([queried intForColumnIndex:0]);
        rowObject.jsonString = [queried stringForColumnIndex:1];
        rowObject.insert_time = @([queried intForColumnIndex:2]);
        [result addObject:rowObject];
//        NSLog(@"id %@ | json %@ | insert time %@", rowObject.id, rowObject.jsonString, rowObject.insert_time);
//        NSLog(@"id %@ | json %@ | insert time %@", [result.lastObject id], [result.lastObject jsonString], [result.lastObject insert_time]);
    }

    return result;
}

- (void) insert:(NSNumber *) shopId andJson:(NSDictionary *) shopDic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:shopDic options:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSLog(@"INSERT INTO SHOP (identifier, json, insert_time) VALUES (%@, %@, %@)", shopId, jsonString, timestamp);
    [self.database executeUpdate:@"INSERT INTO SHOP (identifier, json, insert_time) VALUES (?, ?, ?)", shopId,
                                 jsonString, timestamp];

}

- (void) update:(NSNumber *) shopId andJson:(NSArray *) jsonArray {

}

- (void) delete:(NSNumber *) shopId {
    NSLog(@"Delete shop id = %@", shopId);
    [self.database executeUpdate:@"DELETE FROM SHOP WHERE identifier = ?", shopId];
}

- (void) deleteAll {
    [self.database executeUpdate:@"DELETE FROM SHOP"];
}
@end