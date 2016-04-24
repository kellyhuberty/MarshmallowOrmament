//
//  MMSQLiteRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/16/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteRelater.h"
#import "MMEntity.h"
#import "MMRecord.h"

@implementation MMSQLiteRelater

-(id)init{
    
    if (self = [super init]) {
        
        _joins = [[MMSet alloc]init];

        
    }
    
    return self;
    
}

-(MMSQLiteRelater *)initWithForeignKeyName:(NSString *)foreignKeyColumnName withRelatorOptions:(MMSQLiteRelaterKeyOptions)keyOptions andMutationOptions:(MMSQLiteRelaterMutationOptions)mutationOptions{
    self = [super init];

    _foreignKeyColumnName = foreignKeyColumnName;
    _mutationOptions = mutationOptions;
    _keyOptions = keyOptions;
    
    return self;
}

+(MMSQLiteRelater *)relaterWithForeignKeyName:(NSString *)foreignKeyColumnName onEntity:(MMSQLiteRelaterKeyOptions)keyOptions andMutationOptions:(MMSQLiteRelaterMutationOptions)mutationOptions{
    
    MMSQLiteRelater * rel = [[self alloc]initWithForeignKeyName:foreignKeyColumnName
                                           withRelatorOptions:keyOptions
                                           andMutationOptions:mutationOptions];
    
    
    
    return rel;
    
}

+(MMSQLiteRelater *)relaterWithIntermediateTableName:(NSString *)intermediateTableName
                                 localForeignKeyName:(NSString *)localForeignKeyColumnName
                               relatedForeignKeyName:(NSString *)relatedForeignKeyName{
    
    MMSQLiteRelater * rel = [[self alloc]initWithIntermediateTableName:intermediateTableName
                                                   localForeignKeyName:localForeignKeyColumnName
                                                 relatedForeignKeyName:relatedForeignKeyName];
    
    
    
    return rel;
    
}

-(MMSQLiteRelater *)initWithIntermediateTableName:(NSString *)intermediateTableName
                              localForeignKeyName:(NSString *)localForeignKeyColumnName
                            relatedForeignKeyName:(NSString *)relatedForeignKeyName{
    
    self = [super init];
    
    _keyOptions = MMSQLiteForeignKeysOnIntermediate;
    _intermediateTableName = intermediateTableName;
    _recordIntermediateAttribute = localForeignKeyColumnName;
    _relatedIntermediateAttribute = relatedForeignKeyName;
    
    return self;
    
}

-(NSString *)recordEntityName{
    return _relationship.localEntityName;
    
}

-(NSString *)recordEntityAttribute{

    if (_keyOptions == MMSQLiteForeignKeyOnTarget) {
        NSParameterAssert(_foreignKeyColumnName);
        return _foreignKeyColumnName;
    }
    
    if([NSClassFromString(_relationship.localClassName) isSubclassOfClass:[MMRecord class]]){
        
        NSArray* idKeys = [[NSClassFromString(_relationship.localClassName) entity] idKeys];
        
        
        
        
        return [idKeys objectAtIndex:0];
    }else{
        
    }
    
    return nil;
}


-(NSString *)intermediateTable{
    
    return nil;
    
}

-(NSString *)recordIntermediateAttribute{
    
    return _recordIntermediateAttribute;

}

-(NSString *)relatedIntermediateAttribute{
    
    return _relatedIntermediateAttribute;

}



-(NSString *)relatedEntityName{
    
    return _relationship.relatedEntityName;

    
}

-(NSString *)relatedEntityAttribute{
    
    if (_keyOptions == MMSQLiteForeignKeyOnRelated) {
        return _foreignKeyColumnName;
    }
    
    if([NSClassFromString(_relationship.relatedClassName) isSubclassOfClass:[MMRecord class]]){
        return [[[NSClassFromString(_relationship.relatedClassName) entity] idKeys] objectAtIndex:0];
    }
    
    return nil;
}


-(NSString *)tableToUpdateName{
    
    if (self.keyOptions == MMSQLiteForeignKeyOnTarget) {
        return _relationship.localEntityName;
    }
    else if(self.keyOptions == MMSQLiteForeignKeyOnRelated){
        
        return [_relationship relatedEntityName];
        
    }
    else if ([self intermediateTable]) {
        return [self intermediateTable];
    }
    
    return nil;
    
}

-(NSString *)tableToUpdatePrimaryKeyColumnName{
    
    Class recordClass = nil;
    
    if (self.keyOptions == MMSQLiteForeignKeyOnTarget) {
        recordClass = [_relationship localClass];
    }
    else if(self.keyOptions == MMSQLiteForeignKeyOnRelated){
        recordClass = [_relationship relatedClass];
    }
    
    
    NSArray * idKeys = [recordClass idKeys];
    
    NSAssert([idKeys count] == 1, @"Number of ID keys must match in an SQL Relationship.");
    
    return idKeys[0];
    
}






@end
