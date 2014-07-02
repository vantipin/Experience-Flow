//
//  TipViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 01.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "TipViewController.h"
#import "Constants.h"

@interface TipViewController ()

@property (nonatomic) UITextView *tipTextView;

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

-(id)initWithSkillTemplate:(SkillTemplate *)skillTemplate
{
    self = [super init];
    if (self) {
        
        self.tipTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        
        NSString *description = [NSString stringWithFormat:@"%@\n\n",skillTemplate.name];
        
        if (skillTemplate.skillDescription) {
            description = [description stringByAppendingString:skillTemplate.skillDescription];
        }
        if (skillTemplate.skillRules) {
            description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRules]];
        }
        if (skillTemplate.skillRulesExamples) {
            description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRulesExamples]];
        }
        
        [self.tipTextView setText:description];
        [self.tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
        self.tipTextView.textColor = kRGB(20, 20, 20, 1);

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
    self.view.backgroundColor = kRGB(240, 240, 240, 0.1);
//    self.view.contentMode = UIViewContentModeScaleAspectFit;
//    self.view.layer.contents = (id)[UIImage imageWithContentsOfFile:filePathWithName(@"tipBackground.png")].CGImage;
//    self.view.layer.masksToBounds = true;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tipTextView.frame = CGRectMake(self.view.frame.size.width * 0.05, self.view.frame.size.height * 0, self.view.frame.size.width * 0.9, self.view.frame.size.height * 1);
}

-(void)viewDidAppear:(BOOL)animated
{

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
