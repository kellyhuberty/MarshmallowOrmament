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
        
        _nullable = YES;
        
    }
    
    return self;
}

//-(id)initWithDictionary:(NSDictionary *)dict{
//    
//    self = [self init];
//    
//    
//    if (self) {
//        
//        //[self loadInstance];
//        [self loadDescriptionFromDictionary:dict];
//        
//        
//    }
//    
//    return self;
//    
//    
//    
//}

-(id)initWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName{
    
    self = [self init];
    
    
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
    
    self = [self init];
    
    
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

+(MMAttribute *)attributeWithProperty:(MMProperty *)property{
    return mmAutorelease([[MMAttribute alloc]initWithProperty:property]);

}

-(id)initWithProperty:(MMProperty *)property{
    
    
    if (self = [self init]) {
        
        NSError * error;
        [self loadFromProperty:property error:&error];
    }
    
    return self;
}

-(BOOL)loadFromDictionary:(NSDictionary *)dict error:(NSError **)error{
    
    _name = mmCopy([self verify:[dict objectForKey:@"name"] class:[NSString class] name:@"name"]);
    
    _displayName = mmCopy([self verify:[dict objectForKey:@"displayname"] class:[NSString class] name:@"displayname"]);
    
    _classname = mmCopy([self verify:[dict objectForKey:@"classname"] class:[NSString class] name:@"classname"]);
    
    _controlName = mmCopy([self verify:[dict objectForKey:@"controlname"] class:[NSString class] name:@"controlname"]);
    //_controlName = [dict objectForKey:@"controlname"];
    
    _controlProperty = mmCopy([self verify:[dict objectForKey:@"controlproperty"] class:[NSString class] name:@"controlproperty"]);
    //_controlProperty = [dict objectForKey:@"controlproperty"];
    
    _controlOptions = mmCopy([self verify:[dict objectForKey:@"controloptions"] class:[NSString class] name:@"controloptions"]);
    
    _storeOptions = mmCopy([self verify:[dict objectForKey:@"controloptions"] class:[NSString class] name:@"controloptions"]);
    //_controlOptions = [dict objectForKey:@"propertyname"];
    
    
    _defaultValue = mmCopy([self verify:[dict objectForKey:@"default"] class:[NSObject class] name:@"default"]);
    //_defaultValue = [dict objectForKey:@"default"];
    
    _primativeType = mmCopy([self verify:[dict objectForKey:@"primativetype"] class:[NSString class] name:@"primativetype"]);
    
    _primativeType = mmCopy([self verify:[dict objectForKey:@"primative"] class:[NSString class] name:@"primative"]);
    
    
    //_storeName = mmCopy((NSString *)[self verify:[dict objectForKey:@"storename"] class:[NSString class] name:@"storename"]);
    
    //_storeType = mmCopy([self verify:[dict objectForKey:@"storetype"] class:[NSString class] name:@"storetype"]);
    
    //[dict objectForKey:@"displayname"];
    if ([dict objectForKey:@"autoincrement"] ) {
        _autoincrement = [((NSNumber *) [self verify:[dict objectForKey:@"autoincrement"] class:[NSNumber class] name:@"autoincrement"]) boolValue];
    }
    
    if ([dict objectForKey:@"readonly"] ) {
        _readonly = [((NSNumber *) [self verify:[dict objectForKey:@"readonly"] class:[NSNumber class] name:@"readonly"]) boolValue];
    }
    
    if ([dict objectForKey:@"nullable"] ) {
        _nullable = [((NSNumber *) [self verify:[dict objectForKey:@"nullable"] class:[NSNumber class] name:@"nullable"]) boolValue];
    }
    
    if ([dict objectForKey:@"unique"] ) {
        _unique = [((NSNumber *) [self verify:[dict objectForKey:@"unique"] class:[NSNumber class] name:@"unique"]) boolValue];
    }
    
    return YES;
}


-(BOOL)loadFromProperty:(MMProperty *)prop error:(NSError **)error{
    
    _name = mmCopy(prop.name);
    
    _displayName = mmCopy(prop.displayName);
    
    _classname = mmCopy(prop.classname);
    
    _controlName = mmCopy(prop.controlName);
    //_controlName = [dict objectForKey:@"controlname"];
    
    _controlProperty = mmCopy(prop.controlProperty);
    //_controlProperty = [dict objectForKey:@"controlproperty"];
    
    _controlOptions = mmCopy(prop.controlOptions);
    
    //_storeOptions = mmCopy(prop.storeOptions);
    //_controlOptions = [dict objectForKey:@"propertyname"];
    
    
    _defaultValue = mmCopy(prop.defaultValue);
    //_defaultValue = [dict objectForKey:@"default"];
    
    _primativeType = mmCopy(prop.primativeType);
    
    //_primativeType = mmCopy([self verify:[dict objectForKey:@"primative"] class:[NSString class] name:@"primative"]);
    
    
    //_storeName = mmCopy((NSString *)[self verify:[dict objectForKey:@"storename"] class:[NSString class] name:@"storename"]);
    
    //_storeType = mmCopy([self verify:[dict objectForKey:@"storetype"] class:[NSString class] name:@"storetype"]);
    
    //[dict objectForKey:@"displayname"];
    //if ([dict objectForKey:@"autoincrement"] ) {
    
    
    _autoincrement = (prop.autoincrement);
    //}
    
    //if ([dict objectForKey:@"readonly"] ) {
        _readonly = prop.readonly;
    //}
    
    //if ([dict objectForKey:@"nullable"] ) {
        _nullable = (prop.nullable);
    //}
    
    //if ([dict objectForKey:@"unique"] ) {
        _unique = (prop.unique);
    //}
    
    return YES;
}



-(id)verify:(NSObject*)obj class:(Class)class name:(NSString *)name{
    
    MMLog(@"value:%@ class:%@ name:%@", obj, class, name);
    
    if (obj != nil){
        if (class != nil) {
            
            
            if ([obj isKindOfClass:class]) {
                
            }
            else{
                [NSException raise:@"MMInvalidArgumentException" format:@"Invalid class for attribute with name: %@. Object should be member of class %@. You should check your definition dictionary/plist to ensure that the attribute is defined correctly. ", name, NSStringFromClass(class)];
            }
        }
    }
    else{
        if ([name isEqualToString:@"name"] || [name isEqualToString:@"classname"]) {
            [NSException raise:@"MMInvalidArgumentException" format:@"No Setting for: %@"];
        }
    }
    
    return obj;
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
    MMLog(@"            classname:%@", _classname);
    MMLog(@"            controlname:%@", _controlName);
    MMLog(@"            controlproperty:%@", _controlProperty);
    MMLog(@"            control options:%@", _controlOptions);
    MMLog(@"            primative Type:%@", _primativeType);
    MMLog(@"            default val:%@", _defaultValue);
    //MMLog(@"            store name:%@", _storeName);
    //MMLog(@"            store type:%@", _storeType);
    
    
    
    
    NSString * _name;//the name of the data value as described the data
    NSString * _classname;//name for the class that we're getting
    NSString * _controlName;//the name of the controller class from UIKit or otherwise that displays the data
    NSString * _controlProperty;//name for the property on the class that we're getting the value for and validating with
    NSDictionary * _controlOptions;//Key-values for properties to set on the control to configure it properly for the attribute it is setting.
    NSString * _primativeType;//This must be defined if
    NSString * _defaultValue;//Default value expressed as a string
    
    //SQLLite stuff
    //NSString * _storeName;
    //NSString * _storeType;
    
    
}








@end
