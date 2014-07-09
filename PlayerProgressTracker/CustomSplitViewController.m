//
//  CustomSplitViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CustomSplitViewController.h"
#import "NewCharacterViewController.h"
#import "CharacterViewController.h"

@interface CustomSplitViewController ()

@property (nonatomic) IBOutlet UIView *playerListContainerView;
@property (nonatomic) IBOutlet UIView *contentContainerView;

@property (nonatomic) PlayerListViewController *playerListController;
@property (nonatomic) UINavigationController   *contentNavigationController;
@property (nonatomic) CharacterViewController  *contentCharacterController;

@end

@implementation CustomSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //register controllers from storyboard hierarchy
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[PlayerListViewController class]]) {
            self.playerListController = (PlayerListViewController *)controller;
            self.playerListController.delegate = self;
            
            //TODO
            //bind gestures to playerListController.view
            //to hide or show tableView
        }
        if ([controller isKindOfClass:[UINavigationController class]]) {
            self.contentNavigationController = (UINavigationController *)controller;
            self.contentCharacterController  = (CharacterViewController *)self.contentNavigationController.topViewController;
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark PlayerListProtocol

-(void)didTabPlayer:(Character *)character
{
    if (self.contentCharacterController) {
        [self.contentNavigationController popToRootViewControllerAnimated:true];
        self.contentCharacterController.character = character;
    }
}


-(void)didTapNewPlayer
{
    if (self.contentNavigationController) {
        
        //TODO
        //if not pushed -> push new character controller;
    }
}


@end
