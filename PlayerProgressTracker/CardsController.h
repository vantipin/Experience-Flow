//
//  CardsController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20/11/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface CardsController : UIViewController <iCarouselDataSource, iCarouselDelegate>

+(CardsController *)getInstanceFromStoryboard;

@end


@interface CardView : UIView

@property (nonatomic) UIView *frontView;
@property (nonatomic) UIView *backView;

-(void)flipCard;
-(void)resetStateAnimated:(BOOL)animated;

@end