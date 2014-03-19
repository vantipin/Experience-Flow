//
//  CustomXpRaisingBtnView.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 15.03.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol raisingButtonProtocol <NSObject>

-(void)raiseTapped;
-(void)lowerTapped;

@end

@interface CustomXpRaisingBtnView : UIView

@property (nonatomic) IBOutlet UIButton *raiseButton;
@property (nonatomic) IBOutlet UIButton *lowerButton;
@property (nonatomic, assign) id<raisingButtonProtocol> delegate;

-(IBAction)raiseTap:(id)sender;
-(IBAction)lowerTap:(id)sender;

@end
