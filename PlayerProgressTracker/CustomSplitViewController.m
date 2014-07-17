//
//  CustomSplitViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CustomSplitViewController.h"
#import "Constants.h"

static float SIDEBAR_HIDDEN_ACCESS_LAYOUT = 30;

@interface CustomSplitViewController ()

@property (nonatomic) BOOL sideBarHidden;
@property (nonatomic) CGPoint previousTouchPoint;
@property (nonatomic) BOOL isSidebarDragging;

@end

@implementation CustomSplitViewController

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
    self.sideBarHidden = false;
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.panRecognizer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSideBar) name:SHOULD_HIDE_CUSTOM_SIDEBAR object:nil];
    [self.view bringSubviewToFront:self.sideBarContainerView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SHOULD_HIDE_CUSTOM_SIDEBAR object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSideBarAnimated:(id)sender {
    [self animateSideBarHidden:!self.sideBarHidden];
}

- (void)hideSideBarAnimated {
    [self animateSideBarHidden:YES];
}

-(void)hideSideBar:(BOOL)hidden
{
    __block BOOL sideBarHidden = hidden;
    __block CGRect sideBarFrame = self.sideBarContainerView.frame;
    
    if (sideBarHidden) {
        sideBarFrame.origin.x = self.view.bounds.size.width - SIDEBAR_HIDDEN_ACCESS_LAYOUT;
    } else {
        sideBarFrame.origin.x = self.view.bounds.size.width - sideBarFrame.size.width;
    }
    
    [self.sideBarContainerView setFrame:sideBarFrame];
    
    self.sideBarHidden = sideBarHidden;
}

#pragma mark - Animations

- (void)animateSideBarHidden:(BOOL)hidden {
    __block BOOL sideBarHidden = hidden;
    //__block CGRect bounds = self.view.bounds;
    __block CGRect sideBarFrame = self.sideBarContainerView.frame;
    
    sideBarFrame.size.width += 5.0f;
    sideBarFrame.origin.x = self.view.bounds.size.width - self.sideBarContainerView.bounds.size.width;
    
    [UIView animateWithDuration:0.2 animations:^(void){
        [self.sideBarContainerView setFrame:sideBarFrame];
    } completion:^(BOOL finished) {
        sideBarFrame.size.width -= 5.0f;
        
        if (sideBarHidden) {
            sideBarFrame.origin.x = self.view.bounds.size.width - SIDEBAR_HIDDEN_ACCESS_LAYOUT;
        } else {
            sideBarFrame.origin.x = self.view.bounds.size.width - sideBarFrame.size.width;
        }
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            [self.sideBarContainerView setFrame:sideBarFrame];
        }];
        
        self.sideBarHidden = sideBarHidden;
    }];
}

- (void)finishAnimateSidebar:(BOOL)hidden {
    __block BOOL sideBarHidden = hidden;
    __block CGRect sideBarFrame = self.sideBarContainerView.frame;
    
    if (hidden) {
        sideBarFrame.origin.x = self.view.bounds.size.width - SIDEBAR_HIDDEN_ACCESS_LAYOUT;
    } else {
        sideBarFrame.origin.x = self.view.bounds.size.width - sideBarFrame.size.width;
    }
    
    [UIView animateWithDuration:0.2 animations:^(void){
        [self.sideBarContainerView setFrame:sideBarFrame];
    } completion:^(BOOL finished) {
        self.sideBarHidden = sideBarHidden;
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    CGPoint velocityPoint = [gestureRecognizer velocityInView:self.view];
    UIView *draggedView = self.sideBarContainerView;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _isSidebarDragging = YES;
        _previousTouchPoint = touchPoint;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat xOffset = _previousTouchPoint.x - touchPoint.x;
        if (draggedView.center.x - xOffset >= self.view.bounds.size.width - self.sideBarContainerView.frame.size.width / 2 &&
            draggedView.center.x - xOffset <= self.view.bounds.size.width + self.sideBarContainerView.frame.size.width / 2) {
            draggedView.center = CGPointMake(draggedView.center.x - xOffset, draggedView.center.y);
        }
        _previousTouchPoint = touchPoint;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocityPoint.x > 0) {
            [self finishAnimateSidebar:YES];
        } else {
            [self finishAnimateSidebar:NO];
        }
        _isSidebarDragging = NO;
    }
}

@end
