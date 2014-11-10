//
//  NodeLink.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 23.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NodeViewController;

@interface NodeLinkController : UIViewController

@property (nonatomic) NodeViewController *parent;
@property (nonatomic) NodeViewController *child;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

+(NodeLinkController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;

//get instance of animation used by Group animation. Control points calculated with node objects
-(CAKeyframeAnimation *)nodeAnimationInvoke;

@end
