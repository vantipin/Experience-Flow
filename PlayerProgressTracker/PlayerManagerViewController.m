//
//  PlayerManagerViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 16/07/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CustomSplitViewController.h"
#import "PlayerManagerViewController.h"
#import "CharacterViewController.h"
#import "MainContextObject.h"
#import "Constants.h"
#import "PlayerViewCell.h"
#import "CharacterDataArchiver.h"
#import "Character.h"
#import "Pic.h"
#import "SkillSet.h"
#import "UserDefaultsHelper.h"
#import "SkillManager.h"

@interface PlayerManagerViewController ()

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIView *contentContainerView;
@property (nonatomic) IBOutlet UIImageView *iclouavailabilityIcon;

@property (nonatomic) UINavigationController   *contentNavigationController;
@property (nonatomic) CharacterViewController  *contentCharacterController;

@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) NSManagedObjectContext *context;

@property (nonatomic) Character *characterToDelete;
@property (nonatomic) Character *selectedCharacter;

@end

@implementation PlayerManagerViewController

@synthesize dataSource = _dataSource;

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
    
    //iCloud setup
    BOOL isiCloudAvailable = [[iCloud sharedCloud] checkCloudAvailability];
    if (isiCloudAvailable) {
        [self.iclouavailabilityIcon setImage:[UIImage imageWithContentsOfFile:filePathWithName(@"icloudAvailable.png")]];
    }
    else {
        [self.iclouavailabilityIcon setImage:[UIImage imageWithContentsOfFile:filePathWithName(@"icloudIsntAvailible.png")]];
    }
    iCloud *icloudManager = [iCloud sharedCloud];
    icloudManager.delegate = self;
    icloudManager.verboseLogging = true; // We want detailed feedback about what's going on with iCloud, this is OFF by default
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iCloudIsReady) name:@"iCloud Ready" object:nil];
    //
    
    
    [self updateDataSource];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.contentContainerView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentContainerView.layer.contents = (id)[UIImage imageWithContentsOfFile:filePathWithName(@"nightSky.png")].CGImage;
    self.contentContainerView.layer.masksToBounds = true;
    
    //register controllers from storyboard hierarchy
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            self.contentNavigationController = (UINavigationController *)controller;
            self.contentCharacterController  = (CharacterViewController *)self.contentNavigationController.topViewController;
        }
    }
    
    self.panRecognizer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateCharacterList) name:DID_UPDATE_CHARACTER_LIST object:nil];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:true scrollPosition:UITableViewScrollPositionTop];
    if (self.dataSource.count) {
        [self didTabPlayer:self.dataSource[0]];
    }
    else {
        [self didTapNewPlayer];
    }
    
    [[iCloud sharedCloud] updateFiles];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DID_UPDATE_CHARACTER_LIST object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    
    return _dataSource;
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
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateModifed" ascending:false];
    [self.dataSource sortedArrayUsingDescriptors:@[descriptor]];
    
    [self.tableView reloadData];
}

-(void)didUpdateCharacterList
{
    [self updateDataSource];
    [self.tableView reloadData];
    
    Character *character = [self.dataSource lastObject];
    [self didTabPlayer:character];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:([self.dataSource count] - 1) inSection:0];
    [self.tableView selectRowAtIndexPath:newIndexPath animated:true scrollPosition:UITableViewScrollPositionBottom];
    
    [self showSideBarAnimated:nil];
}

-(void)didTabPlayer:(Character *)character
{
    if (self.contentCharacterController) {
        //[self.contentNavigationController popToRootViewControllerAnimated:true];
        [self.contentCharacterController selectCharacter:character];
        self.selectedCharacter = character;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = self.sideBarContainerView.frame;
            newFrame.origin.y = 20;
            newFrame.size.height = 748;
            self.sideBarContainerView.frame = newFrame;
        }];
    }
}


-(void)didTapNewPlayer
{
    if (self.contentNavigationController) {
        [self.contentCharacterController selectNewCharacter];
        self.selectedCharacter = nil;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect newFrame = self.sideBarContainerView.frame;
            newFrame.origin.y = 97;
            newFrame.size.height = 671;
            self.sideBarContainerView.frame = newFrame;
            [self hideSideBar:true];
        }];
    }
}

#pragma mark UITableView delegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellBackground = kRGB(220, 220, 220, 0.65);
    UIColor *cellBackgroundSelected = kRGB(235, 235, 245, 0.9);
    UIView *selectedView = [UIView new];
    selectedView.backgroundColor = cellBackgroundSelected;
    
    if (self.dataSource.count == indexPath.row) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewPlayerViewCell"];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = cellBackground;
        cell.selectedBackgroundView = selectedView;
        
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
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = cellBackground;
        cell.selectedBackgroundView = selectedView;
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count) {
        [self didTapNewPlayer];
    }
    else {
        Character *character = self.dataSource[indexPath.row];
        [self didTabPlayer:character];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count) {
        return false;
    }
    
    return true;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.characterToDelete = self.dataSource[indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Are you sure?"
                                                       message: [NSString stringWithFormat:@"Are you sure you want to delete character named %@",self.characterToDelete.name]
                                                      delegate: self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Delete",@"Cancel",nil];
        
        alert.cancelButtonIndex = 1;
        
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // delete
    {
        [self deleteCharacter:self.characterToDelete];
        [self.context deleteObject:self.characterToDelete];
        
        if (self.dataSource.count < 1) {
            [self didTapNewPlayer];
        }
        else if (self.characterToDelete == self.selectedCharacter) {
            Character *anotherOne = [self.dataSource lastObject];
            [self didTabPlayer:anotherOne];
        }
        
        [self updateDataSource];
        
        if (self.dataSource.count) {
            [self didTabPlayer:[self.dataSource lastObject]];
        }
        else {
            [self didTapNewPlayer];
        }
    }
    
    self.characterToDelete = nil;
}

#pragma mark Gesture recognizer
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint locationInTableView = [touch locationInView:self.tableView];
    if (CGRectContainsPoint(self.tableView.bounds, locationInTableView)) {
        return false;
    }
    return true;
}

#pragma mark icloud protocol and managin methods
-(void)iCloudIsReady
{
    // Reclaim delegate and then update files
    [[iCloud sharedCloud] setDelegate:self];
    [[iCloud sharedCloud] updateFiles];
}

-(void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer
{
    if (cloudIsAvailable) {
        [self.iclouavailabilityIcon setImage:[UIImage imageWithContentsOfFile:filePathWithName(@"icloudAvailable.png")]];
    }
    else {
        [self.iclouavailabilityIcon setImage:[UIImage imageWithContentsOfFile:filePathWithName(@"icloudIsntAvailible.png")]];
    }
}


-(void)iCloudFilesDidChange:(NSMutableArray *)files withNewFileNames:(NSMutableArray *)fileNames
{
    for (NSString *name in fileNames) {
        int index = (int)[fileNames indexOfObject:name];
        NSMetadataItem *document = files[index];
        NSDate *date = [UserDefaultsHelper lastiCloudUpdateForFileName:name];
        NSDate *iCloudDate = [document valueForAttribute:@"kMDItemFSContentChangeDate"];
        
        if (!date || (iCloudDate.timeIntervalSince1970 > date.timeIntervalSince1970)) {
            iCloudDocument *document = [[iCloud sharedCloud] retrieveCloudDocumentObjectWithName:name];
            if (document.contents.length) {
                [UserDefaultsHelper setUpdateDate:iCloudDate forFileName:name];
                [CharacterDataArchiver loadCharacterFromDictionaryData:document.contents withContext:self.context];
                [self didUpdateCharacterList];
            }
        }

    }
}


-(void)deleteCharacter:(Character *)character
{
    //TODO character should be remebered to be deleted if offline
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",character.characterId];
    [[iCloud sharedCloud] deleteDocumentWithName:fileName completion:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *toDelete = [UserDefaultsHelper fileNamesToDelete];
                if (!toDelete) {
                    toDelete = [NSMutableArray new];
                }
                if ([toDelete indexOfObject:fileName] == NSNotFound) {
                    [toDelete addObject:fileName];
                }
                [UserDefaultsHelper setFilenamesToDelete:toDelete];
            });
        }
    }];
}

@end
