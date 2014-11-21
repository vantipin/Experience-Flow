//
//  CardsController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 20/11/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CardsController.h"
#import "Constants.h"

//perspective
#define TransformT34 -11.0f

@interface CardsController ()

@property (nonatomic) IBOutlet iCarousel *iCarouselView;
@property (nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic) NSArray *imageSource;
@property (nonatomic) NSArray *backImageSource;

@end

@implementation CardsController

+(CardsController *)getInstanceFromStoryboard;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Cards" bundle:nil];
    CardsController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame =  CGRectMake(0, 0, 800, 650);
//    if (!isiPad) {
//        controller.leftButton.hidden = true;
//        controller.rightButton.hidden = true;
//    }
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageSource = @[@"card_block",
                         @"card_dodge",
                         @"card_evaluate",
                         @"card_shot",
                         @"card_grab",
                         @"card_push",
                         @"card_crush",
                         @"card_blow",
                         @"card_stunt",
                         @"card_magic"];
    
    self.backImageSource = @[@"card_block_back",
                             @"card_dodge_back",
                             @"card_evaluate_back",
                             @"card_shot_back",
                             @"card_grab_back",
                             @"card_push_back",
                             @"card_crush_back",
                             @"card_blow_back",
                             @"card_stunt_back",
                             @"card_magic_back"];
    
    self.iCarouselView.type = iCarouselTypeCylinder;
    self.iCarouselView.vertical = false;
    
    [self.iCarouselView reloadData];
    
    [self.iCarouselView scrollToItemAtIndex:0 animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.imageSource count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    CardView *card;
    if (!view) {
        view = [[CardView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
        //view.layer.shadowColor = [[UIColor clearColor] CGColor];
        card = (CardView *)view;
        
        card.frontView = [[UIImageView alloc] initWithFrame:card.bounds];
        [card addSubview:card.frontView];
        card.frontView.contentMode = UIViewContentModeScaleAspectFit;
        card.backView = [[UIImageView alloc] initWithFrame:card.bounds];
        [card addSubview:card.backView];
        card.backView.hidden = true;
        card.backView.contentMode = UIViewContentModeScaleAspectFit;
        //card.backgroundColor = [UIColor redColor];
    }
    else {
        card = (CardView *)view;
    }
    
    UIImage *frontImage = [UIImage imageWithContentsOfFile:filePathWithName(self.imageSource[index])];
    card.frontView.layer.contents = (id)frontImage.CGImage;
    card.frontView.layer.masksToBounds = true;
    UIImage *backImage = [UIImage imageWithContentsOfFile:filePathWithName(self.backImageSource[index])];
    card.backView.layer.contents = (id)backImage.CGImage;
    card.backView.layer.masksToBounds = true;
    
    return card;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    }
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.iCarouselView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return true;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.15f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.iCarouselView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

-(void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel
{
//    if ([carousel.currentItemView isKindOfClass:[CardView class]]) {
//        CardView * card = (CardView *)carousel.currentItemView;
//        [card resetStateAnimated:false];
//    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"Tapped view number: %@", self.imageSource[index]);
    if (index == carousel.currentItemIndex) {
        CardView * card = (CardView *)[carousel itemViewAtIndex:index];
        [card flipCard];
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    //NSLog(@"Index: %@", @(self.iCarouselView.currentItemIndex));
}


-(IBAction)leftTap:(id)sender
{
    if (self.iCarouselView.currentItemIndex || self.iCarouselView.wrapEnabled) {
        [self.iCarouselView scrollToItemAtIndex:self.iCarouselView.currentItemIndex - 1 animated:true];
    }
    
}

-(IBAction)rightTap:(id)sender
{
    if (self.iCarouselView.currentItemIndex < self.imageSource.count || self.iCarouselView.wrapEnabled) {
        [self.iCarouselView scrollToItemAtIndex:self.iCarouselView.currentItemIndex + 1 animated:true];
    }
}


@end


@implementation CardView

-(void)flipCard
{
    [self startAnimationForView1:self.backView.hidden ? self.frontView : self.backView andView2:self.frontView.hidden ? self.frontView : self.backView];
}

- (void)startAnimationForView1:(UIView *)view1 andView2:(UIView *)view2
{
    CGFloat animationDuration = .5;
    
    CATransform3D fromTransform = CATransform3DIdentity;
    CGFloat diameter = self.frontView.layer.bounds.size.width;
    fromTransform.m34 = 0.5f / (TransformT34 * diameter / 5.f);
    
    CATransform3D toTransform = CATransform3DRotate(fromTransform, M_PI_2, 0., 1., 0.);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setValue:@"front" forKey:@"flipping"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:fromTransform];
    animation.toValue = [NSValue valueWithCATransform3D:toTransform];
    
    [animation setAutoreverses:NO];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDuration:animationDuration / 2.];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDelegate:self];
    
    CABasicAnimation *animationFor2 = [animation copy];
    animationFor2.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(fromTransform, M_PI, 0., 1., 0.)];
    animationFor2.toValue = [NSValue valueWithCATransform3D:fromTransform];
    animationFor2.duration = animationDuration;
    [animationFor2 setValue:@"back" forKey:@"flipping"];
    
    [view1.layer addAnimation:animation forKey:nil];
    [view2.layer addAnimation:animationFor2 forKey:nil];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    //NSLog(@"start");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *key = [anim valueForKey:@"flipping"];
    
    if ([key isEqualToString:@"front"]) {
        [self.frontView setHidden:!self.frontView.hidden];
        [self.backView setHidden:!self.backView.hidden];
    } else {
        
    }
    
    //NSLog(@"stop");
}

-(void)resetStateAnimated:(BOOL)animated
{
    [self.frontView.layer removeAllAnimations];
    [self.backView.layer removeAllAnimations];
    
    [self.frontView.layer setTransform:CATransform3DIdentity];
    [self.backView.layer setTransform:CATransform3DIdentity];
    [self.backView setHidden:YES];
    [self.frontView setHidden:NO];
}

@end
