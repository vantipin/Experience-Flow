//
//  SkillTableViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Character;

@protocol SkillTableViewControllerDelegate <NSObject>

-(void)didUpdateCharacterSkills;

@end


@interface SkillTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) CGFloat tableWith;
@property (nonatomic) CGFloat tableHeight;
@property (nonatomic) Character *character;

@property (nonatomic) UIColor *backgroundColor;

-(id)initWithCharacter:(Character *)character;


@end
