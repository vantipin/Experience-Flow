//
//  CustomPopoverViewController.m
//  BookShelf
//
//  Created by Vlad Antipin on 09.06.14.
//  Copyright (c) 2014 VolcanoSoft. All rights reserved.
//

#import "CustomPopoverViewController.h"
#import "Constants.h"

@interface CustomPopoverViewController ()

@property (nonatomic) UIView *contentView;
@property (nonatomic) UIViewController *contentController;
@property (nonatomic) UIWindow *popupWindow;

@end

@implementation CustomPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContentViewController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.contentController = controller;
        [self.contentView addSubview:controller.view];
        controller.view.center = self.contentView.center;
        [self addChildViewController:controller];
        self.customCornerRadius = 26;
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.contentMode = UIViewContentModeScaleAspectFill;
    self.view.layer.contents = (id)[UIImage imageWithContentsOfFile:filePathWithName(@"cloudBackground.png")].CGImage;
    self.view.layer.masksToBounds = true;
    
    UITapGestureRecognizer *panRecognizer;
    panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopoverAnimated:)];
    [self.view addGestureRecognizer:panRecognizer];
    panRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0 animations:^{
        self.view.layer.opaque = false;
        self.view.layer.opacity = 0.95;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCustomCornerRadius:(float)customCornerRadius
{
    self.contentView.layer.cornerRadius = customCornerRadius;
    _customCornerRadius = customCornerRadius;
}

-(UIWindow *)popupWindow
{
    if (!_popupWindow) {
        _popupWindow = [UIApplication sharedApplication].keyWindow;
        [_popupWindow.rootViewController.view addSubview:self.view];
        [_popupWindow.rootViewController addChildViewController:self];
    }
    
    return _popupWindow;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        CALayer *viewLayer = _contentView.layer;
        viewLayer.cornerRadius = self.customCornerRadius;
        viewLayer.shadowRadius = 0;
        viewLayer.shadowOpacity = 0.0;
        [viewLayer setMasksToBounds:true];
        [self.view addSubview:_contentView];
    }
    
    return _contentView;
}

-(void)setPopoverContentSize:(CGSize)popoverContentSize
{
    _popoverContentSize = popoverContentSize;
    self.contentView.frame = CGRectMake(0, 0, popoverContentSize.width, popoverContentSize.height);
}

-(void)presentPopoverInView:(UIView *)view
{
    if (self.view.window) {
        [self dismissPopoverAnimated:true];
    }
    else {
        self.view.alpha = 0;
        
        [self.popupWindow bringSubviewToFront:self.view];
        
        self.contentView.frame = CGRectMake(0, 0, self.popoverContentSize.width, self.popoverContentSize.height );
        
        CGPoint center = CGPointMake(self.view.center.x, self.view.center.y);
        
        self.contentView.center = center;
        
        self.contentController.view.frame = self.contentView.bounds;

        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 1;
        } completion:^(BOOL success) {
        }];
    }
    


}


-(void)dismissPopoverAnimated:(BOOL)animated;
{
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL success) {
            self.popupWindow = nil;
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }];
    }
    else {
        self.popupWindow = nil;
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
    
    if (self.delegate) {
        [self.delegate didDismissPopover];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.view) { // accept only touchs on superview, not accept touchs on subviews
        return NO;
    }
    
    return YES;
}


@end
