//
//  ViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "PlayerListViewController.h"
#import "MainContextObject.h"
#import "Constants.h"
#import "PlayerViewCell.h"

#import "Character.h"
#import "Pic.h"

#import "SkillManager.h"


@interface PlayerListViewController ()

@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSManagedObjectContext *context;

@end

@implementation PlayerListViewController

@synthesize dataSource = _dataSource;


+(PlayerListViewController *)getInstanceFromStoryboard;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PlayerList" bundle:nil];
    PlayerListViewController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame = CGRectMake(0, 0, 350, 1024);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    controller.view.autoresizesSubviews = true;

    return controller;
}


-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateDataSource];
    
    self.view.backgroundColor = bodyColor;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    if (self.dataSource.count) {
        if (self.delegate) {
            [self.delegate didTabPlayer:self.dataSource[0]];
        }
    }
    else {
        if (self.delegate) {
            [self.delegate didTapNewPlayer];
        }
    }
}

-(NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [[MainContextObject sharedInstance] managedObjectContext];
    }
    return _context;
}

-(void)updateDataSource
{
    //CoreDataClass *coreData;
    NSArray *characters = [Character fetchFinishedCharacterWithContext:self.context];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:characters];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlayerViewCell"];
        
        return cell;
    }
    else {
        PlayerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerViewCell"];
        
        Character *character = self.dataSource[indexPath.row];
        
        cell.name.text = character.name;
        cell.dateChanged.text = [Character standartDateFormat:character.dateModifed];
        
        if (character.icon) {
            UIImage *image = [character.icon imageFromPic];
            cell.icon.image = image;
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[UITableViewCell class]]) {
            [self.delegate didTapNewPlayer];
        }
        else {
            Character *character = self.dataSource[indexPath.row];
            [self.delegate didTabPlayer:character];
        }
    }
}
@end
