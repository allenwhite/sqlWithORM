//
//  DataBaseAccess.m
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/15/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import "DataBaseAccess.h"
#import "PeopleInfo.h"


@implementation DataBaseAccess

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
	self = [super init];
        //added by max //if (self)?
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                             NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        NSLog(self.documentsDirectory);
        self.databaseFilename = dbFilename;
        [self copyDatabaseIntoDocumentsDirectory];
        //
        [DBAccess setDelegate:self];
	[DBAccess openDatabaseNamed:dbFilename];
        
	return self;
}

-(void)copyDatabaseIntoDocumentsDirectory{
        NSFileManager *file_manager = [NSFileManager defaultManager];
        NSString *destinationPath = [[self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename]stringByAppendingString:@".db"];
        /*
         check if the db is in the documents directory and if not put it there
         */
        if  (! [ file_manager  fileExistsAtPath:destinationPath] ) {
                NSString *sourcePath = [[   [ [NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename] stringByAppendingString:@".db"];
                NSLog(sourcePath);
                NSError *error;
                [file_manager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
                if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                }
        }
}

-(DBResultSet *)shelectAll{
	// Form the query.
	DBResultSet* r = [[PeopleInfo query] fetch];
//	NSLog(@"result:\n%@",r[0]);
	return r;
}



-(void)updateWithID: (int)idNum withAge:(int)age withFN:(NSString*)fn withLN:(NSString*)ln{
	DBResultSet* r = [[[[PeopleInfo query]
				whereWithFormat:@"Id=%d",  idNum]
				limit:1]
				fetch];
	PeopleInfo* jew = [r objectAtIndex:0];
	[jew setValue:fn forKey:@"firstname"];
	[jew setValue:ln forKey:@"lastname"];
	[jew setValue:[NSNumber numberWithInt:age] forKey:@"age"];
	[jew commit];
	
}


-(void)deleteWithID: (int)idNum{
	// delete the shit
	DBResultSet* r = [[[PeopleInfo query]
						whereWithFormat:@"Id=%d",  idNum]
						fetch];
	[r removeAll];
	
	
}


-(void)addRowWithAge:(int)age withFirstName:(NSString*)fn withLastName:(NSString*) ln{
	PeopleInfo* p = [PeopleInfo new];
	p.firstname = fn;
	p.lastname = ln;
	p.age = age;
	
	// save the object into the table
	[p commit];
}


-(DBResultSet *)rowWithID: (int)idNum{
	NSLog(@"id:\n%d",idNum);
	DBResultSet* r = [[[PeopleInfo query]
					   whereWithFormat:@"Id=%d",  idNum]
					  fetch];
	return r;
}


@end
