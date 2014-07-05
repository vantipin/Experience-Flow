//
//  CharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 05.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillManager.h"

@interface CharacterViewController : UIViewController <SkillChangeProtocol>

@property (nonatomic,strong) Character *character;

@end
