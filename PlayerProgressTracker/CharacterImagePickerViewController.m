//
//  CharacterImagePickerViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 31/10/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CharacterImagePickerViewController.h"
#import "Constants.h"


@interface CharacterImagePickerViewController ()

@property (nonatomic) IBOutlet iCarousel *iCarouselView;
@property (nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic) NSMutableArray *imageSource;
@property (nonatomic) NSString *startingName;
@end

@implementation CharacterImagePickerViewController

+(CharacterImagePickerViewController *)getInstanceFromStoryboardWithStaringName:(NSString *)startingName;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CharacterImagePicker" bundle:nil];
    CharacterImagePickerViewController *controller = [storyboard instantiateInitialViewController];
    controller.startingName = startingName;
    controller.view.frame =  CGRectMake(0, 0, 600, 200);
    if (!isiPad) {
        controller.leftButton.hidden = true;
        controller.rightButton.hidden = true;
    }
    
    //controller.imageView.frame = controller.view.bounds;
    return controller;
}

+(NSString *)defaultIcon;
{
    return @"noCharacterIcon.png";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *source = @[@"noCharacterIcon.png",
                        @"av_rogue2.png",
                        @"av_barbarian.png",
                        @"av_baron.png",
                        @"av_illthinker.png",
                        @"av_laughingman.png",
                        @"av_pirat.png",
                        @"av_scolar.png",
                        @"av_tragicman.png",
                        @"av_warlock_m.png",
                        @"av_warrior.png",
                        @"av_warrior2.png",
                        @"av_warrior3.png",
                        @"av_whitebearded.png",
                        @"av_warrior6.png",
                        @"av_warrior7.png",
                        @"av_warrior8.png",
                        @"av_wizard.png",
                        
                        @"av_travaler.png",
                        @"av_warrior4.png",
                        @"av_warrior5.png",
                        @"av_firewizard.png",
                        @"av_wizard2.png",
                        @"av_wizard4.png",
                        @"av_wizard5.png",
                        @"av_witch.png",
                        @"av_rogue.png",
                        @"av_aristocracyFem.png",
                        @"av_socrosses.png",
                        @"av_shooter.png",
                        ];
    
    self.imageSource = [NSMutableArray new];
    [self.imageSource addObjectsFromArray:source];
    
    self.iCarouselView.type = iCarouselTypeRotary;
    self.iCarouselView.vertical = false;
    
    [self.iCarouselView reloadData];
    
    NSInteger index = self.startingName ?  [self.imageSource indexOfObject:self.startingName] : 0;
    [self.iCarouselView scrollToItemAtIndex:(index > 0) ? index : 0 animated:false];
    // Do any additional setup after loading the view.
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
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.layer.shadowColor = [[UIColor clearColor] CGColor];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePathWithName(self.imageSource[index])];
    ((UIImageView *)view).image = image;
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
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

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"Tapped view number: %@", self.imageSource[index]);
    if (self.delegate) {
        [self.delegate didPickImageNamed:self.imageSource[index]];
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
