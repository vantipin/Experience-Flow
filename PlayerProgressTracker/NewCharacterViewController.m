//
//  NewCharacterViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "NewCharacterViewController.h"

#import "Character.h"
#import "Skill.h"
#import "MeleeSkill.h"
#import "RangeSkill.h"
#import "SkillTemplate.h"
#import "SkillTableViewController.h"
#import "CharacterConditionAttributes.h"


@interface NewCharacterViewController ()

@property (nonatomic,strong) Character *character;
@property (nonatomic,strong) StatSetDropDown *raceSetDropDown;
@property (nonatomic,strong) NSMutableArray *raceNames;
@property (nonatomic,strong) UITextField *alertTextField; //weak link break standart delegate methode - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
@property (nonatomic,strong) SkillTableViewController *skillTableViewController;
@property (nonatomic) BOOL shouldRewriteSkillsLevels; //for cases when player tap race button;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) StatView *statView;

@end

@implementation NewCharacterViewController

@synthesize name = _name;
@synthesize raceSetDropDown = _raceSetDropDown;
@synthesize raceNames = _raceNames;
@synthesize alertTextField = _alertTextField;
@synthesize skillTableViewController = _skillTableViewController;
@synthesize managedObjectContext = _managedObjectContext;


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
    
    //[self allFontsToConsole];
    //[StatSet deleteStatSetWithName:@"" withContext:self.managedObjectContext];
    
    //self.view.autoresizesSubviews = YES;
    //self.view.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
    self.shouldRewriteSkillsLevels = false;
    self.skillTableViewController.character = self.character;
    self.skillTableViewController.skillTableDelegate = self;
    
    self.raceSetDropDown.delegateDropDown = self;
    self.raceSetDropDown.delegateDeleteStatSet = self;
    [self.view addSubview:self.raceSetDropDown.view];
    
    
    self.statView.settable = true;
    self.statView.executer = self;
    self.statView.character = self.character;
    [self.statView initFields];
    [self.statView updateStatsFromCharacterObject];
    
    self.name.delegate = self;
    self.name.text = self.character.name;
    
    [self updateRaceButtonWithName:[self.raceNames lastObject]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(StatView *)statView
{
    if (!_statView) {
        _statView = [[StatView alloc] initWithFrame:self.statViewContainer.bounds];
        [self.statViewContainer addSubview:_statView];
    }
    return _statView;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext){
        _managedObjectContext = [[CoreDataViewController sharedInstance] managedObjectContext];
    }
    return _managedObjectContext;
}

-(Character *)character
{
    if (!_character){
        NSArray *arrayOfUnfinishedCharacters = [Character fetchUnfinishedCharacterWithContext:self.managedObjectContext];
        if (arrayOfUnfinishedCharacters.count != 0){
            _character = [arrayOfUnfinishedCharacters lastObject];
            [[WarhammerDefaultSkillSetManager sharedInstance] checkAllCharacterCoreSkills:_character];
            
            //TODO
            [_character addToCurrentMeleeSkillWithTempate:[[WarhammerDefaultSkillSetManager sharedInstance] ordinary] withContext:self.managedObjectContext];
            [_character setCurrentRangeSkillWithTempate:[[WarhammerDefaultSkillSetManager sharedInstance] bow] withContext:self.managedObjectContext];
        }
        else{
            _character = [Character newCharacterWithContext:self.managedObjectContext];
        }
    }
    else{
        [Character saveContext:self.managedObjectContext];
    }
    
    return _character;
}

-(NSMutableArray *)raceNames
{
    if (!_raceNames){
        _raceNames = [NSMutableArray new];
    }
    return  _raceNames;
}

-(StatSetDropDown *)raceSetDropDown
{
    if(!_raceSetDropDown){
        _raceSetDropDown = [[StatSetDropDown alloc] initWithArrayData:self.raceNames
                                                        cellHeight:30
                                                    widthTableView:self.raceBtn.frame.size.width
                                                           refView:self.raceBtn animation:AlphaChange
                                                   backGroundColor:lightBodyColor];
    }
    return _raceSetDropDown;
}

-(SkillTableViewController *)skillTableViewController
{
    if (!_skillTableViewController){
        _skillTableViewController = [SkillTableViewController new];
        [self.additionalSkillContainerView addSubview:_skillTableViewController.view];
        _skillTableViewController.view.frame = self.additionalSkillContainerView.bounds;
        self.additionalSkillContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _skillTableViewController;
}

-(void)refreshRaceNames
{
    [self.raceNames removeAllObjects];
    NSArray *arraySet = [NSMutableArray arrayWithArray:[StatSet fetchStatSetsWithContext:self.managedObjectContext]];
    for (StatSet *set in arraySet){
        if (set.name) {
            [_raceNames addObject:set.name];
        }
    }
}
- (void)updateRaceButtonWithName:(NSString *)currentTitle
{
    [self refreshRaceNames];
    
    if (self.raceNames.count == 0 || !self.shouldRewriteSkillsLevels){
        //no statSet is available or character's skills set statSet
        [self.statView updateStatsFromCharacterObject];
        currentTitle = @"";
        [self prepareViewForSavingNewRace];
    }
    else{
        if ([self.raceNames indexOfObject:currentTitle] == NSNotFound){
            currentTitle = [self.raceNames lastObject];
        }
        StatSet *statSet = [StatSet fetchStatSetWithName:currentTitle withContext:self.managedObjectContext];
        
        [self dissmissSavingNewRace];
        
        [[WarhammerDefaultSkillSetManager sharedInstance] setCharacterSkills:self.character withStatSet:statSet];
        [self.skillTableViewController.tableView reloadData];
        self.shouldRewriteSkillsLevels = false;
    }
    
    [self.raceBtn setTitle:currentTitle forState:UIControlStateNormal];
}

-(void)prepareViewForSavingNewRace
{
    if (self.saveSet.alpha < 1){
        self.saveSet.frame = CGRectMake(self.saveSet.frame.origin.x - 100, self.saveSet.frame.origin.y, self.saveSet.frame.size.width, self.saveSet.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.saveSet.alpha = 1;
            self.saveSet.frame = CGRectMake(self.saveSet.frame.origin.x + 100, self.saveSet.frame.origin.y, self.saveSet.frame.size.width, self.saveSet.frame.size.height);
        }];
        
    }
}

-(void)dissmissSavingNewRace
{
    if (self.saveSet.alpha == 1){
        [UIView animateWithDuration:0.3 animations:^{
            self.saveSet.alpha = 0;
            self.saveSet.frame = CGRectMake(self.saveSet.frame.origin.x - 100, self.saveSet.frame.origin.y, self.saveSet.frame.size.width, self.saveSet.frame.size.height);
        } completion:^(BOOL success){
            if (success){
                self.saveSet.frame = CGRectMake(self.saveSet.frame.origin.x + 100, self.saveSet.frame.origin.y, self.saveSet.frame.size.width, self.saveSet.frame.size.height);
            }
        }];
    }
}

-(void)saveCurrentStatSetWithName:(NSString *)nameString
{
    StatSet *statset = [StatSet createStatSetWithName:nameString
                                                withM:[self.statView.m.text intValue]
                                               withWs:[self.statView.ws.text intValue]
                                               withBS:[self.statView.bs.text intValue]
                                                withS:[self.statView.s.text intValue]
                                                withT:[self.statView.t.text intValue]
                                                withI:[self.statView.i.text intValue]
                                           withAMelee:[self.statView.aMelee.text intValue]
                                           withARange:[self.statView.aRange.text intValue]
                                                withW:[self.statView.w.text intValue]
                                               withLD:[self.statView.ld.text intValue]
                                          withContext:self.managedObjectContext];
    
    if (statset)
    {
        //set current name to recently saved one
        self.shouldRewriteSkillsLevels = true;
        [self updateRaceButtonWithName:nameString];
        [self dissmissSavingNewRace];
    }
}

-(IBAction)saveStatSetBtn:(id)sender
{
    if ([self.statView nonEmptyStats])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"New basic stat set"
                                                       message: @"Save new set with name:"
                                                      delegate: self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Save",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.alertTextField = [alert textFieldAtIndex:0];
        self.alertTextField.delegate = self; //to forbit saving empty name
        
        [alert show];
    }
}

-(IBAction)raceBtnTapped:(id)sender
{
    if (self.raceNames.count != 0)
    {
        if (self.raceSetDropDown.view.hidden)
        {
            [self.raceSetDropDown openAnimation];
        }
        else
        {
            [self.raceSetDropDown closeAnimation];
        }
    }
}

#pragma mark - 
#pragma mark skill table delegate
-(void)didUpdateCharacterSkills
{
    self.shouldRewriteSkillsLevels = false;
    [self updateRaceButtonWithName:nil];
}

#pragma mark -
#pragma mark alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) //save button
    {
        //save
        [self saveCurrentStatSetWithName:[[alertView textFieldAtIndex:0] text]];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.alertTextField.text.length != 0)
    {
        return true;
    }
    else
    {
        return false;
    }
    
}

#pragma mark dropDown methods
-(void)dropDownCellSelected:(NSInteger)returnIndex
{
    NSString *name = self.raceNames[returnIndex];
    self.shouldRewriteSkillsLevels = true;;
    [self updateRaceButtonWithName:name];

}

-(void)deleteStatSetWithName:(NSString *)name
{
    if ([StatSet deleteStatSetWithName:name withContext:self.managedObjectContext])
    {
        [self.raceSetDropDown openAnimation];
        [self updateRaceButtonWithName:[self.raceNames lastObject]];
    }
}

#pragma mark -
#pragma mark textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) //No empty inputs;
    {
        return true;
    }
    
    [textField resignFirstResponder];
    return false;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField)
    {
        if (textField == self.name)
        {
            self.character.name = textField.text;
            [Character saveContext:self.managedObjectContext];
        }
        else
        {
            if (textField.text.length == 0)
            {
                return false;
            }
        }
    }
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([self.statView.statContainerView.subviews containsObject:textField])
    {
        //from here filter stat input. Only number. Max 2 numbers
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound || newLength>2) {
            [textField resignFirstResponder];
            return false;
        }
        //suggest new stat set
        [self prepareViewForSavingNewRace];
        return true;
    }
    return true;
}

-(void)allFontsToConsole
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

@end
