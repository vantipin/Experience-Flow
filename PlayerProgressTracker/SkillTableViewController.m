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
#import "CoreDataViewController.h"
#import "SkillViewCell.h"
#import "Character.h"
#import "Skill.h"
#import "SkillViewCell.h"
#import "SkillSet.h"

@interface SkillTableViewController ()
@property (nonatomic) UIButton *addSkillButton;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *skillsDataSource;
@property (nonatomic) UIView *activeTipView;
@end

@implementation SkillTableViewController


-(UIButton *)addSkillButton
{
    if (!_addSkillButton) {
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

-(NSMutableArray *)skillsDataSource
{
    if (!_skillsDataSource) {
        if (self.skillSet) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"dateXpAdded" ascending: NO];
            _skillsDataSource = [NSMutableArray arrayWithArray:[[self.skillSet.skills allObjects] sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]]];
        }
        else {
            _skillsDataSource = [NSMutableArray new];
        }
    }
    return _skillsDataSource;
}

-(void)setSkillSet:(SkillSet *)skillSet
{
    self.skillsDataSource = nil;
    _skillSet = skillSet;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext){
        _managedObjectContext = [[CoreDataViewController sharedInstance] managedObjectContext];
    }
    return _managedObjectContext;
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
    
    [SkillManager sharedInstance].delegate = self;
    
    if (!cell)
    {
        cell = [[SkillViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withSkill:currentSkill];
        cell.skillCellDelegate = self;
        cell.skillUsableLvlTextField.delegate = self;
    }
    cell.skill = currentSkill;
    [cell reloadFields];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    Skill *skill = [self.skillsDataSource objectAtIndex:indexPath.row];
    [self raiseXpForSkill:skill withXpPoints:1];
}


#pragma mark - 
#pragma mark cell delegates methods

-(void)skill:(Skill *)skill buttonTapped:(UIButton *)sender
{
    UIView *parentView = self.view;
    CGRect closingAreaFrame = parentView.bounds;
    
    float defaultWidht = 300;
    float defaultHeight = 10;
    CGRect tipFrame = CGRectMake(parentView.center.x - defaultWidht/2,
                                 parentView.center.y - 60,
                                 defaultWidht,
                                 defaultHeight);
    
    
    UITextView *tipTextView = [[UITextView alloc] initWithFrame:tipFrame];
    [tipTextView setText:skill.skillTemplate.skillDescription];
    [tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [tipTextView sizeToFit];
    tipTextView.backgroundColor = [UIColor whiteColor];
    tipTextView.editable = false;
    tipTextView.selectable = false;
    
    UIView *closingAreaView = [[UIView alloc] initWithFrame:closingAreaFrame];
    closingAreaView.opaque = false;
    closingAreaView.backgroundColor = [UIColor clearColor];
    
    self.activeTipView = [[UIView alloc] initWithFrame:closingAreaFrame];
    [self.activeTipView addSubview:closingAreaView];
    [self.activeTipView addSubview:tipTextView];
    [self.activeTipView bringSubviewToFront:tipTextView];
    [self.activeTipView setBackgroundColor:kRGB(220, 220, 220, 0.7)];
    
    UITapGestureRecognizer *tapRecognizer;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTip)];
    [self.activeTipView addGestureRecognizer:tapRecognizer];
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeTip)];
    [self.activeTipView addGestureRecognizer:panRecognizer];
    
    self.activeTipView.alpha = 0;
    [parentView addSubview:self.activeTipView];
    [parentView bringSubviewToFront:self.activeTipView];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.activeTipView.alpha = 1;
    }];

}

-(void)raiseXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints
{
    [self changeXpPointsToSkill:skill withXpPoints:xpPoints didRaiseXp:true];
}

-(void)lowerXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints
{
    [self changeXpPointsToSkill:skill withXpPoints:xpPoints didRaiseXp:false];
}

#pragma mark - 

-(void)closeTip
{
    
    if (self.activeTipView) {
        [UIView animateWithDuration:0.15 animations:^{
            self.activeTipView.alpha = 0;
        }];
        
        [self.activeTipView removeFromSuperview];
        self.activeTipView = nil;
    }
}

-(void)changeXpPointsToSkill:(Skill *)skill withXpPoints:(float)xpPoints didRaiseXp:(BOOL)didRaise
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
    
    if (didRaise){
        [[SkillManager sharedInstance] addXpPoints:xpPoints toSkill:skill withContext:self.managedObjectContext];
    }
    else{
        [[SkillManager sharedInstance] removeXpPoints:xpPoints toSkill:skill withContext:self.managedObjectContext];
    }
    SkillViewCell *cell = (SkillViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell reloadFields];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"dateXpAdded" ascending: NO];
    self.skillsDataSource = [NSMutableArray arrayWithArray:[self.skillsDataSource sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]]];
    [self.tableView reloadData];
    //[self.tableView beginUpdates];
    
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableView endUpdates];
}

-(void)didChangeSkillLevel
{
    [self.skillTableDelegate didUpdateCharacterSkills];
}

- (void)addNewSkill
{
    NSLog(@"add newSkill btn pressed");
}

#pragma mark -
#pragma mark text field delegate methods



@end
