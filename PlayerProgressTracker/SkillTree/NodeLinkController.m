//
//  NodeLink.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "NodeLinkController.h"

@interface NodeLinkController ()

@property (nonatomic) CAKeyframeAnimation *driftAnimation;
@property (nonatomic) CAKeyframeAnimation *stretchAnimation;

@end

@implementation NodeLinkController

+(NodeLinkController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SkillLinkView" bundle:nil];
    NodeLinkController *controller = [storyboard instantiateInitialViewController];
    controller.view.autoresizesSubviews = true;
    controller.view.frame =  frame;
    //controller.imageView.frame = controller.view.bounds;
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
