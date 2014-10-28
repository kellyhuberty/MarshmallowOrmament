//
//  MMKeyValueDescriptor.m
//  BandIt
//
//  Created by Kelly Huberty on 8/6/12.
//
//

#import "MMUtility.h"
#import "MMAttribute.h"

@interface MMAttribute ()

-(void)loadDescriptionFromDictionary:(NSDictionary *)dict;
-(void)loadInstance;

@end

@implementation MMAttribute

@synthesize displayName = _displayName;
@synthesize name = _name;
@synthesize classname = _classname;
@synthesize controlName = _controlName;
@synthesize controlProperty = _controlProperty;
@synthesize defaultValue = _defaultValue;
@synthesize strictCasting = _strictCasting;
@synthesize primativeType = _primativeType;

    //@synthesize isBool = _isBool;

//static NSDictionary * dict;


#pragma mark dealloc
- (void)dealloc
{
    
    mmRelease(_displayName);
    mmRelease(_name);
    mmRelease(_classname);
    mmRelease(_controlName);
    mmRelease(_controlProperty);
    mmRelease(_controlOptions);
    mmRelease(_primativeType);
    mmRelease(_defaultValue);
    #if __has_feature(objc_arc)
    #else
    [super dealloc];
    #endif
}

#pragma mark Init
-(id)init{
    self = [super init];
    
    
    if (self) {
        
        [self loadInstance];

    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    
    if (self) {
        
        [self loadInstance];
        [self loadDescriptionFromDictionary:dict];
        
        
    }
    
    return self;
    

    
}

-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName{
    
    self = [super init];
    
    
    if (self) {
        
        //[self loadInstance];
        
        
        _name = aName;
        if (_name == nil) {
            
            NSException* e = [NSException
                              exceptionWithName:@"UndefinedForDescriptorNameException"
                              reason:@"The name value in a MMStore "
                              userInfo:nil];
            @throw e;
        }
        
        
        
        _displayName = aDisplayName;
        if (_displayName == nil) {
            _displayName = [NSString stringWithString:_name];
        }
        _controlName = controlClassName;
        _classname = aClassName;
        
        
        
        //Pretty Self Explainitory Here, if you define a string of a class name in the runtime, the attribute will deafult to strict casting.
        //If you don't it wont;
        if (_classname == nil) {
            _strictCasting = NO;
        }
        else{
            _strictCasting = YES;
        }
        /*
         NSLog(@"OK");
         
         NSLog(@"%@",_name);        NSLog(@"OK");
         
         NSLog(@"%@",_displayname);        NSLog(@"OK");
         
         NSLog(@"%@",_classname);        NSLog(@"OK");
         */
        
        
        
        
    }
    
    return self;
    
    
}


-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName controlPropertyName:(NSString *)propertyName controlOptions:(NSDictionary *)options{
    
    self = [super init];
    
    
    if (self) {
        
        //[self loadInstance];
        
        
        _name = aName;
        if (_name == nil) {
            
            NSException* e = [NSException
                              exceptionWithName:@"UndefinedForDescriptorNameException"
                              reason:@"The name value in a MMStore "
                              userInfo:nil];
            @throw e;
        }
        
        
        
        _displayName = aDisplayName;
        if (_displayName == nil) {
            _displayName = [NSString stringWithString:_name];
        }
        _controlName = controlClassName;
        //_classname = aClassName;
        
        
        _controlProperty = mmRetain(propertyName);
        
        _controlOptions = [[NSMutableDictionary alloc]initWithDictionary:options];

        
    }
    
    return self;
    
    
}


+(MMAttribute *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName{
    
    return (MMAttribute *)mmAutorelease([[MMAttribute alloc] initWithName:aName displayName:aDisplayName controlClassName:controlClassName enforcedClassName:aClassName]);
    
}


+(MMAttribute *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName controlPropertyName:(NSString *)propertyName controlOptions:(NSDictionary *)dictionary{
    
     MMAttribute * attr = mmAutorelease([[MMAttribute alloc] initWithName:aName displayName:aDisplayName controlClassName:controlClassName controlPropertyName:propertyName controlOptions:dictionary]);
    
    
    return attr;
    
}


-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName enforcedClassName:(NSString *)aClassName
{
    
    self = [super init];
    
    
    if (self) {
        
        //[self loadInstance];

        
        _name = aName;
        if (_name == nil) {
            
            NSException* e = [NSException
                                        exceptionWithName:@"UndefinedForDescriptorNameException"
                                        reason:@"The name value in a MMStore "
                                        userInfo:nil];
            @throw e;
        }
        
        
        
        _displayName = aDisplayName;
        if (_displayName == nil) {
            _displayName = [NSString stringWithString:_name];
        }
        
        _classname = aClassName;
      
        
        
        //Pretty Self Explainitory Here, if you define a string of a class name in the runtime, the attribute will deafult to strict casting.
        //If you don't it wont;
        if (_classname == nil) {
            _strictCasting = NO;
        }
        else{
            _strictCasting = YES;
        }
        /*
        NSLog(@"OK");

        NSLog(@"%@",_name);        NSLog(@"OK");

        NSLog(@"%@",_displayname);        NSLog(@"OK");

        NSLog(@"%@",_classname);        NSLog(@"OK");
         */

        
        
        
    }
    
    return self;
}


+(MMAttribute *)attributeWithDictionary:(NSDictionary *)dict
{
    return mmAutorelease([[MMAttribute alloc]initWithDictionary:dict]);
}



-(void)loadDescriptionFromDictionary:(NSDictionary *)dict{

    
    _name = mmCopy([self verify:[dict objectForKey:@"name"] class:[NSString class] name:@"name"]);
    
    _displayName = mmCopy([self verify:[dict objectForKey:@"displayname"] class:[NSString class] name:@"displayname"]);
    
    _classname = mmCopy([self verify:[dict objectForKey:@"classname"] class:[NSString class] name:@"classname"]);
    
    _controlName = mmCopy([self verify:[dict objectForKey:@"controlname"] class:[NSString class] name:@"controlname"]);
    //_controlName = [dict objectForKey:@"controlname"];
    
    _controlProperty = mmCopy([self verify:[dict objectForKey:@"controlproperty"] class:[NSString class] name:@"controlproperty"]);
    //_controlProperty = [dict objectForKey:@"controlproperty"];
    
    _controlOptions = mmCopy([self verify:[dict objectForKey:@"controloptions"] class:[NSString class] name:@"controloptions"]);
    //_controlOptions = [dict objectForKey:@"propertyname"];
    

    _defaultValue = mmCopy([self verify:[dict objectForKey:@"default"] class:[NSString class] name:@"default"]);
    //_defaultValue = [dict objectForKey:@"default"];
    
    _primativeType = mmCopy([self verify:[dict objectForKey:@"primativetype"] class:[NSString class] name:@"primativetype"]);

    _storeName = mmCopy((NSString *)[self verify:[dict objectForKey:@"storename"] class:[NSString class] name:@"storename"]);
    
    _storeType = mmCopy([self verify:[dict objectForKey:@"storetype"] class:[NSString class] name:@"storetype"]);

        //[dict objectForKey:@"displayname"];
}

-(id)verify:(NSObject*)obj class:(Class)class name:(NSString *)name{
    
    MMLog(@"value:%@ class:%@ name:%@", obj, class, name);
    
    if (obj != nil){
        if (class != nil) {
            
        
            if ([obj isKindOfClass:class]) {
                
            }
            else{
                [NSException raise:@"MMInvalidArgumentException" format:@"Invalid class for attribute: %@"];
            }
        }
    }
    else{
        if ([name isEqualToString:@"name"] || [name isEqualToString:@"classname"]) {
            [NSException raise:@"MMInvalidArgumentException" format:@"No Setting for: %@"];
        }
    }
    
    return mmRetain(obj);
}


-(void)loadInstance{
    
    
    
}

-(NSString *)controlName{
    if(_controlName == nil || [_controlName isEqualToString:@""]){
        return [MMAttribute defaultControlNameForDescriptor:self];
    }
    
    return _controlName;
}

-(NSString *)controlProperty{
    
    if(_controlProperty == nil || [_controlProperty isEqualToString:@""]){
        return [MMAttribute defaultPropertyNameForDescriptor:self];
    }
    
    return _controlProperty;
}

+(NSString *)defaultPropertyNameForDescriptor:(MMAttribute *)attr{
    
    return nil;
}

+(NSString *)defaultControlNameForDescriptor:(MMAttribute *)attr{
    
    return nil;
}

//
//+(NSString *)defaultControlNameForDescriptor:(MMAttribute *)descriptor{
// //   return [MMControlMap controlNameForDescriptor:descriptor];
//}
//
//
//+(NSString *)defaultPropertyNameForDescriptor:(MMAttribute *)descriptor{
//  //  return [MMControlMap propertyNameForDescriptor:descriptor];
//}


-(NSObject *)defaultValue{
    
    
    return nil;
    
    
}



#pragma mark NSCopying Protocol Methods
//- (id)copyWithZone:(NSZone *)zone{
//    
//    
//    
//    
//}


-(void)log{
    
    
    MMLog(@"            name:%@", _name);
    MMLog(@"            displayname:%@", _displayName);
    MMLog(@"            controlname:%@", _controlName);
    MMLog(@"            controlproperty:%@", _controlProperty);
    MMLog(@"            control options:%@", _controlOptions);
    MMLog(@"            primative Type:%@", _primativeType);
    MMLog(@"            default val:%@", _defaultValue);
    MMLog(@"            store name:%@", _storeName);
    MMLog(@"            store type:%@", _storeType);
    
    
    
    
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
    
    
}








@end
