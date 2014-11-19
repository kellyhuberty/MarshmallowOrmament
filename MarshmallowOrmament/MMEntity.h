//
//  MMEntity.h
//  BandIt
//
//  Created by Kelly Huberty on 9/2/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MMUtility.h"
#import "MMSet.h"
#import "MMSchemaObject.h"

//#import "MMCoreData.h"
/**
 A MMEntity is an object used to describe your application's internal representation of its data for use in a MMRecord, MMStore, associated model objects and virtually every API in Marshmallow. An entity object stores the attribute types, display names, order in a list, and enforeced classes of all record objects. Typically an entity is created once, defined with a name string that identifies it globally, and then stored statically for use across your entire application.
 
 MMEntitys can be defined in a varity of ways. They can be defined programmatically, using [MMKeyValueDescriptor](MMKeyValueDescriptor Class Reference) to define each attribute, using dictionarys to assign values to each attribute, and a couple of different ways using plist files to define data in your appication.
 
 Stores and Records without an MMEntity object defining the names,classes and additional vars of data are useless, and can not store record data of any type.
 
##Defining an Entity Programmatically##
 
 
##Defining an Entity using XML .plists Files##
 

 */


@class MMDataMap;
@class MMRelationship;
@class MMAttribute;


@interface MMEntity : MMSchemaObject{
    
    NSString * _name;
    NSString * _modelClassName;
        //NSString * _resourceName;
    NSString * _storeClassName;

   // NSArray * _identifierKeys;
    NSArray * _idKeys;
        
    //MMDataMap * _defaultEntityMap;
    
    MMSet * _attributes;
    MMSet * _relationships;

    
    //NSMutableArray * _attributeOrder;
    //MMSet * _attributes;

        //NSMutableDictionary * _controlProperties;
        //NSMutableDictionary * _controlNames;
        //NSMutableDictionary * _displayNames;
        //NSMutableDictionary * _classNames;
    //NSMutableDictionary * _defaults;
        // BOOL dirty;
    
    //NSEntityDescription * _entityDescription;
    
    //MMDataMap * _recordMap;
    
    
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * storeName;

@property (nonatomic, retain) NSString * modelClassName;
@property (nonatomic, retain) NSArray * uniqueIndex;
@property (nonatomic, retain) NSArray * idKeys;


//@property (atomic, retain) NSEntityDescription * entityDescription;
//@property (atomic, readonly) NSString * storeName;


    //@property (nonatomic, retain) NSMutableDictionary * controlNames;
    //@property (nonatomic, retain) NSMutableDictionary *  controlProperties;
    //@property (nonatomic, retain) NSString * resourceName;
@property (nonatomic, retain) NSString * storeClassName;

@property (nonatomic, retain) MMSet *  attributes;
@property (nonatomic, retain) MMSet *  relationships;



-(id)init;
-(id)initWithDictionary:(NSDictionary *)dict;
-(void)dealloc;

/**
Sets an entity map for the given 
 Sets the given Entity Map defining the mapping of data for the given api specified by apiName
 @param map Entity Map defining the mapping of data for the given api specified by apiName
 @param newModel a model object which is linked to that particular MMRecord.
 @returns An instance of MMRecord;
 */
-(void)setEntityMap:(MMDataMap *)map forAPIName:(NSString *)apiName;

/**
Returns the given Entity Map for the given apiName. If an entity isn't specified for the given apiName, 
 the default Entity Map is returned in it's place.
 @param apiName String specifing the
 @returns An instance of MMRecord;
 */
-(MMDataMap *)entityMapForAPIName:(NSString *)apiName;
/**
 Sets the default Entity Map. If the default entity map is not specified, the first entity map set
 for the entity will be used.
 @param map The entity map to use as default
 */
-(void)setDefaultEntityMap:(MMDataMap *)map;

/**
 Sets the entity's name. This name should be the same as it's corresponding core data entity and 
 is used to register and retrieve the entity at runtime.
 @param name The name to use.
 */
-(void)setName:(NSString *)name;

/**
 Sets the entity's core data entity description. 
 @param entityDescription 
 */
-(void)setEntityDescription:(NSEntityDescription *)entityDescription;

/**
 Retrieves the entity's core data description.
 */
-(NSEntityDescription *)entityDescription;

/**
 Set's the entity's unique index
 @param index Array containing strings that specify an Item's unique Identifing attributes.
 @discussion
 */
-(void)setUniqueIndex:(NSArray *)index;

/**
the entity's unique index
 @returns index Array containing strings that specify an Item's unique Identifing attributes.
 */
-(NSArray*)idKeys;

//-(NSArray*)uniqueIndex;

/**
 Set's the prefix for all model classes used as Marshmallow records
 @param prefix first letters of every class
 @discussion If defined, all entity classes will be assumed to be of the format {CLass Prefix}{Core data entity name}
 For instance, if the class prefix is set in this method as "SM", the resulting class for the Core data entity person will be 
 SMPerson.
 */
+(void)setModelClassNamePrefix:(NSString *)prefix;

/**
 Returns the names of the SQL attributes for this entity's sql table representation. If a SQL attribute name is not specified, the 
 attribute will default to its default name.
 @discussion If defined, all entity classes will be assumed to be of the format {CLass Prefix}{Core data entity name}
 For instance, if the class prefix is set in this method as "SM", the resulting class for the Core data entity person will be
 SMPerson.
 @returns NSDictionary with the keys representing the attribute names and the values representing the table names.
 */
-(NSDictionary *)sqlAttributeNames;

/**
 Returns the names of the SQL attributes for this entity's sql table representation. If a SQL attribute name is not specified, the
 attribute will default to its default name.
 @discussion If defined, all entity classes will be assumed to be of the format {CLass Prefix}{Core data entity name}
 For instance, if the class prefix is set in this method as "SM", the resulting class for the Core data entity person will be
 SMPerson.
 @returns NSDictionary with the keys representing the attribute names and the values representing the table names.
 */
-(MMAttribute *)attributeWithName:(NSString *)name;
-(MMRelationship *)relationshipWithName:(NSString *)name;


-(void)log;
+(void)initialize;
+(void)loadEntityFile;
-(void)setup;
//+(void)initialize;
//+(void)loadEntityFile;
//-(id)init;
//-(void)setup;
//-(void)dealloc;



@end
