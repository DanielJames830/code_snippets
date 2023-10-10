These files are the implementation of a User in the application SafeAlone.

The User class extends a custom ValueObject class. This allows us to automatically prepare new objects for backend functionality, like reading or writing from Firebase.

The UserEntity class is a wrapper for the User. When you need to retrieve something from A backend database, you can query for a UserEntity. The entity you recieve will have a value property with the User class desired. 

SafeAlone follows a Factory structure. The UserFactory class handles all the user creation and editing our application needs. 

Finally, the UserRepository class tells Firebase how  and where to store our User.