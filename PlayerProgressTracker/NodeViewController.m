//
//  NodeViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 14.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "NodeViewController.h"
#import "SkillTemplate.h"

@interface NodeViewController ()

@property (nonatomic) IBOutlet NodeButton *skillButton;
@property (nonatomic) IBOutlet NodeButton *skillLevelButton;

@end

@implementation NodeViewController

+(NodeViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NodeView" bundle:nil];
    NodeViewController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame =  frame;
    return controller;
}

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSkill:(Skill *)skill
{
    _skill = skill;
    if (_skill) {
        [self updateInterface];
    }
}

-(void)updateInterface
{
    [self.skillButton setTitle:_skill.skillTemplate.name forState:UIControlStateNormal];
    [self.skillLevelButton setTitle:[NSString stringWithFormat:@"%d",_skill.currentLevel] forState:UIControlStateNormal];
}



-(IBAction)didTabSkillButton:(id)sender
{
    [self.delegate didTapNode:self];
}


-(IBAction)didTabSkillLevelButton:(id)sender
{
    [self.delegate didTapNodeLevel:self];
}


- (IBAction)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        CGPoint velocity = [gestureRecognizer velocityInView:self.view];
        
        if (velocity.y > 0) {
            [self.delegate didSwipNodeDown:self];
        }
        else {
            [self.delegate didSwipNodeUp:self];
        }
    }
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


@implementation NodeButton

@end
