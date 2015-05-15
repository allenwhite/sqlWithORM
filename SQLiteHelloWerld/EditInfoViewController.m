//
//  EditInfoViewController.m
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/13/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DataBaseAccess.h"
#import "PeopleInfo.h"

@interface EditInfoViewController ()

-(void)loadInfoToEdit;
@property (nonatomic, strong) DataBaseAccess *dbManager;

@end

@implementation EditInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the navigation bar tint color.
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;

    // Make self the delegate of the textfields.
    self.txtFirstname.delegate = self;
    self.txtLastname.delegate = self;
    self.txtAge.delegate = self;
	
	//init the orm
	self.dbManager = [[DataBaseAccess alloc] initWithDatabaseFilename:@"sampledb.sql"];
	
	// Check if should load specific record for editing.
	if (self.recordIDToEdit != -1) {
		// Load the record with the specific ID from the database.
		[self loadInfoToEdit];
	}
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)saveInfo:(id)sender {
	if (self.recordIDToEdit == -1) {
		//insert query
		[self.dbManager addRowWithAge:[self.txtAge.text intValue]
											withFirstName:self.txtFirstname.text
											withLastName:self.txtLastname.text];
		// save the object into the table
				NSLog(@"%d",[self.txtAge.text intValue]);
	}else{
		//update query
		[self.dbManager updateWithID:self.recordIDToEdit
								withAge:[self.txtAge.text intValue]
								withFN:self.txtFirstname.text
								withLN:self.txtLastname.text];
		NSLog(@"%d",[self.txtAge.text intValue]);
	}
	
		// Inform the delegate that the editing was finished.
		[self.delegate editingInfoWasFinished];
		
		// Pop the view controller.
		[self.navigationController popViewControllerAnimated:YES];
}


-(void)loadInfoToEdit{
	// load the shit
	DBResultSet *r = [self.dbManager rowWithID:self.recordIDToEdit];
	PeopleInfo* peep = [r objectAtIndex:0];
	// Set the loaded data to the textfields.
	self.txtFirstname.text = peep.firstname;
	self.txtLastname.text = peep.lastname;
	self.txtAge.text = [NSString stringWithFormat:@"%d",peep.age];
}


@end
