//
//  DollActiveSegment.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Skill, DollActiveSegment;

@protocol DollActiveSegmentProtocol <NSObject>

-(void)didChangeActiveSegment:(DollActiveSegment *)segment;

@end

@interface DollActiveSegment : UIButton

@property (nonatomic) Skill *currentSkill;
@property (nonatomic,assign) id<DollActiveSegmentProtocol> delegateSegment;

@end
