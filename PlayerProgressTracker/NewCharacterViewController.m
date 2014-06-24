//
//  NewCharacterViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "NewCharacterViewController.h"

#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "SkillTemplateDiskData.h"
#import "SkillTreeViewController.h"
#import "MainContextObject.h"
#import "ColorConstants.h"


@interface NewCharacterViewController ()

@property (nonatomic) IBOutlet UIButton *raceBtn;
@property (nonatomic) IBOutlet UILabel  *raceLabel;
@property (nonatomic) IBOutlet UIButton *saveSet;
@property (nonatomic) IBOutlet UIButton *saveCharacter;
@property (nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UIView *characterSheetView;
@property (nonatomic) IBOutlet UIView *statViewContainer;
@property (nonatomic) IBOutlet UIView *additionalSkillContainerView;


@property (nonatomic,strong) Character *character;
@property (nonatomic,strong) ClassesDropViewController *classesDropController;
@property (nonatomic,strong) NSMutableArray *raceNames;
@property (nonatomic,strong) UITextField *alertTextField; //weak link break standart delegate methode - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) UITextField *currentlyEditingField; //for applying changes when (save) buttons tapped
@property (nonatomic) SkillTreeViewController *skillTreeController;
@property (nonatomic) BOOL shouldRewriteSkillsLevels;

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
    
    //[[SkillManager sharedInstance] clearSkillTemplate];
    [DefaultSkillTemplates sharedInstance].shouldUpdate = true;;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    
    self.shouldRewriteSkillsLevels = true;
    
    self.classesDropController.delegateDropDown = self;
    self.classesDropController.delegateDeleteStatSet = self;
    [self.view addSubview:self.classesDropController.view];
    
    self.name.delegate = self;
    self.name.text = self.character.name;
    
    CALayer *imageLayer = self.icon.layer;
    [imageLayer setCornerRadius:20];
    [imageLayer setMasksToBounds:YES];
    

    CALayer *textViewLayer = self.name.layer;
    [textViewLayer setCornerRadius:8];
    [textViewLayer setMasksToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[SkillManager sharedInstance] subscribeForSkillsChangeNotifications:self];
    
    [self updateRaceButtonWithName:[self.raceNames lastObject]];
    self.skillTreeController.character = self.character;
    //[self.skillTreeController resetSkillNodes];
//    for (SkillTemplate *skillTemplate in [DefaultSkillTemplates sharedInstance].allNoneCoreSkillTemplates) {
//        [SkillTemplateDiskData saveData:skillTemplate toPath:[SkillTemplateDiskData getPrivateDocsDir]];
//    }
    
      //NSMutableArray *allskill = [SkillTemplateDiskData loadSkillTemplates];
//    //TODO
//    [_character addToCurrentMeleeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] ordinary] withContext:self.context];
//    [_character setCurrentRangeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] bow] withContext:self.context];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[SkillManager sharedInstance] unsubscribeForSkillChangeNotifications:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(SkillTreeViewController *)skillTreeController
{
    if (!_skillTreeController) {
        
        _skillTreeController = [[SkillTreeViewController alloc] init];
        [self addChildViewController:_skillTreeController];
        [self.additionalSkillContainerView addSubview:_skillTreeController.view];
        _skillTreeController.view.frame = self.additionalSkillContainerView.bounds;
    }
    
    return _skillTreeController;
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
    SkillSet *formerSet = self.character.skillSet;
    [SkillSet deleteSkillSet:formerSet withContext:self.context];
    character.skillSet = [[SkillManager sharedInstance] cloneSkillsWithSkillSet:skillSet];
    
    
    [character saveCharacterWithContext:self.context];
    
    [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];                //update skill tree
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
    [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];
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

-(IBAction)saveStatSetBtn:(id)sender
{
    [self resignCurrentTextFieldResponder];
    
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
    if (dropDown == self.classesDropController) {
        NSString *name = self.raceNames[returnIndex.row];
        self.shouldRewriteSkillsLevels = true;
        [self updateRaceButtonWithName:name];
    }
}

#pragma mark -
#pragma mark textfield delegate methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.currentlyEditingField = nil;
    if (textField) {
        if (textField == self.name) {
            self.character.name = textField.text;
            [Character saveContext:self.context];
        }
        return true;
    }
    [textField resignFirstResponder];
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

#pragma mark DeleteStatSetProtocol
-(void)deleteStatSetWithName:(NSString *)name
{
    if ([SkillSet deleteSkillSetWithName:name withContext:self.context]) {
        [self.classesDropController openAnimation];
        [self refreshRaceNames];
        [self updateRaceButtonWithName:[self.raceNames lastObject]];
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


#pragma mark SkillChangeProtocol
-(void)didFinishChangingExperiencePointsForSkill:(Skill *)skill
{
    [self prepareViewForSavingNewClass];
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


-(IBAction)imageTap:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.view.frame = self.view.bounds;
    
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentViewController:picker animated:true completion:^{}];
}

#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.icon.contentMode = UIViewContentModeScaleToFill;
        [self.icon setImage:image];
    }];
}

@end
