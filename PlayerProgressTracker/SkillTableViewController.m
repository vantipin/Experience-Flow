//
//  SkillTableViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillTableViewController.h"
#import "SkillTemplate.h"
#import "ColorConstants.h"
#import "ViewControllerWithCoreDataMethods.h"
#import "SkillViewCell.h"
#import "Character.h"
#import "Skill.h"
#import "SkillViewCell.h"

@interface SkillTableViewController ()
@property (nonatomic) NSMutableArray *skillsDataSource;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) UIButton *addSkillButton;

@end

@implementation SkillTableViewController

@synthesize skillsDataSource = _skillsDataSource;
@synthesize character = _character;
@synthesize addSkillButton = _addSkillButton;

@synthesize managedObjectContext = _managedObjectContext;

-(UIButton *)addSkillButton
{
    if (!_addSkillButton)
    {
        UIButton *btnAddBooks = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAddBooks setTitle:@"+ Add skill" forState:UIControlStateNormal];
        [btnAddBooks setTitleColor:textEditColor forState:UIControlStateNormal];
        [btnAddBooks.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:30]];
        btnAddBooks.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 90);
        btnAddBooks.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [btnAddBooks addTarget:self action:@selector(addNewSkill) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addSkillButton;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        NSManagedObjectModel *model = [ViewControllerWithCoreDataMethods newManagedObjectModel];
        NSPersistentStoreCoordinator *store = [ViewControllerWithCoreDataMethods newPersistentStoreCoordinatorWithModel:model];
        _managedObjectContext = [ViewControllerWithCoreDataMethods newManagedObjectContextWithPersistantStoreCoordinator:store];
    }
    
    return _managedObjectContext;
}

-(NSMutableArray *)skillsDataSource
{
    if (!_skillsDataSource)
    {
        if (self.character)
        {
            _skillsDataSource = [NSMutableArray arrayWithArray:[self.character.skillSet allObjects]];
        }
        else
        {
            _skillsDataSource = [NSMutableArray new];
        }
    }
    return _skillsDataSource;
}

-(id)initWithCharacter:(Character *)character
{
    self = [super init];
    if (self) {
        self.character = character;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.skillsDataSource.count;// + 1; //there is always add skill btn
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SkillViewCell";
    SkillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Skill *currentSkill = self.skillsDataSource[indexPath.row];
    
    if (!cell)
    {
        cell = [[SkillViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withSkill:currentSkill];
    }
    else
    {
        cell.skill = currentSkill;
        [cell initFields];
    }
    
    return cell;
}


- (void)addNewSkill
{
    NSLog(@"add newSkill btn pressed");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
