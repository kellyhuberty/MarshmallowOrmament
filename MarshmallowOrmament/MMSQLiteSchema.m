//
//  MMSQLiteSchema.m
//  Marshmallow
//
//  Created by Kelly Huberty on 1/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMSQLiteSchema.h"
#import "MMEntity.h"
#import "MMAttribute.h"
#import "NSString+Marshmallow.h"
@interface MMSQLiteSchema()


+(NSString *)sqlTypeForClassName:(NSString *)className primativeType:(NSString *)primativeType;
+(NSString *)createSQLForAttribute:(MMAttribute *)attribute;
+(NSString *)createSQLForAttributes:(NSArray *)attributes; //entity:(MMEntity *)entity;
-(NSString *)createSQLForEntity:(MMEntity *)entity;


@end



@implementation MMSQLiteSchema


-(NSString *)buildSql{
 
    NSString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.entities){
        
        NSLog(@"buis");
        
        [fullSQL stringByAppendingString:[[self class] createSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}

-(NSString *)destroySql{
    
    NSString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.entities){
        
        [fullSQL stringByAppendingString:[[self class] dropSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}



-(NSString *)upgradeSql{
    
    NSString * fullSQL = [NSMutableString string];
    
    for(MMEntity * entity in self.entities){
        
        [fullSQL stringByAppendingString:[[self class] createSQLForEntity:entity]];
        
    }
    
    return fullSQL;
    
}


+(NSString *)createSQLForEntity:(MMEntity *)entity{
    
    return [NSString stringWithFormat:@"CREATE TABLE `%@` ( %@ %@ )", entity.storeName, [[self class] createSQLForAttributes: entity.attributes], [[self class] createSQLForConstraints:entity] ];
    
}

+(NSString *)dropSQLForEntity:(MMEntity *)entity{
    
    return [NSString stringWithFormat:@"DROP TABLE `%@`", entity.storeName];
    
}


+(NSString *)createSQLForAttributes:(NSArray *)attributes{
    
    //[NSString stringWithFormat:@" %@ %@ %@", attribute.name, attribute.type];
    
    //NSMutableString * sql = [NSMutableString stringWithString:@""];
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (MMAttribute * attribute in attributes) {
        [array addObject:[self createSQLForAttribute:attribute]];
    }
    
    return [NSString implode:array glue:@",\n"];
    
}


+(NSString *)createSQLForConstraints:(MMEntity *)entity{
    
    return [NSString stringWithFormat:@"PRIMARY KEY `%@` ON CONFLICT ROLLBACK", [entity.idKeys componentsJoinedByString:@"`, `"] ];
    
}


+(NSString *)createSQLForAttribute:(MMAttribute *)attribute{
    
    //return [NSString stringWithFormat:@" %@ %@", attribute.name, [[self class] sqlTypeForClassName:attribute.classname primativeType:attribute.primativeType] ];
    
    return [NSString stringWithFormat:@" %@ %@", attribute.name, [[self class] sqlTypeForClassName:attribute.classname primativeType:attribute.primativeType] ];
    
    
    
    
}


//+(NSString *)createSQLForEntity:(MMEntity *)entity{
//    
//    return [NSString stringWithFormat:@"CREATE TABLE `%@` ( %@ )", entity.tableName, [[self class] createSQLForAttributes: entity.attributes]];
//    
//}


+(NSString *)sqlTypeForClassName:(NSString *)className primativeType:(NSString *)primativeType{
    
    if ([NSClassFromString(className) isKindOfClass:NSClassFromString(@"NSString")]) {
        return @"TEXT";
    }
    if ([NSClassFromString(className) isKindOfClass:NSClassFromString(@"NSNumber")]) {
        if([primativeType isEqualToString:@"integer"] || [primativeType isEqualToString:@"int"]){
            return @"INTEGER";
        }
        if([primativeType isEqualToString:@"boolean"] || [primativeType isEqualToString:@"BOOL"]){
            return @"INTEGER (1)";
        }
        if([primativeType isEqualToString:@"float"] || [primativeType isEqualToString:@"double"] ){
            return @"REAL";
        }
    }
    if ([NSClassFromString(className) isKindOfClass:NSClassFromString(@"NSDate")]) {
        return @"TEXT";
    }
    
    return @"BLOB";

}










@end
