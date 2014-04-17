//
//  AddSkillViewCellTableViewCell.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 17.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillTemplate.h"

@class AddSkillViewCellTableViewCell;

@protocol AddNewSkillProtocol <NSObject>

-(BOOL)addThisSkill:(SkillTemplate *)skillTemplate sender:(AddSkillViewCellTableViewCell *)cell;
-(BOOL)deleteThisSkill:(SkillTemplate *)skillTemplate sender:(AddSkillViewCellTableViewCell *)cell;
-(void)showDescriptionForSkill:(SkillTemplate *)skillTemplate;

@end

@interface AddSkillViewCellTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIButton *addSkillButton;
@property (nonatomic) IBOutlet UIButton *showDescriptionButton;

@property (nonatomic) SkillTemplate *skillTemplate;
@property (nonatomic) BOOL shouldDeleteSkill;

@property (nonatomic,assign) id<AddNewSkillProtocol> delegate;

-(void)setAddSkillButtonToDeleteWithAnimationCompletion:(void (^)())completionBlock;
-(void)setAddSkillButtonToAddWithAnimationCompletion:(void (^)())completionBlock;

@end
