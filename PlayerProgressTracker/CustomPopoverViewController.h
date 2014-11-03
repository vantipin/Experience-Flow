//
//  CustomPopoverViewController.h
//  BookShelf
//
//  Created by Vlad Antipin on 09.06.14.
//  Copyright (c) 2014 VolcanoSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverDelegate <NSObject>

-(void)didDismissPopover;

@end

@interface CustomPopoverViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic) float customCornerRadius;
@property (nonatomic) CGSize popoverContentSize;
@property (nonatomic,assign) id<PopoverDelegate> delegate;

-(id)initWithContentViewController:(UIViewController *)controller;

-(void)presentPopoverInView:(UIView *)view;

-(void)dismissPopoverAnimated:(BOOL)animated;

@end
