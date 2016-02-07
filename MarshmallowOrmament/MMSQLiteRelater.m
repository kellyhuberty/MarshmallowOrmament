//
//  MMSQLiteRelationship.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 6/16/15.
//  Copyright (c) 2015 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteRelater.h"
#import "MMEntity.h"
@implementation MMSQLiteRelater

-(id)init{
    
    if (self = [super init]) {
        
        _joins = [[MMSet alloc]init];

        
    }
    
    return self;
    
}

-(MMSQLiteRelater *)initWithRecordEntity:(MMEntity *)recordEntity relatedEntity:(MMEntity *)relatedEntity foreignKeyName:(NSString *)foreignKeyColumnName withRelatorOptions:(MMSQLiteRelaterKeyOptions)keyOptions andMutationOptions:(MMSQLiteRelaterMutationOptions)mutationOptions{
    self = [super init];
    
    _recordEntity = recordEntity;
    _relatedEntity = relatedEntity;
    _foreignKeyColumnName = foreignKeyColumnName;
    _mutationOptions = mutationOptions;
    
    return self;
}

+(MMSQLiteRelater *)relaterWithRecordEntity:(MMEntity *)recordEntity relatedEntity:(MMEntity *)relatedEntity ForeignKeyName:(NSString *)foreignKeyColumnName onEntity:(MMSQLiteRelaterKeyOptions)keyOptions andMutationOptions:(MMSQLiteRelaterMutationOptions)mutationOptions{
    
    MMSQLiteRelater * rel = [[self alloc]initWithRecordEntity:recordEntity
                                                relatedEntity:relatedEntity
                                               foreignKeyName:foreignKeyColumnName
                                           withRelatorOptions:keyOptions
                                           andMutationOptions:mutationOptions];
    
    
    
    return rel;
    
}




-(NSString *)recordEntityName{
    return _relationship.localEntityName;
    
}

-(NSString *)recordEntityAttribute{
    if (_keyOptions == MMSQLiteForeignKeyOnTarget) {
        return _foreignKeyColumnName;
    }
    return [_recordEntity.idKeys objectAtIndex:0];
}


-(NSString *)intermediateTable{
    
    return nil;
}

-(NSString *)recordIntermediateAttribute{
    
    return nil;

}

-(NSString *)relatedIntermediateAttribute{
    
    return nil;

}



-(NSString *)relatedEntityName{
    return _relationship.relatedEntityName;

    
}

-(NSString *)relatedEntityAttribute{
    
    if (_keyOptions == MMSQLiteForeignKeyOnTarget) {
        return _foreignKeyColumnName;
    }
    return [_relatedEntity.idKeys objectAtIndex:0];
}




@end
