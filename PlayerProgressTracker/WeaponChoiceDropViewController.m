//
//  WeaponChoiceDropViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 24.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "WeaponChoiceDropViewController.h"
#import "SkillTemplate.h"
#import "WeaponMelee.h"
#import "WeaponRanged.h"
#import "DefaultSkillTemplates.h"

@interface WeaponChoiceDropViewController ()

@end

@implementation WeaponChoiceDropViewController

@synthesize meleeSkills = _meleeSkills;
@synthesize rangeSkills = _rangeSkills;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)meleeSkills
{
    if (!_meleeSkills) {
        _meleeSkills = [[DefaultSkillTemplates sharedInstance] allMeleeCombatSkillTemplates];
    }
    return _meleeSkills;
}

-(NSArray *)rangeSkills
{
    if (!_rangeSkills) {
        _rangeSkills = [[DefaultSkillTemplates sharedInstance] allRangeCombatSkillTemplates];
    }
    return _rangeSkills;
}

-(void)customReshapeFrames
{
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y,
                                 self.view.frame.size.width,
                                 self.heightOfCell * (self.meleeSkills.count + self.rangeSkills.count));
    self.dropDownTableView.frame = CGRectMake(self.dropDownTableView.frame.origin.x,
                                              self.dropDownTableView.frame.origin.y,
                                              self.dropDownTableView.frame.size.width,
                                              self.heightOfCell * (self.meleeSkills.count + self.rangeSkills.count));
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.meleeSkills count];
    }
    if (section == 1) {
        return [self.rangeSkills count];
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Melee weapons:";
    }
    if (section == 1) {
        return @"Range weapons:";
    }
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SetWeaponTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SkillTemplate *currentSkillTemplate =  (indexPath.section == 0) ? self.meleeSkills[indexPath.row] : self.rangeSkills[indexPath.row];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = currentSkillTemplate.name;
    if (self.font) {
        [cell.textLabel setFont:self.font];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
