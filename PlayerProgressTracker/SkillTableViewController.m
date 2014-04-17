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
#import "MainContextObject.h"
#import "SkillViewCell.h"
#import "Character.h"
#import "Skill.h"
#import "SkillViewCell.h"
#import "SkillSet.h"

@interface SkillTableViewController ()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *skillsDataSource;
//@property (nonatomic) UIView *activeTipView;
@end

@implementation SkillTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)skillsDataSource
{
    if (!_skillsDataSource) {
        if (self.skillSet) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"dateXpAdded" ascending: NO];
            _skillsDataSource = [NSMutableArray arrayWithArray:[[[SkillManager sharedInstance] fetchAllNoneBasicSkillsForSkillSet:self.skillSet] sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]]];
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
        _managedObjectContext = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _managedObjectContext;
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
    return self.skillsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SkillViewCell";
    SkillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Skill *currentSkill = self.skillsDataSource[indexPath.row];
    
    [SkillManager sharedInstance].delegateSkillChange = self;
    
    if (!cell)
    {
        cell = [[SkillViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withSkill:currentSkill];
        cell.skillCellDelegate = self;
        cell.usableSkillLvlTextField.delegate = self;
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

    [[SkillManager sharedInstance] showDescriptionForSkillTemplate:skill.skillTemplate inView:parentView];

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

//-(void)closeTip
//{
//    
//    if (self.activeTipView) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.activeTipView.alpha = 0;
//        }];
//        
//        [self.activeTipView removeFromSuperview];
//        self.activeTipView = nil;
//    }
//}

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

-(void)addNewSkill:(Skill *)skill
{
//    [self.addToListMenuController.dropDownTableView beginUpdates];
//    [self.addToListMenuController.dropDownTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:returnIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    [self.addToListMenuController.dropDownTableView endUpdates];
}

#pragma mark -
#pragma mark text field delegate methods



@end
