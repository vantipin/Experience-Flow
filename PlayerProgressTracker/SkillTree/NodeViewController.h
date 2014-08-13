//
//  NodeViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 14.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Skill.h"

@class NodeViewController;

@protocol NodeViewControllerProtocol <NSObject>

-(Skill *)needNewSkillObjectWithTemplate:(SkillTemplate *)skillTemplate;

-(void)didTapNode:(NodeViewController *)node;
-(void)didTapNodeLevel:(NodeViewController *)node;
-(void)didSwipNodeUp:(NodeViewController *)node;
-(void)didSwipNodeDown:(NodeViewController *)node;

@end


@class NodeLinkController;


@interface NodeViewController : UIViewController

@property (nonatomic) NodeLinkController *nodeLinkParent;
@property (nonatomic) NSMutableArray *nodeLinksChild;

@property (nonatomic) Skill *skill;
@property (nonatomic,assign) id<NodeViewControllerProtocol> delegate;

@property (nonatomic) IBOutlet UIButton *skillButton;

//current animation points used by related Links objects
@property (nonatomic) CGPoint point1;
@property (nonatomic) CGPoint point2;

+(NodeViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;

-(void)updateInterface;

-(void)setParentNodeLink:(NodeViewController *)parentNodeLink placeInView:(UIView *)containerView addToController:(UIViewController *)controller;

//get instance of animation used by Group animation
-(CAKeyframeAnimation *)nodeAnimationInvokeWithPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2;


-(void)lightUp;

@end