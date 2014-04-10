//
//  statSetDropDown.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "DropDownViewController.h"

@protocol DeleteStatSetProtocol <NSObject>

-(void)deleteStatSetWithName:(NSString *)name;

@end

@interface StatSetDropDown : DropDownViewController <UIAlertViewDelegate>

@property (nonatomic) NSString *stateNameToDelete;
@property (assign) id<DeleteStatSetProtocol> delegateDeleteStatSet;

@end
