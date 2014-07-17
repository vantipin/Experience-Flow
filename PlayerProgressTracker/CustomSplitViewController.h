//
//  CustomSplitViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

/* This is abstract class used to descibe rules for moving table view 
 */

#import <UIKit/UIKit.h>

@interface CustomSplitViewController : UIViewController 

@property (strong, nonatomic) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic) IBOutlet UIView *sideBarContainerView;

- (IBAction)showSideBarAnimated:(id)sender;
- (void)hideSideBarAnimated;
- (void)animateSideBarHidden:(BOOL)hidden;

-(void)hideSideBar:(BOOL)hidden;

@end
