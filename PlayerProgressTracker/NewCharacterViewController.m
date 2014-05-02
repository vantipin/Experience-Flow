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
#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "AddSkillDropViewController.h"
#import "WeaponChoiceDropViewController.h"


@interface NewCharacterViewController ()

@property (nonatomic,strong) Character *character;
@property (nonatomic,strong) ClassesDropViewController *classesDropController;
@property (nonatomic) AddSkillDropViewController *addNewSkillDropController;
@property (nonatomic) WeaponChoiceDropViewController *setWeaponDropDownViewController;
@property (nonatomic,strong) NSMutableArray *raceNames;
@property (nonatomic,strong) UITextField *alertTextField; //weak link break standart delegate methode - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
@property (nonatomic,strong) SkillTableViewController *skillTableViewController;
@property (nonatomic) BOOL shouldRewriteSkillsLevels; //for cases when player tap race button;
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) StatView *statView;
@property (nonatomic) CharacterDollViewController *dollController;

@property (nonatomic) UITextField *currentlyEditingField; //for applying changes when (save) buttons tapped

@end

@implementation NewCharacterViewController

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
    self.shouldRewriteSkillsLevels = true;
    self.skillTableViewController.skillSet =  self.character.skillSet;
    self.skillTableViewController.skillTableDelegate = self;
    [self addChildViewController:self.skillTableViewController];
    
    self.classesDropController.delegateDropDown = self;
    self.classesDropController.delegateDeleteStatSet = self;
    [self.view addSubview:self.classesDropController.view];
    
    self.addNewSkillDropController.delegateDropDown = self;
    [self.view addSubview:self.addNewSkillDropController.view];
    
    self.setWeaponDropDownViewController.delegateDropDown = self;
    [self.view addSubview:self.setWeaponDropDownViewController.view];
    
    self.statView.settable = true;
    self.statView.executer = self;
    
    self.name.delegate = self;
    self.name.text = self.character.name;
    
    self.characterSheetView.backgroundColor = bodyColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.statView initFields];
    
    self.statView.character = self.character;//setter will update interface
    [self updateRaceButtonWithName:[self.raceNames lastObject]];
    self.dollController.character = self.character;

//    //TODO
//    [_character addToCurrentMeleeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] ordinary] withContext:self.context];
//    [_character setCurrentRangeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] bow] withContext:self.context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(StatView *)statView
{
    if (!_statView) {
        _statView = [[StatView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)];
        [self.statViewContainer addSubview:_statView];
    }
    return _statView;
}

-(CharacterDollViewController *)dollController
{
    if (!_dollController) {
        CGRect frame = CGRectMake(320, 0, 400, 360);
        _dollController = [CharacterDollViewController getInstanceFromStoryboardWithFrame:frame];
        [self addChildViewController:_dollController];
        [self.statViewContainer addSubview:_dollController.view];
        self.dollController.delegateTapSegment = self;
    }
    
    return _dollController;
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _context;
}

-(Character *)character
{
    if (!_character) {
        NSArray *arrayOfUnfinishedCharacters = [Character fetchUnfinishedCharacterWithContext:self.context];
        if (arrayOfUnfinishedCharacters.count != 0){
            _character = [arrayOfUnfinishedCharacters lastObject];
            [[SkillManager sharedInstance] checkAllCharacterCoreSkills:_character];
        }
        else{
            _character = [Character newCharacterWithContext:self.context];
        }
    }
    else{
        //[Character saveContext:self.context];
    }
    
    return _character;
}

-(NSMutableArray *)raceNames
{
    if (!_raceNames) {
        _raceNames = [NSMutableArray new];
    }
    return  _raceNames;
}

-(ClassesDropViewController *)classesDropController
{
    if(!_classesDropController) {
        _classesDropController = [[ClassesDropViewController alloc] initWithArrayData:self.raceNames
                                                        cellHeight:30
                                                    widthTableView:self.raceBtn.frame.size.width
                                                           refView:self.raceBtn animation:AlphaChange
                                                   backGroundColor:lightBodyColor];
    }
    return _classesDropController;
}

-(WeaponChoiceDropViewController *)setWeaponDropDownViewController
{
    if (!_setWeaponDropDownViewController) {
        UIFont *font = [UIFont fontWithName:@"Noteworthy-Bold" size:18];
        _setWeaponDropDownViewController = [[WeaponChoiceDropViewController alloc] initWithArrayData:[NSArray new]
                                                                                          cellHeight:40
                                                                                      widthTableView:200
                                                                                             refView:self.view
                                                                                           animation:AlphaChange
                                                                                     backGroundColor:lightBodyColor];
        _setWeaponDropDownViewController.font = font;
    }
    return _setWeaponDropDownViewController;
}

-(AddSkillDropViewController *)addNewSkillDropController
{
    if (!_addNewSkillDropController) {
        _addNewSkillDropController = [[AddSkillDropViewController alloc] initWithArrayData:[[DefaultSkillTemplates sharedInstance] allNoneCoreSkillTemplates]
                                                                          withSkillSet:self.character.skillSet
                                                                    withWidthTableView:320
                                                                            cellHeight:48
                                                                           withRedView:self.addNewSkillButton
                                                                         withAnimation:AlphaChange];
        _addNewSkillDropController.delegateAddNewSkill = self;
        _addNewSkillDropController.view.backgroundColor = lightBodyColor;
    }
    return _addNewSkillDropController;
}

-(SkillTableViewController *)skillTableViewController
{
    if (!_skillTableViewController) {
        _skillTableViewController = [SkillTableViewController new];
        [self.additionalSkillContainerView addSubview:_skillTableViewController.view];
        _skillTableViewController.view.frame = self.additionalSkillContainerView.bounds;
        self.additionalSkillContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _skillTableViewController.view.backgroundColor = lightBodyColor;
    }
    
    return _skillTableViewController;
}

-(void)refreshRaceNames
{
    [self.raceNames removeAllObjects];
    NSArray *arraySet = [NSMutableArray arrayWithArray:[SkillSet fetchCharacterlessSkillSetsWithContext:self.context]];
    for (SkillSet *set in arraySet){
        if (set.name) {
            [_raceNames addObject:set.name];
        }
        
    }
}
- (void)updateRaceButtonWithName:(NSString *)currentTitle
{
    [self refreshRaceNames];
    
    if (self.raceNames.count == 0 || !self.shouldRewriteSkillsLevels) {
        //no statSet is available or character's skills set statSet
        [self.statView setViewFromSkillSet];
        [self prepareViewForSavingNewClass];
    }
    else {
        if ([self.raceNames indexOfObject:currentTitle] == NSNotFound) {
            currentTitle = [self.raceNames lastObject];
        }
        
        SkillSet *statSet = [[SkillSet fetchSkillSetWithName:currentTitle withContext:self.context] lastObject];
        [self setSkillSet:statSet forCharacter:self.character];
        
        self.shouldRewriteSkillsLevels = false;
        [self dissmissSavingNewRace];
    }
    
    if (!currentTitle) {
        currentTitle = @"Choose Set";
    }
    [self.raceBtn setTitle:currentTitle forState:UIControlStateNormal];
}

-(void)setSkillSet:(SkillSet *)skillSet forCharacter:(Character *)character;
{
    SkillSet *formerSet = self.statView.character.skillSet;
    self.statView.character.skillSet = [[SkillManager sharedInstance] cloneSkillsWithSkillSet:skillSet];
    [SkillSet deleteSkillSet:formerSet withContext:self.context];
    
    [character saveCharacterWithContext:self.context];
    
    self.skillTableViewController.skillSet =  character.skillSet;
    [self.statView setViewFromSkillSet];
    
    [self.dollController updateSkillValues];
    [self.skillTableViewController.tableView reloadData];
    
    self.addNewSkillDropController.skillSet = character.skillSet;
}


-(void)prepareViewForSavingNewClass
{
    //prepare setting character skills to listed in stat set
    self.shouldRewriteSkillsLevels = true;
    //self.raceBtn.alpha = 0;
    
    if (self.saveSet.alpha < 1) {
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
        } completion:^(BOOL success) {
            if (success){
                self.saveSet.frame = CGRectMake(self.saveSet.frame.origin.x + 100, self.saveSet.frame.origin.y, self.saveSet.frame.size.width, self.saveSet.frame.size.height);
            }
        }];
    }
    //self.raceBtn.alpha = 1;
}

-(void)saveCurrentStatSetWithName:(NSString *)nameString
{
    SkillSet *skillSet;
    NSArray *array = [SkillSet fetchSkillSetWithName:nameString withContext:self.context];
    if (array && array.count != 0) {
        SkillSet *existingSkillSet = [array lastObject];
        [SkillSet deleteSkillSet:existingSkillSet withContext:self.context];
    }
    
    skillSet = [[SkillManager sharedInstance] cloneSkillsWithSkillSet:self.character.skillSet];
    skillSet.name = nameString;
    
    [SkillSet saveContext:self.context];
    //set current name to recently saved one
    [self updateRaceButtonWithName:nameString];
}

-(IBAction)saveStatSetBtn:(id)sender
{
    [self resignCurrentTextFieldResponder];
    
    if ([self.statView nonEmptyStats]) {
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
    [self resignCurrentTextFieldResponder];
    
    if (self.raceNames.count != 0) {
        if (self.classesDropController.view.hidden) {
            [self.classesDropController openAnimation];
        }
        else {
            [self.classesDropController closeAnimation];
        }
    }
}

-(IBAction)addNewSkillTapped:(id)sender
{
    [self resignCurrentTextFieldResponder];
    
    if (self.addNewSkillDropController.view.hidden) {
        [self.addNewSkillDropController openAnimation];
    }
    else {
        [self.addNewSkillDropController closeAnimation];
    }
}
#pragma mark -
#pragma mark skill table delegate
-(void)didUpdateCharacterSkills
{
    self.shouldRewriteSkillsLevels = false;
    [self updateRaceButtonWithName:nil];
    [self.statView setViewFromSkillSet];
    [self.dollController updateSkillValues];
}

#pragma mark -
#pragma mark alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //save button
    if (buttonIndex == 1) {
        //save
        [self saveCurrentStatSetWithName:[[alertView textFieldAtIndex:0] text]];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (self.alertTextField.text.length != 0) {
        return true;
    }
    else {
        return false;
    }
    
}

#pragma mark dropDown methods
-(void)dropDownController:(DropDownViewController *)dropDown cellSelected:(NSIndexPath *)returnIndex
{
    if (dropDown == self.addNewSkillDropController) {
        SkillTemplate *skillTemplate = [self.addNewSkillDropController.dropDownDataSource objectAtIndex:returnIndex.row];
        NSLog(@"%@",skillTemplate.name);
    }
    else if (dropDown == self.classesDropController) {
        NSString *name = self.raceNames[returnIndex.row];
        self.shouldRewriteSkillsLevels = true;
        [self updateRaceButtonWithName:name];
    }
    else if (dropDown == self.setWeaponDropDownViewController) {
        if (returnIndex.section == 0) {
            SkillTemplate *meleeWeaponTemplate = self.setWeaponDropDownViewController.meleeSkills[returnIndex.row];
            MeleeSkill *meleeSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:meleeWeaponTemplate withCharacter:self.character];
            
            DollActiveSegment *currentSegment = (DollActiveSegment *)dropDown.anchorView;
            currentSegment.currentSkill = meleeSkill;
        }
        else if (returnIndex.section == 1) {
            SkillTemplate *rangeWeaponTemplate = self.setWeaponDropDownViewController.rangeSkills[returnIndex.row];
            RangeSkill *rangeSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:rangeWeaponTemplate withCharacter:self.character];
            
            DollActiveSegment *currentSegment = (DollActiveSegment *)dropDown.anchorView;
            currentSegment.currentSkill = rangeSkill;
        }
        
    }
}

-(void)deleteStatSetWithName:(NSString *)name
{
    if ([SkillSet deleteSkillSetWithName:name withContext:self.context]) {
        [self.classesDropController openAnimation];
        [self refreshRaceNames];
        [self updateRaceButtonWithName:[self.raceNames lastObject]];
    }
}

#pragma mark -
#pragma mark textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //No empty inputs;
    if (textField.text.length == 0) {
        return true;
    }
    
    [textField resignFirstResponder];
    return false;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.currentlyEditingField = nil;
    if (textField) {
        if (textField == self.name) {
            self.character.name = textField.text;
            [Character saveContext:self.context];
        }
        else if ([self.statView isTextFieldInStatView:textField]) {
            if (textField.text.length == 0) {
                return false;
            }
            else if ([self.statView isTextFieldIsSkillToSet:textField]) {
                [self.statView setSkillFromTextView:textField];
            }
            else {
                [self.statView setSkillSetFromView];
            }
        }
        return true;
    }
    [textField resignFirstResponder];
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([self.statView isTextFieldInStatView:textField]) {
        //from here filter stat input. Only number. Max 2 numbers
        NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound || newLength > 2) {
            [textField resignFirstResponder];
            return false;
        }
        //suggest new stat set
        [self prepareViewForSavingNewClass];
        return true;
    }
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentlyEditingField = textField;
    return true;
}

-(void)resignCurrentTextFieldResponder;
{
    if (self.currentlyEditingField) {
        [self.currentlyEditingField resignFirstResponder];
    }
}

#pragma mark AddNewSkillControllerProtocol delegate methods

-(BOOL)addNewSkillWithTemplate:(SkillTemplate *)skillTemplate
{
    Skill *skill = [[SkillManager sharedInstance] addNewSkillWithTempate:skillTemplate toSkillSet:self.character.skillSet withContext:self.context];
    if (skill) {
        [self prepareViewForSavingNewClass];
        return true;
    }
    else {
        return false;
    }
}

-(BOOL)deleteNewSkillWithTemplate:(SkillTemplate *)skillTemplate
{
    BOOL deleted = [[SkillManager sharedInstance] removeSkillWithTemplate:skillTemplate fromSkillSet:self.character.skillSet withContext:self.context];
    if (deleted) {
        [self prepareViewForSavingNewClass];
        return true;
    }
    else {
        return false;
    }
}

#pragma mark doll protocol
-(void)didTapActiveSegment:(DollActiveSegment *)segment
{
    if (self.setWeaponDropDownViewController.view.hidden) {
        self.setWeaponDropDownViewController.anchorView = segment;
        [self.setWeaponDropDownViewController openAnimation];
    }
    else {
        [self.setWeaponDropDownViewController closeAnimation];
    }
}


-(void)allFontsToConsole
{
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

@end
