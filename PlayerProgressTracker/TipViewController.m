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
