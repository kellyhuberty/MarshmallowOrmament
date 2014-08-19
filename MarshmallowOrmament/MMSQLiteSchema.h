//
//  MMSQLiteSchema.h
//  Marshmallow
//
//  Created by Kelly Huberty on 1/10/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSchema.h"


@interface MMSQLiteSchema : MMSchema{
    
        //NSString * databaseName;
    
    
    
}

-(NSString *)buildSql;
-(NSString *)destroySql;
-(NSString *)upgradeSql;

    //+(MMSQLiteSchema *)schemaWithEntities:(NS)
@end
