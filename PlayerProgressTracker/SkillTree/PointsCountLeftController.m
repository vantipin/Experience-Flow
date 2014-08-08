//
//  PointsCountLeftController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 07/08/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "PointsCountLeftController.h"
#import "Constants.h"

@interface PointsCountLeftController ()

@end

@implementation PointsCountLeftController

+(PointsCountLeftController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PointCountLeft" bundle:nil];
    PointsCountLeftController *controller = [storyboard instantiateInitialViewController];
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
    self.view.backgroundColor = kRGB(240, 240, 240, 0.1);
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
