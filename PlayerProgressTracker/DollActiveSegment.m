//
//  DollActiveSegment.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.04.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "DollActiveSegment.h"

@implementation DollActiveSegment

-(void)setCurrentSkill:(Skill *)currentSkill
{
    _currentSkill = currentSkill;
    [self.delegateSegment didChangeActiveSegment:self];
}

@end
