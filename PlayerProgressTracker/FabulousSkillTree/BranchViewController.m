//
//  BranchViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28/08/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "BranchViewController.h"

@interface BranchViewController ()

@end

@implementation BranchViewController

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



- (CGPoint)pointAroundCircumferenceFromCenter:(CGPoint)center withRadius:(CGFloat)radius andAngle:(CGFloat)theta;
{
    CGPoint point = CGPointZero;
    point.x = center.x + radius * cos(theta);
    point.y = center.y + radius * sin(theta);
    
    return point;
}

@end
