//
//  TipViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 01.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "TipViewController.h"
#import "ColorConstants.h"

@interface TipViewController ()

@property (nonatomic) UIView *activeTipView;

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
        
        UITextView *tipTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        
        NSString *description = @"";
        
        if (skillTemplate.skillDescription) {
            description = [description stringByAppendingString:skillTemplate.skillDescription];
        }
        if (skillTemplate.skillRules) {
            description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRules]];
        }
        if (skillTemplate.skillRulesExamples) {
            description = [description stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",skillTemplate.skillRulesExamples]];
        }
        
        [tipTextView setText:description];
        [tipTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        [tipTextView sizeToFit];
        tipTextView.scrollEnabled = true;
        
        tipTextView.backgroundColor = [UIColor whiteColor];
        tipTextView.editable = false;
        tipTextView.selectable = true;
        
        
        [self.view addSubview:tipTextView];
        tipTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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
