//
//  CharacterViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 05.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterViewController.h"

#import "SkillSet.h"
#import "DefaultSkillTemplates.h"
#import "SkillTemplateDataArchiver.h"
#import "SkillTreeViewController.h"
#import "MainContextObject.h"
#import "Constants.h"
#import "SkillLevelsSetManager.h"
#import "SkillLevelsSet.h"
#import "CustomImagePickerViewController.h"
#import "CharacterDataArchiver.h"
#import "iCloud.h"
#import "UserDefaultsHelper.h"
#import "PicManager.h"

static const float HEADER_LAYOUT_HIDDEN = 20;
static const float HEADER_LAYOUT_SHOWN = 100;
static const float HEADER_LAYOUT_SHOWN_iPHONE = 55;

@interface CharacterViewController ()

@property (nonatomic) IBOutlet UIButton *raceBtn;
@property (nonatomic) IBOutlet UILabel  *raceLabel;
@property (nonatomic) IBOutlet UIButton *saveSet;
@property (nonatomic) IBOutlet UIButton *saveCharacter;
@property (nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic) IBOutlet UIView *characterSheetView;
@property (nonatomic) IBOutlet UIView *statViewContainer;
@property (nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,strong) ClassesDropViewController *classesDropController;
@property (nonatomic,strong) NSMutableArray *raceNames;
@property (nonatomic,strong) UITextField *alertTextField; //weak link break standart delegate methode - (BOOL)textFieldShouldEndEditing:(UITextField *)textField
@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) UITextField *currentlyEditingField; //for applying changes when (save) buttons tapped
@property (nonatomic) SkillTreeViewController *skillTreeController;
@property (nonatomic) CharacterDataArchiver *progressArchiver;

@property (nonatomic) UIAlertView *statSaveAlert;
@property (nonatomic) UIAlertView *characterSaveAlert;
@property (nonatomic) UIAlertView *progressReplaceAlert;

@property (nonatomic,strong) Character *character;

@property (nonatomic) BOOL isNewCharacterMode;

@end

@implementation CharacterViewController

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
    
    [[SkillManager sharedInstance] checkAllCharacterCoreSkills:self.character];
    self.isNewCharacterMode = false;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    
    //[self allFontsToConsole];
    
    [DefaultSkillTemplates sharedInstance].shouldUpdate = true;
    
    
    self.classesDropController.delegateDropDown = self;
    self.classesDropController.delegateDeleteStatSet = self;
    [self.view addSubview:self.classesDropController.view];
    
    self.nameTextField.delegate = self;
    self.nameTextField.text = self.character.name;
    
    CALayer *imageLayer = self.icon.layer;
    [imageLayer setCornerRadius:14];
    [imageLayer setMasksToBounds:YES];
    
    CALayer *textViewLayer = self.nameTextField.layer;
    [textViewLayer setCornerRadius:5];
    [textViewLayer setMasksToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[SkillManager sharedInstance] subscribeForSkillsChangeNotifications:self];
    [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];
    
    
//    [CharacterProgressDataArchiver saveData:self.character toPath:self.myUbiquityContainer.absoluteString];
//    self.progressArchiver = [CharacterProgressDataArchiver newCharacterWithDocPath:[self.myUbiquityContainer.absoluteString stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",self.character.characterId]]
//                                                    withConflictResolverController:self
//                                                                       withContext:self.context];
    
    //    for (SkillTemplate *skillTemplate in [DefaultSkillTemplates sharedInstance].allNoneCoreSkillTemplates) {
    //        [SkillTemplateDiskData saveData:skillTemplate toPath:[SkillTemplateDiskData getPrivateDocsDir]];
    //    }
    
    //NSMutableArray *allskill = [SkillTemplateDiskData loadSkillTemplates];
    //    //TODO
    //    [_character addToCurrentMeleeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] ordinary] withContext:self.context];
    //    [_character setCurrentRangeSkillWithTempate:[[DefaultSkillTemplates sharedInstance] bow] withContext:self.context];
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.character saveCharacterWithContext:self.context];
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
        
        _skillTreeController = [[SkillTreeViewController alloc] initWithCharacter:self.character];
        _skillTreeController.customHeaderStatLayoutY = 20;
        _skillTreeController.isInCreatingNewCharacterMod = false;
        [self addChildViewController:_skillTreeController];
        [self.view addSubview:_skillTreeController.view];
        _skillTreeController.view.frame = self.view.bounds;
        [self.view sendSubviewToBack:_skillTreeController.view];
        
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

-(void)setCharacter:(Character *)character
{
    if (character) {
        if (_character != character) {
            _character = character;
            [[SkillManager sharedInstance] checkAllCharacterCoreSkills:_character];
            self.skillTreeController.character = self.character;
        }
        [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];
    }
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
                                                                           cellHeight:isiPad ? 40 : 30
                                                                       widthTableView:self.raceBtn.frame.size.width
                                                                              refView:self.raceBtn animation:AlphaChange
                                                                      backGroundColor:kRGB(240, 240, 240, 0.6)];
    }
    return _classesDropController;
}

-(void)setIsNewCharacterMode:(BOOL)isNewCharacterMode
{
    _isNewCharacterMode = isNewCharacterMode;
    [self triggerInterfaceModes];
}

#pragma mark ViewControllers modes
-(void)selectNewCharacter
{
    if (!self.isNewCharacterMode) {
        Character *newCharacter;
        NSArray *arrayOfUnfinishedCharacters = [Character fetchUnfinishedCharacterWithContext:self.context];
        [self refreshRaceNames];
        if (arrayOfUnfinishedCharacters.count != 0){
            newCharacter = [arrayOfUnfinishedCharacters lastObject];
            self.character = newCharacter;
            self.isNewCharacterMode = true;
            [self updateRaceButtonWithName:nil];
        }
        else{
            newCharacter = [Character newCharacterWithContext:self.context];
            self.character = newCharacter;
            self.isNewCharacterMode = true;
            [self updateRaceButtonWithName:nameBeggar];
        }
        self.character = newCharacter;
        self.nameTextField.text = @"";
    }

}


-(void)selectCharacter:(Character *)character
{
    if (character) {
        self.character = character;
        self.isNewCharacterMode = false;
    }
    else {
        [self selectNewCharacter];
    }
}

-(void)triggerInterfaceModes
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect newHeaderFrame = self.headerView.frame;
        float alpha = self.isNewCharacterMode ? 1 : 0;
        newHeaderFrame.origin.y = self.isNewCharacterMode ? 0 : - newHeaderFrame.size.height;
        self.headerView.frame = newHeaderFrame;
        self.headerView.alpha = alpha;
        
        self.skillTreeController.isInCreatingNewCharacterMod = self.isNewCharacterMode;
        float newLayout = self.isNewCharacterMode ? (isiPad ? HEADER_LAYOUT_SHOWN : HEADER_LAYOUT_SHOWN_iPHONE) : HEADER_LAYOUT_HIDDEN;
        [self.skillTreeController changeYStatLayout:newLayout animated:false];
    }];
}


#pragma mark
-(void)refreshRaceNames
{
    [self.raceNames removeAllObjects];
    NSArray *arraySet = [[SkillLevelsSetManager sharedInstance] getLevelSets];
    for (SkillLevelsSet *set in arraySet){
        if (set.name) {
            [_raceNames addObject:set.name];
        }
    }
}
- (void)updateRaceButtonWithName:(NSString *)currentTitle
{
    if (self.isNewCharacterMode) {
        [self refreshRaceNames];
        
        BOOL isAPartOfSkillSets = ([self.raceNames indexOfObject:currentTitle] != NSNotFound);
        if (self.raceNames.count == 0 || !isAPartOfSkillSets || !currentTitle) {
            //no statSet is available or character's skills set statSet
            currentTitle = self.character.skillSet.name;
            [self prepareViewForSavingNewClass];
        }
        else {
            [self setSkillSet:currentTitle];
            [self dissmissSavingNewRace];
        }
        
        currentTitle = self.character.skillSet.name ? self.character.skillSet.name : @"Choose Set";
        
        [self.raceBtn setTitle:currentTitle forState:UIControlStateNormal];
    }
}

-(void)setSkillSet:(NSString *)skillSet
{
    [[SkillLevelsSetManager sharedInstance] loadLevelsSetNamed:skillSet forCharacter:self.character];
    self.character.skillSet.name = skillSet;
    
    [self.character saveCharacterWithContext:self.context];
    [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];                //update skill tree
    [self.skillTreeController resetPointsLeftProgress];
}


-(void)saveCurrentStatSetWithName:(NSString *)nameString
{
    NSMutableDictionary *skillSet = [NSMutableDictionary new];
    for (Skill *skill in self.character.skillSet.skills) {
        if (skill.currentLevel != skill.skillTemplate.defaultLevel) {
            [skillSet setValue:@(skill.currentLevel) forKey:skill.skillTemplate.name];
        }
    }
    
    self.character.skillSet.name = nameString;
    [[SkillLevelsSetManager sharedInstance] saveSkillLevelsSet:[skillSet copy] withName:nameString];
    
    //set current name to recently saved one
    [self updateRaceButtonWithName:nameString];
    [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];
}

-(void)prepareViewForSavingNewClass
{
    //prepare setting character skills to listed in stat set
    
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
    
    self.statSaveAlert = [[UIAlertView alloc]initWithTitle: @"New basic stat set"
                                                   message: @"Save new set with name:"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Save",nil];
    self.statSaveAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    self.alertTextField = [self.statSaveAlert textFieldAtIndex:0];
    self.alertTextField.delegate = self; //to forbit saving empty name
    
    [self.statSaveAlert show];
    
}

-(IBAction)saveButtonTap:(id)sender
{
    [self resignCurrentTextFieldResponder];
    
    if (self.nameTextField.text.length) {
        self.characterSaveAlert = [[UIAlertView alloc]initWithTitle: @"Save Character?"
                                                            message: @"Are you sure you want to save this character?"
                                                           delegate: self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Save",nil];
        
        [self.characterSaveAlert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Name Missing."
                                                            message: @"Please, give a name to your character."
                                                           delegate: self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
        
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

#pragma mark -
#pragma mark alert delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //save button
    if (buttonIndex == 1) {
        
        if (alertView == self.statSaveAlert) {
            //save
            [self saveCurrentStatSetWithName:[[alertView textFieldAtIndex:0] text]];
        }
        else if (alertView == self.characterSaveAlert) {
            self.character.characterFinished = true;
            [self.character saveCharacterWithContext:self.context];
            [UserDefaultsHelper clearTempDataForCharacterId:self.character.characterId];
            
            if ([[iCloud sharedCloud] checkCloudAvailability]) {
                [self saveCharacterAsArchiveOniCloud];
            }
            
            [self.navigationController popToRootViewControllerAnimated:true];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:DID_UPDATE_CHARACTER_LIST object:self];
        }
        
    }
    
    self.characterSaveAlert = nil;
    self.statSaveAlert = nil;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView == self.statSaveAlert) {
        if (self.alertTextField.text.length != 0) {
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return true;
    }
}

#pragma mark dropDown methods
-(void)dropDownController:(DropDownViewController *)dropDown cellSelected:(NSIndexPath *)returnIndex
{
    if (dropDown == self.classesDropController) {
        NSString *name = self.raceNames[returnIndex.row];
        [self updateRaceButtonWithName:name];
    }
}

#pragma mark textfield delegate methods

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.currentlyEditingField = nil;
    if (textField) {
        if (textField == self.nameTextField) {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark DeleteStatSetProtocol
-(void)deleteStatSetWithName:(NSString *)name
{
    if ([[SkillLevelsSetManager sharedInstance] deleteSkillSetWithName:name]) {
        if ([self.character.skillSet.name isEqualToString:name]) {
            self.character.skillSet.name = nil;
        }
        [self.classesDropController openAnimation];
        [self refreshRaceNames];
        [self updateRaceButtonWithName:nil];
    }
}

#pragma mark SkillChangeProtocol
-(void)didFinishChangingExperiencePointsForSkill:(Skill *)skill
{
    if (self.isNewCharacterMode) {
        [self prepareViewForSavingNewClass];
    }
    else {
        [self saveCharacterAsArchiveOniCloud];
    }
}

-(void)allFontsToConsole
{
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSString *fontName = name;
            NSLog(@"  %@", fontName);
        }
    }
}


-(IBAction)imageTap:(id)sender
{
    CustomImagePickerViewController * picker = [[CustomImagePickerViewController alloc] init];
    picker.view.frame = self.view.bounds;
    
	picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;

	[self presentViewController:picker animated:true completion:^{
        
    }];
}

#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:true completion:^{
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImagePNGRepresentation(image);
        UIImage *scaled = [PicManager scaleImage:image toSize:self.icon.frame.size];
        imageData = UIImagePNGRepresentation(scaled);
        [self.icon setImage:scaled];
    }];
}


#pragma mark saving onicloud methods
-(void)saveCharacterAsArchiveOniCloud
{
    NSString *characterId = self.character.characterId;
    NSString *documentName = [NSString stringWithFormat:@"%@.plist",characterId];
    NSData *content = [CharacterDataArchiver chracterToDictionaryData:self.character];
    
    [[iCloud sharedCloud] saveAndCloseDocumentWithName:documentName withContent:content completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                [UserDefaultsHelper setUpdateDate:cloudDocument.fileModificationDate forFileName:cloudDocument.localizedName];
            }
            else {
//                NSMutableArray *toSave = [UserDefaultsHelper characterIdsToSave];
//                if (!toSave) {
//                    toSave = [NSMutableArray new];
//                }
//                if ([toSave indexOfObject:characterId] == NSNotFound) {
//                    [toSave addObject:characterId];
//                }
//                [UserDefaultsHelper setCharacterIdsToSave:toSave];
            }
            
        });
    }];
}

-(IBAction)tapHealthArea:(id)sender
{
    [self.skillTreeController didTapHealth];
}

-(IBAction)tapInventoryArea:(id)sender
{
    [self.skillTreeController didTapInventory];
}

-(IBAction)tapMovementArea:(id)sender
{
    [self.skillTreeController didTapMovement];
}

-(IBAction)tapInitiativeArea:(id)sender
{
    [self.skillTreeController didTapInitiative];
}

@end
