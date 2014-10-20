//
//  MMGroupDescriptor.h
//  Pods
//
//  Created by Kelly Huberty on 9/27/14.
//
//

#import <Foundation/Foundation.h>

typedef enum{
    MMGroupDescriptorFirstLetterAphabetical,
    MMGroupDescriptorDateDay,
    MMGroupDescriptorDateWeek,
    MMGroupDescriptorDateMonth,
    MMGroupDescriptorDateYear
}MMGroupDescriptorType;

@interface MMGroupDescriptor : NSObject{
    
    NSString * _key;
    
    
}
@property(nonatomic, retain)NSString * key;
//@property()

-(instancetype)initWithKey:(NSString *)key groupType:(MMGroupDescriptorType)type;

-(instancetype)initWithKey:(NSString *)key selector:(id (^)(id))groupingKeyForObject;

//-(id)groupIdentifierForObject:()

@end
