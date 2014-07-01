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
#import "TipViewController.h"
#import "CustomPopoverViewController.h"

@interface SkillTableViewController ()
@property (nonatomic) NSMutableArray *skillsDataSource;

@property (nonatomic) NSMutableArray *objectsToUpdate; //collection will remember objects which need to be relocated. If objects in the end won't change their position - Relocation will be replaced with simple Reload
@end

@implementation SkillTableViewController

@synthesize skillsDataSource = _skillsDataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SkillManager sharedInstance] subscribeForSkillsChangeNotifications:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SkillManager sharedInstance] unsubscribeForSkillChangeNotifications:self];
}

-(NSMutableArray *)objectsToUpdate
{
    if (!_objectsToUpdate) {
        _objectsToUpdate = [NSMutableArray new];
    }
    return _objectsToUpdate;
}

-(NSMutableArray *)skillsDataSource
{
    if (!_skillsDataSource) {
        [self reloadDataSourceFromSkillSet];
    }
    return _skillsDataSource;
}

-(void)reloadDataSourceFromSkillSet
{
    if (self.skillSet) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"dateXpAdded" ascending: NO];
        _skillsDataSource = [NSMutableArray arrayWithArray:[[[SkillManager sharedInstance] fetchAllSkillsForSkillSet:self.skillSet] sortedArrayUsingDescriptors:[NSMutableArray arrayWithObject:sortDescriptor]]];
    }
    else {
        _skillsDataSource = [NSMutableArray new];
    }

}

-(void)setSkillSet:(SkillSet *)skillSet
{
    _skillsDataSource = nil;
    _skillSet = skillSet;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
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
    
    if (!cell)
    {
        cell = [[SkillViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withSkill:currentSkill];
        cell.skillCellDelegate = self;
        cell.usableSkillLvlTextField.delegate = self;
    }
    cell.skill = currentSkill;
    cell.backgroundColor = [UIColor clearColor];
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
    //[[SkillManager sharedInstance] showDescriptionForSkillTemplate:skill.skillTemplate inView:parentView];

}

-(void)raiseXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints
{
    [self changeXpPointsToSkill:skill withXpPoints:xpPoints didRaiseXp:true];
}

-(void)lowerXpForSkill:(Skill *)skill withXpPoints:(float)xpPoints
{
    [self changeXpPointsToSkill:skill withXpPoints:xpPoints didRaiseXp:false];
}

-(void)changeXpPointsToSkill:(Skill *)skill withXpPoints:(float)xpPoints didRaiseXp:(BOOL)didRaise
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
    
    [self.objectsToUpdate removeAllObjects];
    
    if (didRaise){
        [[SkillManager sharedInstance] addXpPoints:xpPoints toSkill:skill];
    }
    else {
        [[SkillManager sharedInstance] removeXpPoints:xpPoints toSkill:skill];
    }
    SkillViewCell *cell = (SkillViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell reloadFields];
    
}

#pragma mark -
#pragma mark SkillManager delegate methods
-(void)didChangeSkillLevel:(Skill *)skill
{
    [self.skillTableDelegate didUpdateCharacterSkills];
//    [self reloadDataSourceFromSkillSet];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
//    if (indexPath) {
//        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
//        
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableView endUpdates];
//    }
}

-(void)didChangeExperiencePointsForSkill:(Skill *)skill
{
    if ([self.skillSet.skills containsObject:skill]) {
        if ([self.skillsDataSource containsObject:skill]) {
            if (![self.objectsToUpdate containsObject:skill]) {
                [self.objectsToUpdate addObject:skill];
            }
        }
        
        [self updateSubSkillsOfSkill:skill];
    }
}

-(void)didFinishChangingExperiencePointsForSkill:(Skill *)skill
{
    if ([self.skillsDataSource containsObject:skill]) {
        NSMutableArray *indexPathsWas = [NSMutableArray new];
        for (Skill *skill in self.objectsToUpdate) {
            NSIndexPath *indexPathWas = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
            if (indexPathWas) {
                [indexPathsWas addObject:indexPathWas];
            }
        }
        [self reloadDataSourceFromSkillSet];
        NSMutableArray *indexPathsIs = [NSMutableArray new];
        for (Skill *skill in self.objectsToUpdate) {
            NSIndexPath *indexPathIs = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
            if (indexPathIs) {
                [indexPathsIs addObject:indexPathIs];
            }
        }
        
        if (indexPathsWas.count != indexPathsIs.count) {
            [self.tableView reloadData];
            return;
        }
        
        for (int i = 0; i < indexPathsWas.count; i++) {
            NSIndexPath *indexPathIs = indexPathsIs[i];
            NSIndexPath *indexPathWas = indexPathsWas[i];
            NSInteger same = [indexPathIs compare:indexPathWas];
            
            
            if (same != NSOrderedSame) {
                [self relocateObjectsWithOldIndexPaths:indexPathsWas withNewIndexPaths:indexPathsIs];
                return;
            }
        }
        
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:indexPathsIs withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}



-(void)addedSkill:(Skill *)skill toSkillSet:(SkillSet *)skillSet
{
    if (self.skillSet == skillSet) {
        [self addCellViewForNewSkill:skill];
    }
}

-(void)deletedSkill:(Skill *)skill fromSkillSet:(SkillSet *)skillSet
{
    if (self.skillSet == skillSet) {
        [self deleteCellViewForNewSkill:skill];
    }
}


#pragma mark helpers
-(void)addCellViewForNewSkill:(Skill *)skill
{
    [self reloadDataSourceFromSkillSet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
    if (indexPath) {
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

-(void)deleteCellViewForNewSkill:(Skill *)skill
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
    [self reloadDataSourceFromSkillSet];
    if (indexPath) {
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

-(void)relocateObjectsWithOldIndexPaths:(NSMutableArray *)indexPathsWas withNewIndexPaths:(NSMutableArray *)indexPathsIs
{
    if (indexPathsWas && indexPathsIs && (indexPathsWas.count == indexPathsIs.count)) {
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
    
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsWas withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView insertRowsAtIndexPaths:indexPathsIs withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
}


-(void)updateSubSkillsOfSkill:(Skill *)basicSkill
{
    if (basicSkill.subSkills.count != 0) {
        for (Skill *skill in basicSkill.subSkills) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.skillsDataSource indexOfObject:skill] inSection:0];
            if (indexPath) {
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
            
            [self updateSubSkillsOfSkill:skill];
        }
    }

}
@end
