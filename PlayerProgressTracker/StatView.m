//
//  StatView.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 03.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatView.h"

@implementation StatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initFields
{
    if (!self.settable)
    {
        
        self.m.enabled = false;
        self.ws.enabled = false;
        self.bs.enabled = false;
        self.s.enabled = false;
        self.t.enabled = false;
        self.i.enabled = false;
        self.w.enabled = false;
        self.a.enabled = false;
        self.ld.enabled = false;
        
        self.m.backgroundColor = [UIColor clearColor];
        self.ws.backgroundColor = [UIColor clearColor];
        self.bs.backgroundColor = [UIColor clearColor];
        self.s.backgroundColor = [UIColor clearColor];
        self.t.backgroundColor = [UIColor clearColor];
        self.i.backgroundColor = [UIColor clearColor];
        self.w.backgroundColor = [UIColor clearColor];
        self.a.backgroundColor = [UIColor clearColor];
        self.ld.backgroundColor = [UIColor clearColor];
    }
    else
    {
        self.m.delegate = _executer;
        self.ws.delegate = _executer;
        self.bs.delegate = _executer;
        self.s.delegate = _executer;
        self.t.delegate = _executer;
        self.i.delegate = _executer;
        self.w.delegate = _executer;
        self.a.delegate = _executer;
        self.ld.delegate = _executer;
        
        self.m.enabled = true;
        self.ws.enabled = true;
        self.bs.enabled = true;
        self.s.enabled = true;
        self.t.enabled = true;
        self.i.enabled = true;
        self.w.enabled = true;
        self.a.enabled = true;
        self.ld.enabled = true;
        
        self.m.backgroundColor = [UIColor whiteColor];
        self.ws.backgroundColor = [UIColor whiteColor];
        self.bs.backgroundColor = [UIColor whiteColor];
        self.s.backgroundColor = [UIColor whiteColor];
        self.t.backgroundColor = [UIColor whiteColor];
        self.i.backgroundColor = [UIColor whiteColor];
        self.w.backgroundColor = [UIColor whiteColor];
        self.a.backgroundColor = [UIColor whiteColor];
        self.ld.backgroundColor = [UIColor whiteColor];
    }
}


-(BOOL)nonEmptyStats
{
    if (self.m.text.length == 0 || self.ws.text.length == 0 || self.bs.text.length == 0 || self.s.text.length == 0 || self.t.text.length == 0 || self.i.text.length == 0 || self.w.text.length == 0 || self.a.text.length == 0 || self.ld.text.length == 0)
    {
        return false;
    }
    
    return true;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
