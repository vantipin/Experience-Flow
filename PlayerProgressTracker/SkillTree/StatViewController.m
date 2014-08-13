//
//  StatViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.06.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatViewController.h"
#import "Constants.h"

@interface StatViewController ()

@end

@implementation StatViewController


+(StatViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    NSString *storyboardName = isiPad ? @"StatViewController" : @"StatViewController_iphone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    StatViewController *controller = [storyboard instantiateInitialViewController];
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
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(float)headerHeight
{
    return isiPad ? 90 : 25;
}


-(IBAction)tapHealth:(id)sender
{
    if (self.delegate) {
        [self.delegate didTapHealth];
    }
}

-(IBAction)tapInventory:(id)sender
{
    if (self.delegate) {
        [self.delegate didTapInventory];
    }
}

-(IBAction)tapMovement:(id)sender
{
    if (self.delegate) {
        [self.delegate didTapMovement];
    }
}

-(IBAction)tapInitiative:(id)sender
{
    if (self.delegate) {
        [self.delegate didTapInitiative];
    }
}

@end
