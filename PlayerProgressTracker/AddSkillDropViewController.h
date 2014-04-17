//
//  AddSkillDropViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 17.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "DropDownViewController.h"
#import "AddSkillViewCellTableViewCell.h"
#import "SkillManager.h"

@protocol AddNewSkillControllerProtocol <NSObject>

-(BOOL)addNewSkillWithTemplate:(SkillTemplate *)skillTemplate;
-(BOOL)deleteNewSkillWithTemplate:(SkillTemplate *)skillTemplate;

@end

@interface AddSkillDropViewController : DropDownViewController <AddNewSkillProtocol, UIAlertViewDelegate>

@property (nonatomic) SkillSet *skillSet;

-(AddSkillDropViewController *)initWithArrayData:(NSArray *)templateArray
                                    withSkillSet:(SkillSet *)skillSet
                              withWidthTableView:(float)tableWidth
                                      cellHeight:(CGFloat)cHeight
                                     withRedView:(UIView *)refView
                                   withAnimation:(AnimationType)tAnimation;

@property (nonatomic,assign) id<AddNewSkillControllerProtocol>delegateAddNewSkill;

@end
