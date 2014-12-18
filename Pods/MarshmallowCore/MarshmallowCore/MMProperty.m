//
//  MMKeyValueDescriptor.m
//  BandIt
//
//  Created by Kelly Huberty on 8/6/12.
//
//

#import "MMUtility.h"
#import "MMProperty.h"
#import <objc/runtime.h>


//NSString * classPropertyType(Class controlClass, NSString * propertyName){
//    
//    NSString * returnType;
//    
//    //MMLog(@"FUCK!");
//    // MMLog(@"%@, %@", NSStringFromClass(controlClass), propertyName);
//    
//    
//    
//    NSLog(@"prop name....%@", propertyName);
//    NSLog(@"classname....%@", NSStringFromClass(controlClass));
//    
//    
//    objc_property_t theProperty = class_getProperty(controlClass, [propertyName UTF8String]);
//    MMLog(@"%@", theProperty);
//    
//    char * propertyAttrs = property_getAttributes(theProperty);
//    //MMLog(@"FUCK!");
//    
//    //NSString *unfilteredStr = [NSString stringWithCharacters:propertyAttrs length:sizeof(propertyAttrs)];
//    NSString *unfilteredStr = [NSString stringWithUTF8String:propertyAttrs];
//    
//    // MMLog(@"%@", unfilteredStr);
//    
//    
//    //NSRange startRange = [unfilteredStr rangeOfString:@"@\""];
//    //NSRange endRange = [unfilteredStr rangeOfString:@"\","];
//    //NSRange filter = NSMakeRange(startRange.location + startRange.length , endRange.location - startRange.location - 1);
//    
//    
//    NSString * typeStr = [[unfilteredStr componentsSeparatedByString:@","]objectAtIndex:0];
//    
//    //MMLog(@"%@", typeStr);
//    NSString * semifilteredStr1 = [typeStr stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
//    // MMLog(@"%@", semifilteredStr1);
//    
//    
//    NSString * semifilteredStr2 = [semifilteredStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    // MMLog(@"%@", semifilteredStr2);
//    
//    if( NSClassFromString(semifilteredStr2) ){
//        returnType = semifilteredStr2;
//    }
//    else{
//        
//        NSString * check = [semifilteredStr2 substringWithRange:NSMakeRange(1, [semifilteredStr2 length]-1)];
//        
//        
//        // MMLog(@"%@", check);
//        const char * ccheck = [check UTF8String];
//        
//        if (strcmp(ccheck, @encode(int)) == 0) {
//            returnType = @"int";
//        }
//        if (strcmp(ccheck, @encode(float)) == 0) {
//            returnType = @"float";
//        }
//        if (strcmp(ccheck, @encode(double)) == 0) {
//            returnType = @"double";
//        }
//        if (strcmp(ccheck, @encode(long)) == 0) {
//            returnType = @"long";
//        }
//        if (strcmp(ccheck, @encode(short)) == 0) {
//            returnType = @"short";
//        }
//        if (strcmp(ccheck, @encode(char)) == 0) {
//            returnType = @"char";
//        }
//        if (strcmp(ccheck, @encode(BOOL)) == 0) {
//            returnType = @"BOOL";
//        }
//        
//    }
//    
//    MMLog(@"%@", returnType);
//    
//    return returnType;
//}


@interface MMProperty ()

-(void)loadDescriptionFromDictionary:(NSDictionary *)dict;
-(void)loadInstance;

@end

@implementation MMProperty

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

-(id)initWithDictionary:(NSDictionary *)dict{
    
    self = [self init];
    
    
    if (self) {
        
        //[self loadInstance];
        [self loadDescriptionFromDictionary:dict];
        
        
    }
    
    return self;
    

    
}


-(id)initWithPropertyNamed:(NSString *)propertyName onClass:(Class)aClass {
    
    
    objc_property_t theProperty = class_getProperty(aClass, [propertyName UTF8String]);
    MMLog(@"%@", theProperty);
    
    char * propertyAttrs = property_getAttributes(theProperty);
        //MMLog(@"FUCK!");
    
        //NSString *unfilteredStr = [NSString stringWithCharacters:propertyAttrs length:sizeof(propertyAttrs)];
    NSString *unfilteredStr = [NSString stringWithUTF8String:propertyAttrs];
    
    if (self = [self init]) {
        
        [self parseAttributesString:unfilteredStr];
        
         _name = [[NSString alloc]initWithUTF8String:property_getName(theProperty)];
        
    }
    
    return self;

}

+(instancetype)propertyWithName:(NSString *)name onClass:(Class)aClass {
    
    MMProperty * prop = [[self alloc]initWithPropertyNamed:name onClass:aClass];
    
    mmAutorelease(prop);
    
    return prop;
    
}

+(NSArray *)propertiesOnClass:(Class)aClass {
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    NSMutableArray * blah = [NSMutableArray array];
    
    for (int i = 0; i < count; ++i) {
     
        objc_property_t property = properties[i];

        //[blah addObject: [self propertyWithAttributesString:[NSString stringWithUTF8String:property_getAttributes(property)] class:aClass]];
        
        [blah addObject: [self propertyWithName:[NSString stringWithUTF8String:property_getName(property)] onClass:aClass]];
        
    }
    
    return [NSArray arrayWithArray:blah];
}


//+(instancetype)propertyWithAttributesString:(NSString *)attrStr class:(Class)aClass {
//    
//    MMProperty * prop = [[self alloc]initWithAttributesString:attrStr class:aClass];
//    
//    mmAutorelease(prop);
//    
//    return prop;
//    
//}

//-(id)initWithAttributesString:(NSString *)propertyAttributesStr class:(Class)aClass {
//    
//    self = [self init];
//    
//    if (self) {
//        
//        [self parseAttributesString:propertyAttributesStr];
//        
//            //[self loadInstance];
//            //[self loadDescriptionFromDictionary:dict];
//        
//        
//    }
//    
//    return self;
//    
//}

-(void)parseAttributesString:(NSString *)attStr{
    
    NSLog(@"STR:%@", attStr);
    
    NSMutableArray * arr = [[attStr componentsSeparatedByString:@","] mutableCopy];
    
    NSString * typeStr = [arr objectAtIndex:0];
    NSString * ivarStr = [arr lastObject];

    [arr removeObjectAtIndex:0];
    [arr removeLastObject];
    
    
    [self parseEncodeString:typeStr];
    [self parseIvarString:ivarStr];
    [self parseTypeArray:arr];
    
    
}



-(void)parseEncodeString:(NSString *)attStr{
    
    NSMutableString * str = [attStr mutableCopy];
    
    // MMLog(@"%@", semifilteredStr1);
    
    if ([str containsString:@"\""]) {
        
        [str replaceOccurrencesOfString:@"T@\"" withString:@"" options:NSLiteralSearch range:NSRangeFromString(str)];
        
        [str replaceOccurrencesOfString:@"T@\"" withString:@"" options:NSLiteralSearch range:NSRangeFromString(str)];
        
        if (NSClassFromString(str)) {
            _classname = [NSString stringWithString:str];
            mmRetain(_classname);
        }
        else{
            _classname = nil;
        }
        
        
    }
    
    NSString * check = [attStr substringWithRange:NSMakeRange(1, [attStr length]-1)];
    
    // MMLog(@"%@", check);
    const char * ccheck = [check UTF8String];
    
    if (strcmp(ccheck, @encode(int)) == 0) {
        _primativeType = @"int";
    }
    if (strcmp(ccheck, @encode(float)) == 0) {
        _primativeType = @"float";
    }
    if (strcmp(ccheck, @encode(double)) == 0) {
        _primativeType = @"double";
    }
    if (strcmp(ccheck, @encode(long)) == 0) {
        _primativeType = @"long";
    }
    if (strcmp(ccheck, @encode(short)) == 0) {
        _primativeType = @"short";
    }
    if (strcmp(ccheck, @encode(char)) == 0) {
        _primativeType = @"char";
    }
    if (strcmp(ccheck, @encode(BOOL)) == 0) {
        _primativeType = @"BOOL";
    }
    if (strcmp(ccheck, @encode(id)) == 0) {
        _primativeType = @"id";
    }
    
    mmRetain(_primativeType);
    
}


-(void)parseIvarString:(NSString *)ivarStr{
    
    //NSString * str =[ivarStr mutableCopy]
    
    _name = [ivarStr substringFromIndex:1];
    
    mmRetain(_name);
    
}

-(void)parseTypeArray:(NSArray *)attArray{
    
    for (NSString * item in attArray) {
        
        if ([item isEqualToString:@"R"]) {
            _readonly = true;
        }
        if ([item isEqualToString:@"C"]) {
            //_readonly = true;
        }
        if ([item isEqualToString:@"&"]) {
            //_readonly = true;
            //retain
        }
        if ([item isEqualToString:@"N"]) {
            _nonatomic = true;
        }
        if ([item isEqualToString:@"D"]) {
            //@dynamic
        }
        if ([item isEqualToString:@"W"]) {
            //__weak
        }
        if ([item isEqualToString:@"P"]) {
            //Garbage collection
        }
        
    }
    
    
}


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


+(MMProperty *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName enforcedClassName:(NSString *)aClassName{
    
    return (MMProperty *)mmAutorelease([[MMProperty alloc] initWithName:aName displayName:aDisplayName controlClassName:controlClassName enforcedClassName:aClassName]);
    
}


+(MMProperty *)attributeWithName:(NSString *)aName displayName:(NSString *)aDisplayName controlClassName:(NSString *)controlClassName controlPropertyName:(NSString *)propertyName controlOptions:(NSDictionary *)dictionary{
    
     MMProperty * attr = mmAutorelease([[MMProperty alloc] initWithName:aName displayName:aDisplayName controlClassName:controlClassName controlPropertyName:propertyName controlOptions:dictionary]);
    
    
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


+(MMProperty *)attributeWithDictionary:(NSDictionary *)dict
{
    return mmAutorelease([[MMProperty alloc]initWithDictionary:dict]);
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
        return [MMProperty defaultControlNameForDescriptor:self];
    }
    
    return _controlName;
}

-(NSString *)controlProperty{
    
    if(_controlProperty == nil || [_controlProperty isEqualToString:@""]){
        return [MMProperty defaultPropertyNameForDescriptor:self];
    }
    
    return _controlProperty;
}

+(NSString *)defaultPropertyNameForDescriptor:(MMProperty *)attr{
    
    return nil;
}

+(NSString *)defaultControlNameForDescriptor:(MMProperty *)attr{
    
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



+(NSString *)typeStringWithPropertyAttributeString:(NSString *)unfilteredStr{
    
    //NSString *unfilteredStr = [NSString stringWithUTF8String:propertyAttrs];
    
    // MMLog(@"%@", unfilteredStr);
    
    NSString * returnType;
    //NSRange startRange = [unfilteredStr rangeOfString:@"@\""];
    //NSRange endRange = [unfilteredStr rangeOfString:@"\","];
    //NSRange filter = NSMakeRange(startRange.location + startRange.length , endRange.location - startRange.location - 1);
    
    
    NSString * typeStr = [[unfilteredStr componentsSeparatedByString:@","]objectAtIndex:0];
    
    //MMLog(@"%@", typeStr);
    NSString * semifilteredStr1 = [typeStr stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
    // MMLog(@"%@", semifilteredStr1);
    
    
    NSString * semifilteredStr2 = [semifilteredStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    // MMLog(@"%@", semifilteredStr2);
    
    if( NSClassFromString(semifilteredStr2) ){
        returnType = semifilteredStr2;
    }
    else{
        
        NSString * check = [semifilteredStr2 substringWithRange:NSMakeRange(1, [semifilteredStr2 length]-1)];
        
        
        // MMLog(@"%@", check);
        const char * ccheck = [check UTF8String];
        
        if (strcmp(ccheck, @encode(int)) == 0) {
            returnType = @"int";
        }
        if (strcmp(ccheck, @encode(float)) == 0) {
            returnType = @"float";
        }
        if (strcmp(ccheck, @encode(double)) == 0) {
            returnType = @"double";
        }
        if (strcmp(ccheck, @encode(long)) == 0) {
            returnType = @"long";
        }
        if (strcmp(ccheck, @encode(short)) == 0) {
            returnType = @"short";
        }
        if (strcmp(ccheck, @encode(char)) == 0) {
            returnType = @"char";
        }
        if (strcmp(ccheck, @encode(BOOL)) == 0) {
            returnType = @"BOOL";
        }
        
    }
    
    MMLog(@"%@", returnType);
    
    return returnType;
    
}




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
