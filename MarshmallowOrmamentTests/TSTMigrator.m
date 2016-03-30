//
//  TSTMigrator.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 1/18/16.
//  Copyright © 2016 Kelly Huberty. All rights reserved.
//

#import "TSTMigrator.h"
#import "MMServiceMigrationDelegate.h"
#import "MMSQLiteStore.h"

@interface TSTMigrator(){
    
    MMVersionString * _oldVersion;
    MMVersionString * _newVersion;
    
    MMSQLiteStore * _service;
    
}

@end


@implementation TSTMigrator


-(void)buildService:(MMService *)service schema:(MMSchema *)schema error:(NSError **)error {
    
    
    _service = (MMSQLiteStore *)service;
    _newVersion = schema.version;
    _oldVersion = [MMVersionString stringWithString:@"0.0.0"];
    [self runUpgrade];
    
}

-(void)upgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error{
    
    
    _service = (MMSQLiteStore *)service;
    _newVersion = newVersion;
    _oldVersion = oldVersion;
    
    //[self archiveStore];
    [self runUpgrade];
    //[self removeArchiveStore];
    
}

-(void)downgradeService:(MMService *)service schema:(MMSchema *)schema fromVersion:(MMVersionString *)oldVersion toVersion:(MMVersionString *)newVersion error:(NSError **)error{
    
}






-(void)runUpgrade{
    
    
    if ([_newVersion compareVersion:@"0.1"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1"] == NSOrderedSame) {

        [self runQuery:@"CREATE TABLE `note` (  `notebookId` INTEGER ,\
                             `identifier` INTEGER ,\
                             `created` TEXT ,\
                             `text` TEXT ,\
                             `latitude` REAL ,\
                             `longitude` REAL  ,\
                                PRIMARY KEY (identifier) ON CONFLICT ROLLBACK );"];
        [self runQuery:@"CREATE TABLE `notebook` (  `identifier` INTEGER ,\
                                 `title` TEXT ,\
                                 `description` TEXT  ,\
                                PRIMARY KEY (identifier) ON CONFLICT ROLLBACK );"];
        [self runQuery:@"CREATE TABLE `tag` (  `identifier` INTEGER ,\
                                 `title` TEXT ,\
                                 `description` TEXT  ,\
                                 PRIMARY KEY (identifier) ON CONFLICT ROLLBACK );"];
        [self runQuery:@"CREATE TABLE `tag_note` (  `identifier` INTEGER ,\
                             `tag_identifier` INTEGER ,\
                             `note_identifier` INTEGER ,\
                             PRIMARY KEY (identifier) ON CONFLICT ROLLBACK );"];
    }
    if ([_newVersion compareVersion:@"1.1"] == NSOrderedDescending || [_newVersion compareVersion:@"1.1"] == NSOrderedSame) {

        [self runQuery:@"CREATE TABLE `NotesInNotebook` (  `note__id` INTEGER ,\
         `notebook__id` INTEGER   );"];
        
        
    }
//    if ([_newVersion compareVersion:@"0.1.1"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.1"] == NSOrderedSame) {
//        NSLog(@"blah");
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN vehicle NUMERIC"];
//    }
//    if ([_newVersion compareVersion:@"0.1.2"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.2"] == NSOrderedSame) {
//        NSLog(@"blah");
//        
//        [self runQuery:@"DROP TABLE `fillup`"];
//        
//        
//        [self runQuery:@"CREATE TABLE `fillup` (date NUMERIC, odometerMiles NUMERIC, odometerKilometers NUMERIC, volumeGallons NUMERIC, volumeLiters NUMERIC)"];
//        
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN odometerMiles NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN odometerKilometers NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN volumeGallons NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN volumeLiters NUMERIC"];
//        
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.3"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.3"] == NSOrderedSame) {
//        NSLog(@"blah");
//        
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN odometerMiles NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN odometerKilometers NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN volumeGallons NUMERIC"];
//        //        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN volumeLiters NUMERIC"];
//        
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.4"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.4"] == NSOrderedSame) {
//        
//        
//        
//        [self runQuery:@"CREATE TABLE `fillup2` (autoId INTEGER PRIMARY KEY AUTOINCREMENT, date NUMERIC, odometerMiles NUMERIC, odometerKilometers NUMERIC, volumeGallons NUMERIC, volumeLiters NUMERIC)"];
//        
//        [self runQuery:@"INSERT INTO `fillup2` (date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters) SELECT date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters FROM `fillup`"];
//        
//        [self runQuery:@"DROP TABLE `fillup`"];
//        
//        [self runQuery:@"ALTER TABLE `fillup2` RENAME TO `fillup`"];
//        
//        
//        //    if ([_newVersion compareVersion:@"0.2"] == NSOrderedAscending) {
//        //
//        //    }
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.5"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.5"] == NSOrderedSame) {
//        
//        
//        
//        [self runQuery:@"CREATE TABLE `fillup2` (autoId INTEGER PRIMARY KEY AUTOINCREMENT, date NUMERIC, odometerMiles NUMERIC, odometerKilometers NUMERIC, volumeGallons NUMERIC, volumeLiters NUMERIC)"];
//        
//        [self runQuery:@"INSERT INTO `fillup2` (date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters) SELECT date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters FROM `fillup`"];
//        
//        [self runQuery:@"DROP TABLE `fillup`"];
//        
//        [self runQuery:@"ALTER TABLE `fillup2` RENAME TO `fillup`"];
//        
//        
//        //    if ([_newVersion compareVersion:@"0.2"] == NSOrderedAscending) {
//        //
//        //    }
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.6"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.6"] == NSOrderedSame) {
//        
//        
//        
//        [self runQuery:@"CREATE TABLE `vehicle` (autoId INTEGER PRIMARY KEY AUTOINCREMENT, nickname TEXT, make TEXT, model TEXT, year NUMERIC)"];
//        
//        //        [self runQuery:@"INSERT INTO `fillup2` (date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters) SELECT date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters FROM `fillup`"];
//        //
//        //        [self runQuery:@"DROP TABLE `fillup`"];
//        //
//        //        [self runQuery:@"ALTER TABLE `fillup2` RENAME TO `fillup`"];
//        
//        
//        //    if ([_newVersion compareVersion:@"0.2"] == NSOrderedAscending) {
//        //
//        //    }
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.7"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.7"] == NSOrderedSame) {
//        
//        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN uuid text"];
//        [self runQuery:@"ALTER TABLE `vehicle` ADD COLUMN uuid text"];
//        
//        //        [self runQuery:@"CREATE TABLE `vehicle` (autoId INTEGER PRIMARY KEY AUTOINCREMENT, nickname TEXT, make TEXT, model TEXT, year NUMERIC)"];
//        
//        //        [self runQuery:@"INSERT INTO `fillup2` (date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters) SELECT date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters FROM `fillup`"];
//        //
//        //        [self runQuery:@"DROP TABLE `fillup`"];
//        //
//        //        [self runQuery:@"ALTER TABLE `fillup2` RENAME TO `fillup`"];
//        
//        
//        //    if ([_newVersion compareVersion:@"0.2"] == NSOrderedAscending) {
//        //
//        //    }
//        
//    }
//    if ([_newVersion compareVersion:@"0.1.8"] == NSOrderedDescending || [_newVersion compareVersion:@"0.1.8"] == NSOrderedSame) {
//        
//        [self runQuery:@"ALTER TABLE `fillup` ADD COLUMN vehicleId NUMERIC"];
//        //[self runQuery:@"ALTER TABLE `vehicle` ADD COLUMN uuid text"];
//        
//        //        [self runQuery:@"CREATE TABLE `vehicle` (autoId INTEGER PRIMARY KEY AUTOINCREMENT, nickname TEXT, make TEXT, model TEXT, year NUMERIC)"];
//        
//        //        [self runQuery:@"INSERT INTO `fillup2` (date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters) SELECT date, odometerMiles, odometerKilometers, volumeGallons, volumeLiters FROM `fillup`"];
//        //
//        //        [self runQuery:@"DROP TABLE `fillup`"];
//        //
//        //        [self runQuery:@"ALTER TABLE `fillup2` RENAME TO `fillup`"];
//        
//        
//        //    if ([_newVersion compareVersion:@"0.2"] == NSOrderedAscending) {
//        //
//        //    }
//        
//    }
//    
    
}






-(BOOL)runQuery:(NSString *)query{
    
    __block BOOL result;
    NSLog(@"Running Query:%@", query);
    [_service.dbQueue inDatabase:^(FMDatabase *db) {
        
        result = [db executeUpdate:query];
        
        if (!result) {
            NSLog(@"Query Error: %@", [[db lastError] localizedDescription]);
        }
        
    }];
    
    return result;
}



@end