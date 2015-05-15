//
//  AppDelegate.h
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/13/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, DBDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

