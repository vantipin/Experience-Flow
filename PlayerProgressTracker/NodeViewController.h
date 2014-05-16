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

-(void)didTapNode:(NodeViewController *)node;
-(void)didTapNodeLevel:(NodeViewController *)node;
-(void)didSwipNodeUp:(NodeViewController *)node;
-(void)didSwipNodeDown:(NodeViewController *)node;

@end

@interface NodeButton : UIButton
@end


@interface NodeViewController : UIViewController

@property (nonatomic) Skill *skill;
@property (nonatomic,assign) id<NodeViewControllerProtocol> delegate;

+(NodeViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;

-(void)updateInterface;

@end
