//
//  ViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import "PlayerListViewController.h"

@interface PlayerListViewController ()

@property (nonatomic) NSMutableArray *dataSource;

@end

@implementation PlayerListViewController

@synthesize dataSource = _dataSource;

-(NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self printFontNames];
    
    self.characterTableView.dataSource = self;
    [self updateDataSource];
	// Do any additional setup after loading the view, typically from a nib.
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

-(void)updateDataSource
{
    //CoreDataClass *coreData;
    NSArray *characters = [Character fetchFinishedCharacterWithContext:self.managedObjectContext];
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:characters];
    
    [self.characterTableView reloadData];
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

-(PlayerCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifer = @"CharactersListIdentifer";
    PlayerCellView *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifer];
    if (!cell)
    {
        cell = [[PlayerCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifer];
    }
    else //clean up
    {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    cell.backgroundColor = bodyColor;
    
    if ([self.dataSource count] == 0)
    {
        UIButton *addCharacterBtn = [UIButton new];
        [addCharacterBtn setTitle:@"+ Add new character" forState:UIControlStateNormal];
        [addCharacterBtn.titleLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:18]];
        [addCharacterBtn setTitleColor:textEditColor forState:UIControlStateNormal];
        addCharacterBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin
        | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [addCharacterBtn addTarget:self action:@selector(newCharacter:) forControlEvents:UIControlEventTouchUpInside];
        [addCharacterBtn setBackgroundColor:[UIColor clearColor]];
        addCharacterBtn.frame = cell.bounds;
        [cell.contentView addSubview:addCharacterBtn];
    }
    else //init as usual
    {
        Character *character = self.dataSource[indexPath.row];
        
        cell.playerName.text = character.name;
        cell.lastModifed.text = [Character standartDateFormat:character.dateModifed];
        
        if (character.icon)
        {
            UIImage *image = [character.icon imageFromPic];
            [cell.playerIcon setImage: image];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CharacterStatListSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)printFontNames
{
    for (id family in [UIFont familyNames])
    {
        NSLog(@"\nFamily: %@", family);
        
        for (id font in [UIFont fontNamesForFamilyName:family])
            NSLog(@"\tFont: %@\n", font);
    }
}
@end
