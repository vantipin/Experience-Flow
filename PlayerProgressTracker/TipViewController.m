//
//  TipViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 01.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "TipViewController.h"
#import "Constants.h"
#import "Skill.h"
#import "SkillManager.h"
#import "DefaultSkillTemplates.h"
#import "SkillSet.h"
#import "Character.h"

@interface TipViewController ()

@property (nonatomic) UITextView *tipTextView;

@property (nonatomic) UIWindow *popupWindow;


@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSkillTemplate:(Skill *)skill
{
    self = [super init];
    if (self) {
        
        NSDictionary * attributes;
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
        self.tipTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        
        NSString *description = [NSString stringWithFormat:@"%@",skill.skillTemplate.nameForDisplay];
        attributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20]};
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        
        description = [NSString stringWithFormat:@"\nLevel %d (%d/%d)", skill.currentLevel, (int)skill.currentProgress, (int)[[SkillManager sharedInstance] countXpNeededForNextLevel:skill]];
        attributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14]};
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        
        
        BOOL needToAddAdditionalInfo = false;
        //process certain skills info dynamicly start
        NSArray *controlGroup = @[[DefaultSkillTemplates sharedInstance].crashing.name,
                                  [DefaultSkillTemplates sharedInstance].cutting.name,
                                  [DefaultSkillTemplates sharedInstance].piercing.name];
        if ([controlGroup indexOfObject:skill.skillTemplate.name] != NSNotFound) {
            int usableLevels = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            needToAddAdditionalInfo = true;
            int numberOfAttacks = (usableLevels > 4) ? (usableLevels - 4) / 2 + 1 : 1;
            description = [NSString stringWithFormat:@"\n\nYou have %d Action Point(s) during round, using %@ attacks.",numberOfAttacks, skill.skillTemplate.nameForDisplay];
        }
        else if ([skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].toughness.name]) {
            int currentEndurance = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            int currentHitPoints = currentEndurance * 2 + skill.skillSet.character.bulk * 4;
            int percentageToRestore = (currentEndurance * 0.1) < 1 ? 1 : (currentEndurance * 0.1);
            int percentageToRestoreExtra = (currentEndurance * 0.2) < 2 ? 2 : (currentEndurance * 0.2);
            
            needToAddAdditionalInfo = true;
            description = [NSString stringWithFormat:@"\n\nYou have maximum %d Hit Points.\nYou normaly can restore %d hit points per rest.\nYou can restore %d hit points in a good rest.",currentHitPoints, percentageToRestore, percentageToRestoreExtra];
        }
        else if ([skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].strength.name]) {
            int currentEnc = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            
            needToAddAdditionalInfo = true;
            description = [NSString stringWithFormat:@"\n\nYou can hold items with overall cost up to %d Encumbrance Points.\nYou can accumulate up to %d points of adrenalin.\nHolding weapon in both hands give you +%0.0f Strength for normal handle and +%0.0f for long handle.",currentEnc * 2, currentEnc, currentEnc * 0.25, currentEnc * 0.5];
        }
        else if ([skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].physique.name]) {
            int movement = skill.skillSet.character.pace + skill.currentLevel;
            needToAddAdditionalInfo = true;
            description = [NSString stringWithFormat:@"\n\nYou normally move up to %d meters per round.\nYou can sprint up to %d meters per round.",movement, movement*2];
        }
        else if ([skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].perception.name]) {
            int percFloat = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill] / 2;
            needToAddAdditionalInfo = true;
            description = [NSString stringWithFormat:@"\n\nYour initiative during battle is %d.",percFloat];
        }
        else if ([skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].control.name]) {
            int mentalPoints = [[SkillManager sharedInstance] countUsableLevelValueForSkill:skill];
            int percentageToRestore = (mentalPoints * 0.1) < 1 ? 1 : (mentalPoints * 0.1);
            int percentageToRestoreExtra = (mentalPoints * 0.2) < 2 ? 2 : (mentalPoints * 0.2);
            needToAddAdditionalInfo = true;
            description = [NSString stringWithFormat:@"\n\nYou have maximum %d Mental Points.\nYou normaly can restore %d mental points per rest.\nYou can restore %d mental points in a good rest.",mentalPoints * 3, percentageToRestore, percentageToRestoreExtra];
        }
        
        if (needToAddAdditionalInfo) {
            attributes = @{NSForegroundColorAttributeName : kRGB(37, 67, 37, 1),
                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14]};
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        }
        //process certain skills info dynamicly end
        
        
        
        if (skill.skillTemplate.skillDescription) {
            description = [NSString stringWithFormat:@"\n\n%@",skill.skillTemplate.skillDescription];
            attributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14]};
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        }
        if (skill.skillTemplate.skillRules) {
            description = [NSString stringWithFormat:@"\n\n%@",skill.skillTemplate.skillRules];
            attributes = @{NSForegroundColorAttributeName : kRGB(7, 20, 40, 1),
                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:14]};
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        }
        if (skill.skillTemplate.skillRulesExamples) {
            description = [NSString stringWithFormat:@"\n\n%@",skill.skillTemplate.skillRulesExamples];
            attributes = @{NSForegroundColorAttributeName : kRGB(37, 67, 37, 1),
                           NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:14]};
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:description attributes:[attributes copy]]];
        }
            
        
        [self.tipTextView setAttributedText:string];
        //[self.tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:(isiPad ? 16 : 12)]];
        //self.tipTextView.textColor = kRGB(20, 20, 20, 1);

        self.tipTextView.scrollEnabled = true;
        
        self.tipTextView.backgroundColor = [UIColor clearColor];
        self.tipTextView.editable = false;
        self.tipTextView.selectable = true;
        
        [self.view addSubview:self.tipTextView];
        self.tipTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kRGB(250, 250, 250, 1);
//    self.view.contentMode = UIViewContentModeScaleAspectFit;
//    self.view.layer.contents = (id)[UIImage imageWithContentsOfFile:filePathWithName(@"tipBackground.png")].CGImage;
//    self.view.layer.masksToBounds = true;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tipTextView.frame = CGRectMake(self.view.frame.size.width * 0.05, self.view.frame.size.height * 0.05, self.view.frame.size.width * 0.9, self.view.frame.size.height * 0.9);
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tipTextView scrollRectToVisible:CGRectMake(0,0,1,1) animated:false];
    //self.tipTextView.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
