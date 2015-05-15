//
//  PeopleInfo.h
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/15/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface PeopleInfo : DBObject

@property (strong) NSString*			firstname;
@property (strong) NSString*			lastname;
@property int						age;
@property int						peopleInfoID;

@end
