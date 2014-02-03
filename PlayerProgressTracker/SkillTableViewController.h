//
//  SkillTableViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorConstants.h"
#import "ViewControllerWithCoreDataMethods.h"
#import "SkillViewCell.h"
#import "Character.h"
#import "Skill.h"

@protocol SkillTableViewControllerDelegate <NSObject>

-(void)didUpdateCharacterSkills;

@end


@interface SkillTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSString *characterId;

@property (nonatomic) CGFloat tableWith;
@property (nonatomic) CGFloat tableHeight;

@property (nonatomic) UIColor *backgroundColor;

-(id)initWithCharacterName:(NSString *)characterId;


@end
