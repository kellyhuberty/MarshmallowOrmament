Ormament
========

Ormament is an objective-c based sqlite object relational model library for data storage. Ormament handels everything from creating and building out your schema, to managing the relations between two different types of entities. Similar in kin to Core Data, ormament is a more versitile alternative to the aformentioned due to it's code transparency.

##Building out a Schema##

Schema information is stored in plists. An example plist can be found in the test project.

The schema structure contains:

* `version` - standard version string containing integers separated by points.
<!-- * `storeClassName` - class name the schema should be built using. (Defaults to MMSQLiteSchema.) -->
* `name` - String of the name of the schema
* `entities` - An array containing all of the entities for the schema. See [entities](#entities).

###Entities <span id="entities"></span>###

* `name` - An array containing all of the entities for the schema. See [entities](#entities).
* `id_keys` - An array containing all of the entities for the schema. See [entities](#entities).
* `attributes` - An array containing all of the entities for the schema. See [attributes](#attributes).
* `relationships` - An array containing all of the entities for the schema. See [relationships](#relationships).



###Attributes <span id="attributes"></span>###

###Relationships <span id="relationships"></span>###


###Upgrading/Downgrading a schema###


###Creating a model class###

###Fetching instances###

###Creating a new instance###


###Updating an instance.###


###Deleting an instance###

 

###handeling relationships###




##FAQ##

*Is it thread safe?*
No. Despite the fact that there are methods that accept blocks, thread safety is not garenteed. There's a basic plan to make it so that thread safety can be an option down the road, but I'm by no means an expert at concurrent programming.

*TE*
