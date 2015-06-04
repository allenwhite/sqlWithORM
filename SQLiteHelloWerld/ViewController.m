//
//  ViewController.m
//  SQLiteHelloWerld
//
//  Created by Allen White on 5/13/15.
//  Copyright (c) 2015 Allen White. All rights reserved.
//

#import "ViewController.h"
#import "DataBaseAccess.h"
#import "PeopleInfo.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *arrPeopleInfo;
-(void)loadData;
@property (nonatomic) int recordIDToEdit;
@property (nonatomic, strong) DataBaseAccess *dbManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
	self.dbManager = [[DataBaseAccess alloc] initWithDatabaseFilename:@"application_database"];
    
        // Make self the delegate and datasource of the table view.
        self.tblPeople.delegate = self;
        self.tblPeople.dataSource = self;
    
        // Load the data.
        [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addNewRecord:(id)sender {
	// Before performing the segue, set the -1 value to the recordIDToEdit. That way we'll indicate that we want to add a new record and not to edit an existing one.
	self.recordIDToEdit = -1;
	
	// Perform the segue.
	[self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}


-(void)loadData{
    // select everything
	NSArray* r = self.dbManager.shelectAll;
	
	
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray: r];
    
    // Reload the table view.
    [self.tblPeople reloadData];
}


-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditInfoViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
	editInfoViewController.recordIDToEdit = self.recordIDToEdit;
}


//////////////////////////////tableview shit///////////////////////////////////
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	// Get the record ID of the selected name and set it to the recordIDToEdit property.
	PeopleInfo* peep = [self.arrPeopleInfo objectAtIndex:indexPath.row];
	self.recordIDToEdit = [peep.Id intValue];
	
	// Perform the segue.
	[self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPeopleInfo.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
	
//     Set the loaded data to the appropriate cell labels.
	PeopleInfo* peep = [self.arrPeopleInfo objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
						   peep.firstname,
						   peep.lastname];
    

	cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %d", peep.age];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the selected record.
		// Find the record ID.
		PeopleInfo* peep = [self.arrPeopleInfo objectAtIndex:indexPath.row];
		int recordIDToDelete = [peep.Id intValue];
		
		//delete it from the db
		[self.dbManager deleteWithID:recordIDToDelete];
		
		// Reload the table view.
		[self loadData];
	}
}


@end
