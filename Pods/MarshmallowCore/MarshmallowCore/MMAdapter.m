//
//  MMAdapter.m
//  BandIt
//
//  Created by Kelly Huberty on 10/10/12.
//
//

#import "MMUtility.h"
#import <objc/runtime.h>
#import "MMAdapter.h"



NSString * propertyClassNameForClassAndPropertyName(Class controlClass, NSString * propertyName){
    return classPropertyType(controlClass, propertyName);
}

NSString __weak * getPropertyTypeName(Class aClass, NSString * propertyName){
    return classPropertyType(aClass, propertyName);
}


NSString * classPropertyType(Class controlClass, NSString * propertyName){
    
    NSString * returnType;
    
    //MMLog(@"FUCK!");
    // MMLog(@"%@, %@", NSStringFromClass(controlClass), propertyName);
    
    
    
    NSLog(@"prop name....%@", propertyName);
    NSLog(@"classname....%@", NSStringFromClass(controlClass));

    
    objc_property_t theProperty = class_getProperty(controlClass, [propertyName UTF8String]);
    MMLog(@"%@", theProperty);
    
    char * propertyAttrs = property_getAttributes(theProperty);
    //MMLog(@"FUCK!");
    
    //NSString *unfilteredStr = [NSString stringWithCharacters:propertyAttrs length:sizeof(propertyAttrs)];
    NSString *unfilteredStr = [NSString stringWithUTF8String:propertyAttrs];
    
    // MMLog(@"%@", unfilteredStr);
    
    
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
/*
BOOL setValueForPropertyName(id val, NSString * propertyName, NSObject * obj){
    
    id cleanVal = nil;
    
    Class cls = [obj class];
    
    getPropertyTypeName(cls, propertyName);
    
    
    MMAdapter adaptValue:val ofType:(NSString *)beforeType toType:(NSString *)afterType
    
    [obj setValue:cleanVal forKey:propertyName];
    
    
    
    
}
*/
/*
id adaptValueForProperty(id val, NSString * propertyName, NSObject * obj){
    
    Class cls = [obj class];
    
    NSString * typeName = getPropertyTypeName(cls, propertyName);
    
    if ([typeName isEqualToString:NSStringFromClass([val class])]) {
        return val;
    }
    
    
    return [MMAdapter adaptValue:val ofType:NSStringFromClass([val class]) toType:typeName];
    

}
 */


NSString * objectWrapperClassName(NSString *primativeTypeName){
    Class testClass = NSClassFromString(primativeTypeName);
    
    if (testClass) {
        return primativeTypeName;
    }
    else{
        if ([primativeTypeName isEqualToString:@"int"]) {
            return @"NSNumber";
        }
        if ([primativeTypeName isEqualToString:@"BOOL"]) {
            return @"NSNumber";
        }
        if ([primativeTypeName isEqualToString:@"float"]) {
            return @"NSNumber";
        }
        if ([primativeTypeName isEqualToString:@"double"]) {
            return @"NSNumber";
        }
        if ([primativeTypeName isEqualToString:@"long"]) {
            return @"NSNumber";
        }
        if ([primativeTypeName isEqualToString:@"char"]) {
            return @"NSValue";
        }
    }
    
    return @"NSValue";
}



void * makeMemoryAllocation(NSString * type){
    int size = 0;
    
    if (!NSClassFromString(type) || [type rangeOfString:@"*" options:NSAnchoredSearch].location != NSNotFound) {
        if (sizeof(int*) == 4) {
            size = 4;
        }
        if (sizeof(int*) == 8) {
            size = 8;
        }
    }
    if ([type isEqualToString:@"int"]) {
        size = sizeof(int);
    }
    if ([type isEqualToString:@"float"]) {
        size = sizeof(float);
    }
    if ([type isEqualToString:@"BOOL"]) {
        size = sizeof(BOOL);
    }
    
    int tries = 0;
    
    void * retVal = NULL;
    
    while (retVal == NULL && tries < 10) {
        retVal = malloc(size);
    }
    
    if(tries > 9 && retVal==NULL){
        
        MMLog(@"malloc of return memory allocation failed in MMAdapter makeMemoryAllocation function");
        return NULL;
    }
    MMLog(@"%d", &retVal);
    return retVal;

}

void * getMemoryAllocationSize(NSString * type){
    int size = 0;
    
    if (!NSClassFromString(type) || [type rangeOfString:@"*" options:NSAnchoredSearch].location != NSNotFound) {
        if (sizeof(int*) == 4) {
            size = 4;
        }
        if (sizeof(int*) == 8) {
            size = 8;
        }
    }
    if ([type isEqualToString:@"int"]) {
        size = sizeof(int);
    }
    if ([type isEqualToString:@"float"]) {
        size = sizeof(float);
    }
    if ([type isEqualToString:@"BOOL"]) {
        size = sizeof(BOOL);
    }
    /*
     if (<#condition#>) {
     <#statements#>
     }
     */
    int tries = 0;
    
    void * retVal = NULL;
    
    while (retVal == NULL && tries < 10) {
        retVal = malloc(size);
    }
    
    if(tries > 9 && retVal==NULL){
        
        MMLog(@"malloc of return memory allocation failed in MMAdapter makeMemoryAllocation function");
        return NULL;
    }
    MMLog(@"%d", &retVal);
    return retVal;
    
}



void freeMemoryAllocation(void * allocMem){

    free(allocMem);
    
}





NSString * introspectProperty(Class controlClass, NSString * propertyName){
    return classPropertyType(controlClass, propertyName);
}

NSString * introspectKVOProperty(Class controlClass, NSString * propertyName){
    return objectWrapperClassName( classPropertyType(controlClass, propertyName) );
}





@implementation MMAdapter

/*
+(void)setValue:(void *)val onObject:(NSObject *)object forKey:(NSString *)key ofType:(NSString *)beforeType toType:(NSString *)afterType{
    
    void * data = [MMAdapter adaptValue:val ofType:beforeType toType:afterType];

    Class returnClass = nil;
    
    if (returnClass = NSClassFromString(afterType)) {
        [object setValue:data forKey:key];
    }
    if ([afterType isEqualToString:@"int"]) {
        [object setValue:(int *)data forKey:key];
    }
    if ([afterType isEqualToString:@"BOOL"]) {
        [object setValue:(BOOL *)data forKey:key];
    }
    if ([afterType isEqualToString:@"float"]) {
        [object setValue:(float *)data forKey:key];
    }
    if ([afterType isEqualToString:@"double"]) {
        [object setValue:(double *)data forKey:key];
    }
    if ([afterType isEqualToString:@"long"]) {
        [object setValue:(long *)data forKey:key];
    }
    if ([afterType isEqualToString:@"char"]) {
        [object setValue:(char *)data forKey:key];
    }
    


}
*/
/*
+(id)adaptValue:(id)val ofType:(NSString *)beforeType forKey:(NSString *)key onObject:(id)obj{
    
    
    
    
    
    
    
    NSString * typeName = getPropertyTypeName([obj class], key);
    
    if ( (val == nil) && (NSClassFromString(typeName) == nil) ) {
        return [self nilValueForType:typeName];
    }
    
    
    if ([[val class]isSubclassOfClass:NSClassFromString(typeName)]) {
        return val;
    }
    
    
    
    if ( NSClassFromString(typeName) ) {
    
        return [MMAdapter adaptValue:val ofType:NSStringFromClass([val class]) toType:typeName];

    }
    

    
    
    
    
    
}
*/


    
+(void *)adaptValue:(void *)val ofType:(NSString *)beforeType toType:(NSString *)afterType{
    
    //[beforeType retain];
    //[afterType retain];
    
    //MMLog(@"blah : %d",[[MMAdapter IntToNSNumber:val]intValue]);
    MMLog(@"initalizing test");
    /*if(val == nil){
    
        return [MMAdapter nilToType:afterType];
        
    }
    else{
        MMLog(@"Not Nil");

    }*/
    
    //int * test1;
    
    //memcpy(test1, val, 4);
    
    //MMLog(@"val == %d", val);
    
    MMLog(@"%@", beforeType);
    MMLog(@"%@", afterType);
    
    
    MMLog(@"%@", [beforeType debugDescription]);

    
    
    if ([beforeType isEqualToString:afterType]) {
        return val;
    }
    
    
    MMLog(@"%@", beforeType);
    MMLog(@"%@", afterType);
    
    NSString * selectorString = [NSString stringWithFormat:@"%@%@%@%@", [MMAdapter messageCapitolize:beforeType], @"To", [MMAdapter messageCapitolize:afterType], @":" ];
    
    MMLog(@"SEL string:%@", selectorString);
    
    SEL transformer = NSSelectorFromString(selectorString);
        MMLog(@"1");
    if ([MMAdapter respondsToSelector:NSSelectorFromString(selectorString)]) {
            
        
        NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:[[MMAdapter class]methodSignatureForSelector:transformer]];
        MMLog(@"2");

        //NSInvocation *invoke = [[NSInvocation alloc]init];
        
        [invoke setTarget:[MMAdapter class]];
        [invoke setSelector:transformer];
        [invoke setArgument:&val atIndex:2];
       
        [invoke invoke];
        
       // NSInvocationOperation * operation = [[NSInvocationOperation alloc]initWithInvocation:invoke];
        
        //[operation start];
        
        //[operation waitUntilFinished];
        
        MMLog(@"2");
        
        if (!invoke) {
            MMLog(@"instance null");

        }
        else{
            MMLog(@"instance present!");
        }


        void * returnBytes;// = makeMemoryAllocation(afterType);

        MMLog(@"%i", returnBytes);

        
        [invoke getReturnValue:&returnBytes];
            MMLog(@"3");

        if(returnBytes == YES){
            MMLog(@"crap!");
        }
        MMLog(@"%i", returnBytes);
        
        
        

        MMLog(@"3.5");

        
        return returnBytes;

    }else{
        
        //[NSException raise:@"Invalid classnames for MMAdapter to translate" format:@"Translating %@ To type: %@", beforeType, afterType];
    
    }
    
    
    
    MMLog(@"Selector Not found on MMAdapter");
    
    return nil;
    
}

+(NSObject *)nonNilValueForValue:(NSObject *)object forType:(NSString *)classname{
    
    if (object != nil) {
        return object;
    }
    
    if ([classname isEqualToString:@"NSString"]) {
        return [NSString stringWithString:@""];
    }
    if ([classname isEqualToString:@"NSNumber"]) {
        return [NSNumber numberWithInt:1];
    }
    if ([classname isEqualToString:@"NSDate"]) {
        return [NSDate date];
    }
    
    
    return nil;
}

+(NSString *)messageCapitolize:(NSString*)val{
    return [val stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[val substringToIndex:1] capitalizedString]];
}

+(BOOL)NSNumberToBOOL:(NSNumber *)val{
    
    
    if (!val) {

        MMLog(@"is Nil!");

        return NO;
    
    }
    
    MMLog(@"is NOT Nil!");

    
    return [(NSNumber *)val boolValue];
}

+(NSNumber *)BOOLToNSNumber:(BOOL *)val{
    return [NSNumber numberWithInt: (int)val];
}

+(int)NSNumberToInt:(NSNumber *)val{
    if (!val) {
        return 0;
    }
    
    return [(NSNumber *)val intValue];
}

+(NSNumber *)IntToNSNumber:(int)val{
    
    MMLog(@"int to nsnumber %d",val);
    NSNumber * num = [NSNumber numberWithInt: val];
    MMLog(@"%d", num);
    return num;
}
/*
+(float)NSNumberToFloat:(void *)val{
    return [(NSNumber *)val floatValue];
}
*/
+(NSNumber *)FloatToNSNumber:(void *)val{
    return [NSNumber numberWithFloat: (int)val];
}







+(id)nilValueForType:(NSString *)type{
    
    
    
    if ([type isEqualToString:@"int"]) {
        return [NSNumber numberWithInt:0];
    }
    if ([type isEqualToString:@"float"]) {
        return [NSNumber numberWithFloat:0];
    }
    if ([type isEqualToString:@"long"]) {
        return [NSNumber numberWithLong:0];
    }
    if ([type isEqualToString:@"short"]) {
        return [NSNumber numberWithShort:0];
    }
    if ([type isEqualToString:@"double"]) {
        return [NSNumber numberWithDouble:0];
    }
    if ([type isEqualToString:@"BOOL"]) {
        return [NSNumber numberWithBool:0];
    }
    if ([type isEqualToString:@"char"]) {
        return [NSNumber numberWithChar:"Ø"];
    }
    return [NSNumber numberWithBool:0];

    
}



+(void *)nilToType:(NSString *)type{
    
    
    //void * ret = makeMemoryAllocation(type);
    //void * pointer = makeMemoryAllocation(type);

    MMLog(@"Popping out a nil value");
    MMLog(type);
    
    if ([type isEqualToString:@"int"]) {
        int val = 0;
        return &val;
    }
    if ([type isEqualToString:@"float"]) {
        return 0;
    }
    if ([type isEqualToString:@"long"]) {
        return 0;
    }
    if ([type isEqualToString:@"short"]) {
        return 0;
    }
    if ([type isEqualToString:@"double"]) {
        return 0;
    }
    if ([type isEqualToString:@"BOOL"]) {
        MMLog(@"Type bool");
        BOOL val = NO;
        return &val;
    }
    if ([type isEqualToString:@"char"]) {
        return "Ø";
    }
    
    return nil;
    
}


@end
