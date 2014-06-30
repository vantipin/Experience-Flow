//
//  SkillTreeViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 14.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeViewController.h"
#import "Character.h"


@interface SkillTreeViewController : UIViewController <UIScrollViewDelegate, NodeViewControllerProtocol, SkillChangeProtocol>

@property (nonatomic) Character *character;
@property (nonatomic) float customHeaderStatLayoutY;
/*
 *Clear current skill tree and draw a new one. Use this methode AFTER you set the character.
 */
-(void)resetSkillNodes;

/*
 *Refresh node states without redrawing whole structure
 */
-(void)refreshSkillvalues;
-(void)refreshSkillvaluesWithReloadingSkills:(BOOL)needReload;

@end