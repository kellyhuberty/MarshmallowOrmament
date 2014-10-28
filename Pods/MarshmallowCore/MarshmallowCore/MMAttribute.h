//
//  MMKeyValueDescriptor.h
//  BandIt
//
//  Created by Kelly Huberty on 8/6/12.
//
//

/**
 This just describes the data for the forms or records to be used with an MMStore.
 
 
 
 */





#import <Foundation/Foundation.h>

@interface MMAttribute : NSObject<NSCopying>{
    
    
    
    NSString * _displayName;//the name of the data from the perspective of the user, in the ui
    NSString * _name;//the name of the data value as described the data
    NSString * _classname;//name for the class that we're getting
    NSString * _controlName;//the name of the controller class from UIKit or otherwise that displays the data
    NSString * _controlProperty;//name for the property on the class that we're getting the value for and validating with
    NSDictionary * _controlOptions;//Key-values for properties to set on the control to configure it properly for the attribute it is setting.
    NSString * _primativeType;//This must be defined if
    NSString * _defaultValue;//Default value expressed as a string
    
    //SQLLite stuff
    NSString * _storeName;
    NSString * _storeType;
    
        //MMAttribute * _objectDescription;
    BOOL _strictCasting;
    //BOOL _isBool;
    
}
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * classname;
@property (nonatomic, retain) NSString * controlName;
@property (nonatomic, retain) NSString * controlProperty;
@property (nonatomic, copy) NSDictionary * controlOptions;
@property (nonatomic, retain) NSString * primativeType;

@property (nonatomic, retain)NSString * storeName;
@property (nonatomic, retain)NSString * storeType;
//@property (nonatomic, retain) NSString * defaultValue;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) id defaultValue;
@property (nonatomic) BOOL strictCasting;
//@property (nonatomic) BOOL isBool;

-(id)init;
-(id)initWithDictionary:(NSDictionary *)dict;
-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName enforcedClassName:(NSString *)aClassName;

-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName;
//-(void)loadDescriptionFromDictionary:(NSDictionary *)dict;
+(MMAttribute *)attributeWithDictionary:(NSDictionary *)dict;
+(MMAttribute *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName;
+(MMAttribute *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName controlPropertyName:(NSString *)propertyName controlOptions:(NSDictionary *)dictionary;

+(NSString *)defaultPropertyNameForDescriptor:(MMAttribute *)attr;
+(NSString *)defaultControlNameForDescriptor:(MMAttribute *)attr;

-(void)log;

- (id)copyWithZone:(NSZone *)zone;

typedef enum {
    MMKeyValueNumberControlTypeField,
    MMKeyValueNumberControlTypeStepper,
    MMKeyValueNumberControlTypeSwitch,
} MMKeyValueNumberControlType;

@end



