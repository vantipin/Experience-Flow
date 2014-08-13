//
//  SkillTreeViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 14.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "SkillTreeViewController.h"
#import "SkillTemplate.h"
#import "SkillManager.h"
#import "DefaultSkillTemplates.h"
#import "StatViewController.h"
#import "TipViewController.h"
#import "CustomPopoverViewController.h"
#import "PointsCountLeftController.h"
#import "UserDefaultsHelper.h"

static float minimalMarginBetweenTrees = 100;
static float minimalMarginBetweenNodesX = 50;
static float minimalMarginBetweenNodesY = 110;
static float borderSize = 100;
static float nodeDiameter = 200;

static int xpPointsToCreateCharacter = 100;

static NSString *emptyParentKey = @"emptyParent";

@interface SkillTreeViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIView *containerForContainerView; //Why? bug with centering zooming

@property (nonatomic) NSMutableArray *trees;
@property (nonatomic) NSMutableDictionary *treeNodeWidthForTreeArrayObject;
@property (nonatomic) NSMutableDictionary *treeSpacesWidthForTreeArrayObject;
@property (nonatomic) NSMutableDictionary *nodesOnSingleLevelForLevelArrayObject;
@property (nonatomic) NSMutableDictionary *sectionIndexesForSkillParentName;
@property (nonatomic) NSMutableDictionary *nodeIndexesForSkillNames;
@property (nonatomic) long treeHeight;
@property (nonatomic) NSMutableArray *allExistingNodes;
@property (nonatomic) NSMutableDictionary *operationStack;
@property (nonatomic) StatViewController *statHeaderController;
@property (nonatomic) PointsCountLeftController *pointsLeftController;
@property (nonatomic) float xpPointsLeft;

@end

@implementation SkillTreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCharacter:(Character *)character;
{
    self = [super init];
    if (self) {
        self.character = character;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTree];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.scrollView.autoresizesSubviews = true;
    
    
    float width = 0 + borderSize * 2;
    for (NSMutableArray *tree in self.trees) {
        NSInteger currentTreeWidth = [[self.treeNodeWidthForTreeArrayObject objectForKey:tree] integerValue];
        
        NSInteger currentTreeMaxWidthSpacing = [[self.treeSpacesWidthForTreeArrayObject objectForKey:tree] integerValue];
        width += (currentTreeWidth * nodeDiameter) + (currentTreeMaxWidthSpacing * minimalMarginBetweenNodesX);
    }
    width += (self.trees.count - 1) * minimalMarginBetweenTrees;
    
    float height = (self.treeHeight * (nodeDiameter + minimalMarginBetweenNodesY)) + minimalMarginBetweenNodesY;
    self.scrollView.contentSize = CGSizeMake(width, height);
    
    self.containerView.frame = CGRectMake(0, 0, width, height);
    self.containerForContainerView.frame = self.containerView.frame;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resetSkillNodes];
    [[SkillManager sharedInstance] subscribeForSkillsChangeNotifications:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self updateScrollViewZoomAnimated:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[SkillManager sharedInstance] unsubscribeForSkillChangeNotifications:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //NSLog(@"%d",toInterfaceOrientation);
    [self updateScrollViewZoomAnimated:true];
}

#pragma mark custom setters/getters

-(void)setIsInCreatingNewCharacterMod:(BOOL)isInCreatingNewCharacterMod
{
    _isInCreatingNewCharacterMod = isInCreatingNewCharacterMod;
    
    if (isInCreatingNewCharacterMod) {
        self.pointsLeftController.view.alpha = 1;
        NSDictionary *temporaryData = [UserDefaultsHelper infoForUnfinishedCharacterWithId:self.character.characterId];
        if (temporaryData) {
            NSNumber *numberVal = [temporaryData objectForKey:keyForPointsLeft];
            NSMutableDictionary *dict = [temporaryData objectForKey:keyForOperationStack];
            if (numberVal && dict) {
                self.xpPointsLeft = numberVal.floatValue;
                self.operationStack = dict;
            }
            else {
                self.xpPointsLeft = xpPointsToCreateCharacter;
                self.operationStack = nil;
            }
        }
        else {
            self.xpPointsLeft = xpPointsToCreateCharacter;
            self.operationStack = nil;
        }
    }
    else {
        self.pointsLeftController.view.alpha = 0;
    }
}

-(void)setXpPointsLeft:(float)xpPointsLeft
{
    _xpPointsLeft = xpPointsLeft;
    
    self.pointsLeftController.pointsLeft.text = (fmod(xpPointsLeft, 1.0) > 0) ? [NSString stringWithFormat:@"%.1f",_xpPointsLeft] : [NSString stringWithFormat:@"%.0f",_xpPointsLeft];
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.showsVerticalScrollIndicator = false;
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        [self.containerForContainerView addSubview:self.containerView];
    }
    return _containerView;
}

-(UIView *)containerForContainerView
{
    if (!_containerForContainerView) {
        _containerForContainerView = [UIView new];
        [self.scrollView addSubview:self.containerForContainerView];
    }
    return _containerForContainerView;
}

-(void)setCharacter:(Character *)character
{
    if (character) {
        self.isInCreatingNewCharacterMod = false; //by default;
        _character = character;
    }
}

-(NSMutableArray *)trees
{
    if (!_trees) {
        _trees = [NSMutableArray new];
    }
    
    return _trees;
}

-(NSMutableDictionary *)nodesOnSingleLevelForLevelArrayObject
{
    if (!_nodesOnSingleLevelForLevelArrayObject) {
        _nodesOnSingleLevelForLevelArrayObject = [NSMutableDictionary new];
    }
    
    return _nodesOnSingleLevelForLevelArrayObject;
}

-(NSMutableDictionary *)sectionIndexesForSkillParentName
{
    if (!_sectionIndexesForSkillParentName) {
        _sectionIndexesForSkillParentName = [NSMutableDictionary new];
    }
    
    return _sectionIndexesForSkillParentName;
}

-(NSMutableDictionary *)treeNodeWidthForTreeArrayObject
{
    if (!_treeNodeWidthForTreeArrayObject) {
        _treeNodeWidthForTreeArrayObject = [NSMutableDictionary new];
    }
    
    return _treeNodeWidthForTreeArrayObject;
}


-(NSMutableDictionary *)treeSpacesWidthForTreeArrayObject
{
    if (!_treeSpacesWidthForTreeArrayObject) {
        _treeSpacesWidthForTreeArrayObject = [NSMutableDictionary new];
    }
    
    return _treeSpacesWidthForTreeArrayObject;
}

-(NSMutableDictionary *)nodeIndexesForSkillNames
{
    if (!_nodeIndexesForSkillNames) {
        _nodeIndexesForSkillNames = [NSMutableDictionary new];
    }
    return _nodeIndexesForSkillNames;
}

-(StatViewController *)statHeaderController
{
    if (!_statHeaderController) {
        
        _statHeaderController = [StatViewController getInstanceFromStoryboardWithFrame:CGRectMake(
                                                                                                  0,
                                                                                                  0 + self.customHeaderStatLayoutY,
                                                                                                  self.scrollView.frame.size.width,
                                                                                                  [StatViewController headerHeight])];
        _statHeaderController.delegate = self;
        [self.view addSubview:_statHeaderController.view];
    }
    
    return _statHeaderController;
}

-(PointsCountLeftController *)pointsLeftController
{
    if (!_pointsLeftController) {
        
        _pointsLeftController = [PointsCountLeftController getInstanceFromStoryboardWithFrame:CGRectMake(0,
                                                                                                         self.view.bounds.size.width - [PointsCountLeftController sizeHeightPointsLeft],
                                                                                                         [PointsCountLeftController sizeWidthPointsLeft],
                                                                                                         [PointsCountLeftController sizeHeightPointsLeft])];
        [self.view addSubview:_pointsLeftController.view];
    }
    
    return _pointsLeftController;
}

-(NSMutableDictionary *)operationStack
{
    if (!_operationStack) {
        _operationStack = [NSMutableDictionary new];
    }
    
    return _operationStack;
}

#pragma mark -

-(void)updateStatHeader
{
    Skill *toughnessSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].toughness withCharacter:self.character];
    Skill *strenghtSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].strength withCharacter:self.character];
    Skill *physiqueSkill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].physique withCharacter:self.character];
    Skill *perception = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:[DefaultSkillTemplates sharedInstance].perception withCharacter:self.character];

    int percFloat = [[SkillManager sharedInstance] countUsableLevelValueForSkill:perception] / 2;
    self.statHeaderController.initiativeLabel.text = [NSString stringWithFormat:@"%d",percFloat ? percFloat : 1];
    self.statHeaderController.movementLabel.text = [NSString stringWithFormat:@"%d",self.character.pace + physiqueSkill.currentLevel];
    self.statHeaderController.healthCurrentLabel.text = [NSString stringWithFormat:@"%d",[[SkillManager sharedInstance] countUsableLevelValueForSkill:toughnessSkill] * 2];
    self.statHeaderController.healthMaxLabel.text = [NSString stringWithFormat:@"%d",[[SkillManager sharedInstance] countUsableLevelValueForSkill:toughnessSkill] * 2];
    self.statHeaderController.inventoryCurrentLabel.text = [NSString stringWithFormat:@"%d",0];
    self.statHeaderController.inventoryMaxLabel.text = [NSString stringWithFormat:@"%d",[[SkillManager sharedInstance] countUsableLevelValueForSkill:strenghtSkill] * 3];
}

-(void)updateScrollViewZoomAnimated:(BOOL)animated
{
//    BOOL isLandscape = false;
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
//        isLandscape = false;
//    }
//    else {
//        isLandscape = true;
//    }
    

    //since orientation change allowed zoom scale should be reset in order to calculate following scales correctly
    [self.scrollView setZoomScale:1.0f];
    
    
    float scrollViewRealWidth = self.scrollView.frame.size.width;
    float scrollViewRealHeight = self.scrollView.frame.size.height;
    
//    NSLog(@"width  %f",scrollViewRealWidth);
//    NSLog(@"height %f",scrollViewRealHeight);
    
    float scaleWidth = scrollViewRealWidth / self.scrollView.contentSize.width;
    float scaleHeight = scrollViewRealHeight / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    CGFloat currentScale = MIN(scrollViewRealHeight, scrollViewRealWidth) / self.scrollView.contentSize.height;//MAX(scaleWidth, scaleHeight)
    
    self.scrollView.scrollEnabled = true;
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    [self.scrollView setZoomScale:currentScale  animated:animated];
    
    //NSLog(@"\nmin %f \nmax %f",self.scrollView.minimumZoomScale,self.scrollView.maximumZoomScale);
}

#pragma mark -
#pragma build tree methods
-(void)initTree
{
    self.trees = [NSMutableArray new];
    self.allExistingNodes = [NSMutableArray new];
    self.treeHeight = 0;
    self.treeNodeWidthForTreeArrayObject = nil;
    self.treeSpacesWidthForTreeArrayObject = nil;
    self.sectionIndexesForSkillParentName = nil;
    self.nodesOnSingleLevelForLevelArrayObject = nil;
    
    NSArray *rootSkills = [[DefaultSkillTemplates sharedInstance] allBasicSkillTemplates];
    
    for (SkillTemplate *rootSkill in rootSkills) {
        NSMutableArray *tree = [NSMutableArray new];
        NSInteger indexOfTree = self.trees.count;
        [self.trees addObject:tree];
        
        NSMutableArray *rootLevel = [NSMutableArray new];
        NSMutableArray *rootSection = [NSMutableArray new];
        [tree addObject:rootLevel];
        [rootLevel addObject:rootSection];
        [rootSection addObject:rootSkill];
        
        
        [self addSubSkillsFrom:rootSkill withTreeIndex:indexOfTree];
        
        NSInteger treeWidth = 0;
        NSInteger treeCurrentSpaces = 0;
        for (NSMutableArray *level in tree) {
            NSInteger levelWidth = 0;
            NSInteger levelSpaces = 0;
            for (NSMutableArray *section in level) {
                levelWidth += section.count;
                levelSpaces += section.count;
            }
            levelSpaces --;
            levelSpaces += level.count;
            
            //levelWidth += level.count - 1 ? : 0;
            [self.nodesOnSingleLevelForLevelArrayObject setObject:[NSNumber numberWithInteger:levelSpaces] forKey:level];
            if (levelWidth > treeWidth) {
                treeWidth = levelWidth;
            }
            if (levelSpaces > treeCurrentSpaces) {
                treeCurrentSpaces = levelSpaces;
            }
        }
        [self.treeNodeWidthForTreeArrayObject setObject:[NSNumber numberWithInteger:treeWidth] forKey:tree];
        [self.treeSpacesWidthForTreeArrayObject setObject:[NSNumber numberWithInteger:treeCurrentSpaces] forKey:tree];
    }
}


-(void)addSubSkillsFrom:(SkillTemplate *)parentSkill withTreeIndex:(NSInteger)index
{
    for (SkillTemplate *skill in parentSkill.subSkillsTemplate) {
        [self addSkillInTreeHierachy:skill withTreeIndex:index];
        [self addSubSkillsFrom:skill withTreeIndex:index];
    }
}

-(void)addSkillInTreeHierachy:(SkillTemplate *)skill withTreeIndex:(NSInteger)index
{
    NSInteger positionYInTree = [[SkillManager sharedInstance] countPositionYInATreeForSkill:skill];
    if (positionYInTree > self.treeHeight) {
        self.treeHeight = positionYInTree;
    }
    
    NSMutableArray *tree = [self.trees objectAtIndex:(NSUInteger)index];
    if (positionYInTree == tree.count) {
        NSMutableArray *missingNextLevel = [NSMutableArray new];
        [tree addObject:missingNextLevel];
    }
    else if (positionYInTree > tree.count) {
        NSInteger notYetInitedLevelsOfTree = positionYInTree - tree.count;
        for (int i = 0; i < notYetInitedLevelsOfTree; i++) {
            [tree addObject:[NSMutableArray new]]; //add level to store tree nodes
        }
    }
    
    //current level
    NSMutableArray *currentLevel = [tree objectAtIndex:(positionYInTree - 1)];
    
    //current section
    NSString *parentName = skill.basicSkillTemplate ? skill.basicSkillTemplate.name : emptyParentKey;
    if (![self.sectionIndexesForSkillParentName objectForKey:parentName]) {
        
        NSMutableArray *newSection = [NSMutableArray new];
        [self.sectionIndexesForSkillParentName setObject:[NSNumber numberWithUnsignedLong:currentLevel.count] forKey:parentName];
        [currentLevel addObject:newSection];
    }
    NSUInteger sectionIndex = [[self.sectionIndexesForSkillParentName objectForKey:parentName] unsignedIntegerValue];
    
    NSMutableArray *section = [currentLevel objectAtIndex:sectionIndex];
    [section addObject:skill];
}

-(void)resetSkillNodes
{
    if (self.character) {
        for (NodeViewController *subController in self.childViewControllers) {
            [subController removeFromParentViewController];
        }
        for (UIView *node in self.containerView.subviews) {
            [node removeFromSuperview];
        }
        
        
        NSUInteger treeMargin = 0;
        for (NSMutableArray *tree in self.trees) {
            NSUInteger thisTreeGreatestSectionMargin = 0;
            NSInteger treeWidth = [[self.treeNodeWidthForTreeArrayObject objectForKey:tree] integerValue];
            for (NSMutableArray *level in tree) {
                NSInteger levelWidth = [[self.nodesOnSingleLevelForLevelArrayObject objectForKey:level] integerValue];
                NSUInteger sectionMargin = 0;
                for (NSMutableArray *section in level) {
                    for (SkillTemplate *skillTemplate in section) {
                        Skill *skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:skillTemplate withCharacter:self.character];
                        
                        float nodeX;
                        if (treeWidth > levelWidth) {
                            nodeX = borderSize + treeMargin + (((float)treeWidth) / ((float)levelWidth + 1) * ([section indexOfObject:skillTemplate] + 1)) * (nodeDiameter + minimalMarginBetweenNodesX) - (nodeDiameter + minimalMarginBetweenNodesX);
                            
                        }
                        else {
                            nodeX = borderSize + treeMargin + sectionMargin + [section indexOfObject:skillTemplate] * (nodeDiameter + minimalMarginBetweenNodesX);
                        }
                        float nodeY = ([tree indexOfObject:level] * (nodeDiameter + minimalMarginBetweenNodesY)) + minimalMarginBetweenNodesY;
                        CGRect skillNodeFrame = CGRectMake(nodeX, nodeY, nodeDiameter, nodeDiameter);
                        NodeViewController *newSkillNode = [NodeViewController getInstanceFromStoryboardWithFrame:skillNodeFrame];
                        newSkillNode.skill = skill;
                        [self addChildViewController:newSkillNode];
                        [self.containerView addSubview:newSkillNode.view];
                        newSkillNode.delegate = self;
                        
                        [self.nodeIndexesForSkillNames setObject:newSkillNode forKey:skillTemplate.name];
                        if (skillTemplate.basicSkillTemplate) {
                            if ([self.nodeIndexesForSkillNames valueForKey:skillTemplate.basicSkillTemplate.name]) {
                                
                                [newSkillNode setParentNodeLink:[self.nodeIndexesForSkillNames valueForKey:skillTemplate.basicSkillTemplate.name] placeInView:self.containerView addToController:self];
                            }
                        }
                        [self.allExistingNodes addObject:newSkillNode];
                        
                    }
                    sectionMargin += section.count * (nodeDiameter + minimalMarginBetweenNodesX) + minimalMarginBetweenNodesX;
                    thisTreeGreatestSectionMargin = (sectionMargin > thisTreeGreatestSectionMargin) ? sectionMargin : thisTreeGreatestSectionMargin;
                }
            }
            treeMargin += thisTreeGreatestSectionMargin + minimalMarginBetweenTrees;
        }
        [self updateStatHeader];
    }
}


-(void)refreshSkillvalues;
{
    [self refreshSkillvaluesWithReloadingSkills:false];
}

-(void)refreshSkillvaluesWithReloadingSkills:(BOOL)needReload;
{
    for (NodeViewController *node in self.allExistingNodes) {
        if (needReload) {
            node.skill = nil;
        }
        [node updateInterface];
    }
    
    [self updateStatHeader];
}


-(void)resetPointsLeftProgress
{
    if (self.isInCreatingNewCharacterMod) {
        [UserDefaultsHelper clearTempDataForCharacterId:self.character.characterId];
        self.isInCreatingNewCharacterMod = true;
    }
}

-(void)changeYStatLayout:(float)newYLayout animated:(BOOL)animated;
{
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.customHeaderStatLayoutY = newYLayout;
            [self centerScrollViewContents];
            CGRect newHeaderFrame = self.statHeaderController.view.frame;
            newHeaderFrame.origin.y = 0 + newYLayout;
            self.statHeaderController.view.frame = newHeaderFrame;
        }];
    }
    self.customHeaderStatLayoutY = newYLayout;
    [self centerScrollViewContents];
    CGRect newHeaderFrame = self.statHeaderController.view.frame;
    newHeaderFrame.origin.y = 0 + newYLayout;
    self.statHeaderController.view.frame = newHeaderFrame;
}


#pragma mark UIScrollViewDelegate methods
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerForContainerView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}


- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerForContainerView.frame;

    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if ((contentsFrame.size.height - self.customHeaderStatLayoutY ) < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height + self.customHeaderStatLayoutY) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerForContainerView.frame = contentsFrame;

}


#pragma mark NodeViewControllerProtocol methods
-(Skill *)needNewSkillObjectWithTemplate:(SkillTemplate *)skillTemplate
{
    Skill *skill;
    if (self.character) {
        skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:skillTemplate withCharacter:self.character];
    }
    return skill;
}

-(void)didSwipNodeDown:(NodeViewController *)node
{
    if (!node.skill.skillTemplate.isMediator) {
        float xpPointsToTake;
        if (self.isInCreatingNewCharacterMod) {
            if ([self.operationStack valueForKey:node.skill.skillTemplate.name]) {
                NSMutableArray *skillStack = [self.operationStack valueForKey:node.skill.skillTemplate.name];
                NSNumber *lastPoints = skillStack.lastObject;
                if (lastPoints) {
                    xpPointsToTake = lastPoints.floatValue;
                    [skillStack removeObject:lastPoints];
                    self.xpPointsLeft = self.xpPointsLeft + xpPointsToTake;
                    [[SkillManager sharedInstance] removeXpPoints:xpPointsToTake toSkill:node.skill];
                    [UserDefaultsHelper setPointsLeft:self.xpPointsLeft andOperationStack:self.operationStack forCharacterWithId:self.character.characterId];
                }
            }
        }
        else {
            [[SkillManager sharedInstance] removeXpPoints:1.0f toSkill:node.skill];
        }
    }
}

-(void)didSwipNodeUp:(NodeViewController *)node
{
    if (!node.skill.skillTemplate.isMediator) {
        if (self.isInCreatingNewCharacterMod) {
            if (self.xpPointsLeft > 0) {
                float xpPointsToGive;
                xpPointsToGive = [[SkillManager sharedInstance] countXpNeededForNextLevel:node.skill];
                xpPointsToGive -= node.skill.currentProgress;
                
                if (self.xpPointsLeft > xpPointsToGive) {
                    self.xpPointsLeft = self.xpPointsLeft - xpPointsToGive;
                }
                else {
                    xpPointsToGive = self.xpPointsLeft;
                    self.xpPointsLeft = 0;
                }
                
                //registrate progress
                NSMutableArray *skillStack = [self.operationStack valueForKey:node.skill.skillTemplate.name];
                if (!skillStack) {
                    skillStack = [NSMutableArray new];
                    [self.operationStack setObject:skillStack forKey:node.skill.skillTemplate.name];
                }
                [skillStack addObject:@(xpPointsToGive)];
                
                [[SkillManager sharedInstance] addXpPoints:xpPointsToGive toSkill:node.skill];
                [UserDefaultsHelper setPointsLeft:self.xpPointsLeft andOperationStack:self.operationStack forCharacterWithId:self.character.characterId];
            }
        }
        else {
            [[SkillManager sharedInstance] addXpPoints:1.0f toSkill:node.skill];
        }
    }
}

-(void)didTapNode:(NodeViewController *)node
{
    NSLog(@"did tap node %@",node.skill.skillTemplate.name);
    TipViewController *tipController = [[TipViewController alloc] initWithSkillTemplate:node.skill.skillTemplate];
    CustomPopoverViewController *popover = [[CustomPopoverViewController alloc] initWithContentViewController:tipController];
    popover.popoverContentSize = CGSizeMake(self.view.frame.size.width * 0.7, self.view.frame.size.height * 0.7);
    
    [popover presentPopoverInView:self.view];
    //[[SkillManager sharedInstance] showDescriptionForSkillTemplate:node.skill.skillTemplate inView:self.scrollView.superview];
}

-(void)didTapNodeLevel:(NodeViewController *)node
{
    NSLog(@"did tap level of node %@",node.skill.skillTemplate.name);
}


#pragma mark SkillChangeProtocol
-(void)didChangeExperiencePointsForSkill:(Skill *)skill
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:skill.skillTemplate.name];
    if (node) {
        [node updateInterface];
        
        [UIView animateWithDuration:0.5 animations:^{
            node.skillButton.highlighted = true;
        } completion:^(BOOL success){
            [UIView animateWithDuration:0.1 animations:^{
                node.skillButton.highlighted = false;
            }];
        }];
    }
}

-(void)didChangeSkillLevel:(Skill *)skill
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:skill.skillTemplate.name];
    if (node) {
        for (Skill *subSkill in node.skill.subSkills) {
            [self checkForUpdateSubskillsOf:subSkill];
        }
    }
    [self updateStatHeader];
}


-(void)checkForUpdateSubskillsOf:(Skill *)skill
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:skill.skillTemplate.name];
    if (node) {
        [node updateInterface];
        [node lightUp];
        
        for (Skill *subSkill in node.skill.subSkills) {
            [self checkForUpdateSubskillsOf:subSkill];
        }
    }
}

#pragma mark StatSet protocol
-(void)didTapHealth;
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:[DefaultSkillTemplates sharedInstance].toughness.name];
    [self centerScrollViewOnNode:node];
    [node lightUp];
}

-(void)didTapInventory;
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:[DefaultSkillTemplates sharedInstance].strength.name];
    [self centerScrollViewOnNode:node];
    [node lightUp];
}

-(void)didTapMovement;
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:[DefaultSkillTemplates sharedInstance].physique.name];
    [self centerScrollViewOnNode:node];
    [node lightUp];
}

-(void)didTapInitiative;
{
    NodeViewController *node = [self.nodeIndexesForSkillNames objectForKey:[DefaultSkillTemplates sharedInstance].perception.name];
    [self centerScrollViewOnNode:node];
    [node lightUp];
}

-(void)centerScrollViewOnNode:(NodeViewController *)node
{
    CGPoint centerOnNode = CGPointMake((node.view.frame.origin.x + node.view.bounds.size.width) * self.scrollView.zoomScale - self.scrollView.frame.size.width / 2,
                                       (node.view.frame.origin.y + node.view.bounds.size.height) * self.scrollView.zoomScale - self.scrollView.frame.size.height / 2);
    [self.scrollView setContentOffset:centerOnNode animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
