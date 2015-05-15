//
//  DataBaseAccess.h
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/15/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>

@interface DataBaseAccess : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(DBResultSet *)shelectAll;
-(void)updateWithID: (int)idNum withAge:(int)age withFN:(NSString*)fn withLN:(NSString*)ln;
-(DBResultSet *)rowWithID: (int)idNum;
-(void)deleteWithID: (int)idNum;
-(void)addRowWithAge: (int) age withFirstName: (NSString*) fn withLastName: (NSString*)  ln;
	
@end
