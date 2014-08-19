//
//  MMConditional.m
//  MarshmallowOrmament
//
//  Created by Kelly Huberty on 7/28/14.
//  Copyright (c) 2014 Kelly Huberty. All rights reserved.
//

#import "MMConditional.h"
#import "MMCondition.h"
#import "MMStore.h"
@implementation MMConditional

-(id)initWithFormat:(NSString *)formatString, ...{
    
    if(self = [super init]){

        id eachObject;
        va_list argumentList;
        if (formatString) // The first argument isn't part of the varargs list,
        {                                   // so we'll handle it separately.
            int instances = [[self class] numberOfOccurrencesOfString:@"%@" inString:formatString];
            NSMutableArray * array = [NSMutableArray array];
            
            
            //[array addObject: firstObject];
            va_start(argumentList, formatString); // Start scanning for arguments after firstObject.
            while ((eachObject = va_arg(argumentList, id))) // As many times as we can get an argument of type "id"
                [array addObject: eachObject]; // that isn't nil, add it to self's contents.
            va_end(argumentList);

            [self processConditionalFormatString:formatString withArguements:array];
        
        }
        
        

        
    }
    
    return self;
    
}


+(instancetype)conditionalWithFormat:(NSString *)formatString, ...{

    
    return nil;
    
}


+(MMConditional *)processConditionalFormatString:(NSString *)formatString withArguements:(NSArray *)args{
    

    NSMutableArray * ranges = [NSMutableArray array];
    //NSMutableArray * args = [args mutableCopy];

    
    
    int len = [formatString length];
    char buffer[len + 1];
    
    //This way:
    strncpy(buffer, [formatString UTF8String], len);
    
    //Or this way (preferred):
    
    //[formatString getCharacters:buffer range:NSMakeRange(0, len)];
    
    int start = -1;
    int end = -1;
    int tolerate = 0;
    
    for(int i = 0; i < len; ++i) {
        char current = buffer[i];
        //do something with current...
        
        NSLog(@"%c", current);
        
        if (current = "(") {
            if (start != -1) {
                tolerate++;
            }
            else{
                start = i;
            }
        }
        if (current = ")") {
            if (start > -1) {
                if (tolerate > 0) {
                    --tolerate;
                }
                else{
                    end = i;
                }
            }
            else{
                
            }
        }
        
        if (start > -1 && end > -1) {
            
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(start, end - start) ]];

            
            
        }
        
    }
    
    for(NSValue * range in ranges){
     
        if ([range rangeValue].length == 0) {
            continue;
        }
        
        NSString * piece = [formatString substringWithRange:[range rangeValue]] ;

        
        if ([piece characterAtIndex:0] == '(' && [piece characterAtIndex:piece.length-1] == ')'){
            
            
            
            NSString * formattedPiece = [formatString substringWithRange:NSMakeRange(1, formatString.length - 2 )] ;
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"%@" options:NSRegularExpressionCaseInsensitive error:&error];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:formattedPiece options:0 range:NSMakeRange(0, [formattedPiece length])];
            
            [self processConditionalFormatString:formattedPiece withArguements:[args subarrayWithRange:NSMakeRange(0, numberOfMatches)]];

        
        }else{
            
            NSArray * conditionStrings = [piece componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"~|&" ]];
            
            for (NSString * conditionString in conditionStrings) {
                
                //[MMCondition conditionWithConditionString:conditionString arguments:args];
                
                
            }
            
            
            
            
            
        }
        
    }
    
    
    return nil;
}


+ (NSArray *)pregSplit:(NSString *)expression withSubject:(NSString *)subject {
    
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:expression options:0 error:nil];
    
    NSArray *matches = [exp matchesInString:subject options:0 range:NSMakeRange(0, [subject length])];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in matches) {
        [results addObject:[subject substringWithRange:[match range]]];
    }
    
    return results;
    
}


+(NSUInteger)numberOfOccurrencesOfString:(NSString *)needle inString:(NSString *)haystack {
    const char * rawNeedle = [needle UTF8String];
    NSUInteger needleLength = strlen(rawNeedle);
    
    const char * rawHaystack = [haystack UTF8String];
    NSUInteger haystackLength = strlen(rawHaystack);
    
    NSUInteger needleCount = 0;
    NSUInteger needleIndex = 0;
    for (NSUInteger index = 0; index < haystackLength; ++index) {
        const char thisCharacter = rawHaystack[index];
        if (thisCharacter != rawNeedle[needleIndex]) {
            needleIndex = 0; //they don't match; reset the needle index
        }
        
        //resetting the needle might be the beginning of another match
        if (thisCharacter == rawNeedle[needleIndex]) {
            needleIndex++; //char match
            if (needleIndex >= needleLength) {
                needleCount++; //we completed finding the needle
                needleIndex = 0;
            }
        }
    }
    
    return needleCount;
}

@end
