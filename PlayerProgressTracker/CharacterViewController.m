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
#import "SkillTemplateDiskData.h"
#import "SkillTreeViewController.h"
#import "MainContextObject.h"
#import "Constants.h"
#import "SkillLevelsSetManager.h"
#import "SkillLevelsSet.h"


@interface CharacterViewController ()

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) SkillTreeViewController *skillTreeController;

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
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    self.view.layer.contents = (id)[UIImage imageWithContentsOfFile:filePathWithName(@"nightSky.png")].CGImage;
    self.view.layer.masksToBounds = true;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[SkillManager sharedInstance] subscribeForSkillsChangeNotifications:self];
    
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
        
        _skillTreeController = [[SkillTreeViewController alloc] init];
        [self addChildViewController:_skillTreeController];
        [self.view addSubview:_skillTreeController.view];
        _skillTreeController.view.frame = self.view.bounds;
        _skillTreeController.customHeaderStatLayoutY = 0;
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
    _character = character;
    if (_character) {
        [[SkillManager sharedInstance] checkAllCharacterCoreSkills:_character];
        self.skillTreeController.character = character;
        [self.skillTreeController refreshSkillvaluesWithReloadingSkills:true];
    }
}

@end
