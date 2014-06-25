//
//  AddSkillDropViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 17.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "AddSkillDropViewController.h"
#import "SkillTemplate.h"
#import "ColorConstants.h"

@interface AddSkillDropViewController ()

@property (nonatomic) AddSkillViewCellTableViewCell *addSkillCellToProcessAlert;

@end

@implementation AddSkillDropViewController

@synthesize cancelingView = _cancelingView;

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

-(UIView *)cancelingView
{
    if (!_cancelingView)
    {
        //CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        //prepare view for canceling dropview
        _cancelingView = [[UIView alloc] initWithFrame:self.view.superview.bounds];
        
        _cancelingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _cancelingView.autoresizesSubviews = true;
        
        _cancelingView.opaque = false;
        _cancelingView.backgroundColor = kRGB(200, 200, 200, 0.3);
        
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAnimation)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [_cancelingView addGestureRecognizer:tapRecognizer];
    }
    
    return _cancelingView;
}

-(AddSkillDropViewController *)initWithArrayData:(NSArray *)templateArray
                                    withSkillSet:(SkillSet *)skillSet
                              withWidthTableView:(float)tableWidth
                                      cellHeight:(CGFloat)cHeight
                                     withRedView:(UIView *)refView
                                   withAnimation:(AnimationType)tAnimation;
{
    if ((self = [super init])) {
        
		self.dropDownDataSource = templateArray;
        self.widthTableView = tableWidth;
		self.anchorView = refView;
        self.heightOfCell = cHeight;
		self.heightTableView = cHeight*templateArray.count;
		animationType = tAnimation;
		_skillSet = skillSet;
	}
	
	return self;
}

-(void)setSkillSet:(SkillSet *)skillSet
{
    _skillSet = skillSet;
    [self.dropDownTableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AddSkillViewCellTableViewCell";
    AddSkillViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SkillTemplate *currentSkill = self.dropDownDataSource[indexPath.row];
    
    if (!cell)
    {
        cell = [[AddSkillViewCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.skillTemplate = currentSkill;
    Skill *existingSkill = [[SkillManager sharedInstance] getSkillWithTemplate:currentSkill withSkillSet:self.skillSet];
    if (!existingSkill) {
        cell.shouldDeleteSkill = false;
    }
    else {
        cell.shouldDeleteSkill = true;
    }
    return cell;
}

#pragma mark AddSkillViewCellTableViewCell delegate methods
-(BOOL)addThisSkill:(SkillTemplate *)skillTemplate sender:(AddSkillViewCellTableViewCell *)cell
{
    if ([self.delegateAddNewSkill addNewSkillWithTemplate:skillTemplate]) {
        UITableView *tableView = self.dropDownTableView;
        [cell setAddSkillButtonToDeleteWithAnimationCompletion:^{
            [tableView reloadData];
        }];
        return true;
    } 
    else {
        return false;
    }
    
}

-(BOOL)deleteThisSkill:(SkillTemplate *)skillTemplate sender:(AddSkillViewCellTableViewCell *)cell
{
    self.addSkillCellToProcessAlert = cell;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Forget skill?"
                                                   message: [NSString stringWithFormat:@"Are you sure you want to forget %@ skill? All progress in this skill and all sub skills will be lost.",cell.skillTemplate.name]
                                                  delegate: self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    return false;
}

-(void)showDescriptionForSkill:(SkillTemplate *)skillTemplate
{
    [[SkillManager sharedInstance] showDescriptionForSkillTemplate:skillTemplate inView:self.view.superview];
}

#pragma mark -
#pragma mark alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //yes
        [self.delegateAddNewSkill deleteNewSkillWithTemplate:self.addSkillCellToProcessAlert.skillTemplate];
        if (self.addSkillCellToProcessAlert) {
            UITableView *tableView = self.dropDownTableView;
            [self.addSkillCellToProcessAlert setAddSkillButtonToAddWithAnimationCompletion:^{
                [tableView reloadData];
            }];
        }
    }
    self.addSkillCellToProcessAlert = nil;
}

@end
