//
//  CharacterDollViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 28.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DollActiveSegment.h"

@class Skill, Character;

@protocol CharacterDollViewControllerProtocol <NSObject>

-(void)didTapActiveSegment:(DollActiveSegment *)segment;

@end


@interface CharacterDollViewController : UIViewController <DollActiveSegmentProtocol>

@property (nonatomic) unsigned numberOfHands;
@property (nonatomic) Character *character;
@property (nonatomic,assign) id<CharacterDollViewControllerProtocol> delegateTapSegment;

+(CharacterDollViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
/*
 *Update values if skills were changed outside the Doll Controller object;
 */
-(void)updateSkillValues;

@end
