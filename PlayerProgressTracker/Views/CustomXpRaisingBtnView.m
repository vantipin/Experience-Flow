//
//  CustomXpRaisingBtnView.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 15.03.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CustomXpRaisingBtnView.h"

@implementation CustomXpRaisingBtnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)raiseTap:(id)sender
{
    [self.delegate raiseTapped];
}

-(IBAction)lowerTap:(id)sender
{
    [self.delegate lowerTapped];
}

@end
