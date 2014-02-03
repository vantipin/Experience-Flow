//
//  statSetDropDown.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 09.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "StatSetDropDown.h"

@interface StatSetDropDown ()

@end

@implementation StatSetDropDown

@synthesize stateNameToDelete = _stateNameToDelete;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.stateNameToDelete = self.dropDownDataSource[indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Are you sure?"
                                                       message: [NSString stringWithFormat:@"Are you sure you want to delete stat set named %@",self.stateNameToDelete]
                                                      delegate: self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Delete",@"Cancel",nil];
        //alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //[[alert textFieldAtIndex:0] setText:@"New race"];
        
        alert.cancelButtonIndex = 1;
        
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // delete
    {
        [self.delegateDeleteStatSet deleteStatSetWithName:self.stateNameToDelete];
        [self.dropDownTableView reloadData];
    }
    
    self.stateNameToDelete = nil;
    
    if (self.dropDownDataSource.count == 0)
    {
        [self closeAnimation];
    }
}

@end
