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


#pragma mark IBActions and segues
-(IBAction)newCharacter:(id)sender
{
    [self performSegueWithIdentifier:@"NewCharacterSegue" sender:self];
}

#pragma mark UITableView delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.dataSource count]==0)?1:[self.dataSource count];
}

-(PlayerViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerViewCell"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    if ([self.dataSource count] == 0) {
        UIButton *addCharacterBtn = [UIButton new];
        [addCharacterBtn setTitle:@"+ Add new character" forState:UIControlStateNormal];
        [addCharacterBtn.titleLabel setFont:defaultFont];
        [addCharacterBtn setTitleColor:textEditColor forState:UIControlStateNormal];
        addCharacterBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [addCharacterBtn addTarget:self action:@selector(newCharacter:) forControlEvents:UIControlEventTouchUpInside];
        [addCharacterBtn setBackgroundColor:[UIColor clearColor]];
        addCharacterBtn.frame = cell.bounds;
        [cell.contentView addSubview:addCharacterBtn];
    }
    else {//init as usual
        Character *character = self.dataSource[indexPath.row];
        
        cell.name.text = character.name;
        cell.dateChanged.text = [Character standartDateFormat:character.dateModifed];
        
        if (character.icon) {
            UIImage *image = [character.icon imageFromPic];
            cell.icon.image = image;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CharacterStatListSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
