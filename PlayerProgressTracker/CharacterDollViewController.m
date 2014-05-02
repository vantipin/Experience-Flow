//
//  CharacterDollViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterDollViewController.h"
#import "SkillManager.h"
#import "DefaultSkillTemplates.h"
#import "Skill.h"
#import "SkillTemplate.h"
#import "Character.h"
#import "SkillSet.h"
#import "CharacterConditionAttributes.h"

@interface CharacterDollViewController ()

@property (nonatomic) IBOutletCollection(UIView) NSArray *anchorsToHide;
@property (nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (nonatomic) IBOutlet UIView *leftHandAnchor;
@property (nonatomic) IBOutlet UIView *rightHandAnchor;

@property (nonatomic) IBOutlet UITextField *leftSkillTextField;
@property (nonatomic) IBOutlet UITextField *leftActionTextField;
@property (nonatomic) IBOutlet UITextField *leftDamageMeleeTextField;

@property (nonatomic) IBOutlet UITextField *rightSkillTextField;
@property (nonatomic) IBOutlet UITextField *rightActionTextField;
@property (nonatomic) IBOutlet UITextField *rightDamageMeleeTextField;


@property (nonatomic) NSMutableArray *characterSkillsInHands;

@property (nonatomic) NSMutableArray *currentMeleeSkills;
@property (nonatomic) NSMutableArray *currentRangeSkills;
@property (nonatomic) NSMutableArray *currentMagicSkills;
@property (nonatomic) NSMutableArray *currentPietySkills;



@end

@implementation CharacterDollViewController

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
    self.numberOfHands = 2; //default value;
    
    for (UIView *anchorToHide in self.anchorsToHide) {
        anchorToHide.hidden = true;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(CharacterDollViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DollStoryboard" bundle:nil];
    CharacterDollViewController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame =  frame;
    return controller;
}

-(NSMutableArray *)characterSkillsInHands
{
    if (!_characterSkillsInHands) {
        _characterSkillsInHands = [NSMutableArray new];
        for (int i = 0; i < self.numberOfHands; i ++) {
            [_characterSkillsInHands addObject:[self newHandSegmentForIndex:i]];
        }
    }
    
    return _characterSkillsInHands;
}

-(void)setNumberOfHands:(unsigned)numberOfHands
{
    _numberOfHands = numberOfHands;
    NSMutableArray *newArray = [NSMutableArray new];
    for (unsigned i = 0; i < _numberOfHands; i++) {
        [newArray addObject:self.characterSkillsInHands[i]];
    }
    self.characterSkillsInHands = newArray;
    [self redrawCurrentDamageStatViews];
}

-(DollActiveSegment *)newHandSegmentForIndex:(int)index;
{
    UIView *currentAnchorView;
    if (index % 2) {
        currentAnchorView = self.leftHandAnchor;
    }
    else {
        currentAnchorView = self.rightHandAnchor;
    }
    
    CGPoint center = self.view.center;
    int marginMultiplier = (index - 1) > 0 ? ((index - 1) / 2) : 0;
    marginMultiplier *= (center.x > currentAnchorView.center.x) ? 1 : -1;
    
    CGRect frame = CGRectMake(currentAnchorView.frame.origin.x + marginMultiplier * currentAnchorView.frame.size.width,
                              currentAnchorView.frame.origin.y + marginMultiplier * currentAnchorView.frame.size.height,
                              currentAnchorView.frame.size.width,
                              currentAnchorView.frame.size.height);
    DollActiveSegment *segment = [[DollActiveSegment alloc] initWithFrame:frame];
    
    [segment.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:15]];
    [segment.titleLabel setTextColor:[UIColor blackColor]];
    segment.backgroundColor = [UIColor redColor];
    [segment addTarget:self action:@selector(defaultTapAction:) forControlEvents:UIControlEventTouchUpInside];
    Skill *defaultSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[[DefaultSkillTemplates sharedInstance] unarmed] withCharacter:self.character];
    segment.delegateSegment = self;
    segment.currentSkill = defaultSkill;

    [self.view addSubview:segment];
    
    return segment;
}

-(void)didChangeActiveSegment:(DollActiveSegment *)segment
{
    if ([self.characterSkillsInHands containsObject:segment]) {
        if (segment.currentSkill) {
            NSString *title = [NSString stringWithFormat:@"%@",segment.currentSkill.skillTemplate.name];
            [segment setTitle:title forState:UIControlStateNormal];
            
            [self redrawCurrentDamageStatViews];
        }
    }
}


-(void)redrawCurrentDamageStatViews
{
    //for now it will calculate only left and right hand
    self.character.characterCondition.currentMeleeSkills = [NSSet new];
    for (DollActiveSegment *segment in self.characterSkillsInHands) {
        if ([segment.currentSkill isKindOfClass:[MeleeSkill class]]) {
            [self.character.characterCondition addCurrentMeleeSkillsObject:(MeleeSkill *)segment.currentSkill];
        }
        else if ([segment.currentSkill isKindOfClass:[RangeSkill class]]) {
            self.character.characterCondition.currentRangeSkills = (RangeSkill *)segment.currentSkill;
        }
    }
    if (self.character.characterCondition.currentMeleeSkills.allObjects.count == 0) {
        [self.character.characterCondition addCurrentMeleeSkills:[NSSet setWithObject:[[SkillManager sharedInstance] getOrAddSkillWithTemplate:[[DefaultSkillTemplates sharedInstance] unarmed] withCharacter:self.character]]];
    }
    
    
    int weaponSkill = [[SkillManager sharedInstance] countWSforMeleeSkill:self.character.characterCondition.currentMeleeSkills];
    int ballisticSkill = [[SkillManager sharedInstance] countBSforRangeSkill:self.character.characterCondition.currentRangeSkills];
    int attackMelee = ([[SkillManager sharedInstance] countAttacksForMeleeSkill:self.character.characterCondition.currentMeleeSkills] + self.character.skillSet.modifierAMelee);
    //int attacksRange = ([[SkillManager sharedInstance] countAttacksForRangeSkill:self.character.characterCondition.currentRangeSkills] + self.character.skillSet.modifierARange);
    RangeSkill *skillRange = self.character.characterCondition.currentRangeSkills;
    int damageBonusRange = [[SkillManager sharedInstance] countAttacksForMeleeSkill:skillRange ? [NSSet setWithObject:skillRange] : [NSSet new]];
    
    self.rightSkillTextField.text = [NSString stringWithFormat:@"%d",weaponSkill];
    self.leftSkillTextField.text = [NSString stringWithFormat:@"%d",ballisticSkill];
    
    self.rightActionTextField.text = [NSString stringWithFormat:@"%d",attackMelee];
    self.leftActionTextField.text = [NSString stringWithFormat:@"%d",self.character.skillSet.modifierARange];
    
    self.leftDamageMeleeTextField.text = [NSString stringWithFormat:@"+%d",damageBonusRange];
}

-(void)updateSkillValues {
    [self redrawCurrentDamageStatViews];
}

-(void)defaultTapAction:(DollActiveSegment *)sender
{
    [self.delegateTapSegment didTapActiveSegment:sender];
}

@end
