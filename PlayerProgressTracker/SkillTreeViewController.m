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

static float minimalMarginBetweenTrees = 100;
static float minimalMarginBetweenNodesX = 70;
static float minimalMarginBetweenNodesY = 180;
static float borderSize = 100;
static float nodeDiameter = 200;

static NSString *emptyParentKey = @"emptyParent";

@interface SkillTreeViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *containerView;


@property (nonatomic) NSMutableArray *trees;

@property (nonatomic) NSMutableDictionary *treeWidthForTreeArrayObject;
@property (nonatomic) NSMutableDictionary *nodesOnSingleLevelForLevelArrayObject;
@property (nonatomic) NSMutableDictionary *sectionIndexesForSkillParentName;
@property (nonatomic) long treeHeight;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTree];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.view.autoresizesSubviews = true;
    
    float width = borderSize;
    for (NSMutableArray *tree in self.trees) {
        NSInteger currentTreeWidth = [[self.treeWidthForTreeArrayObject objectForKey:tree] integerValue];
        width += currentTreeWidth * (minimalMarginBetweenNodesX + nodeDiameter);
    }
    width += (self.trees.count - 1) * minimalMarginBetweenTrees;
    
    float height = (self.treeHeight * (nodeDiameter + minimalMarginBetweenNodesY)) + minimalMarginBetweenNodesY + (borderSize * 2);
    self.scrollView.contentSize = CGSizeMake(width, height);
    
    self.containerView.frame = CGRectMake(0, 0, width, height);
    
    
    float scaleWidth = self.scrollView.frame.size.width / self.scrollView.contentSize.width;
    float scaleHeight = self.scrollView.frame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.scrollEnabled = true;
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = 1.0f;
    
    [self resetSkillNodes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.delegate = self;
        [self.view addSubview:self.scrollView];
    }
    return _scrollView;
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        [self.scrollView addSubview:self.containerView];
    }
    return _containerView;
}

-(void)setCharacter:(Character *)character
{
    if (character) {
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

-(NSMutableDictionary *)treeWidthForTreeArrayObject
{
    if (!_treeWidthForTreeArrayObject) {
        _treeWidthForTreeArrayObject = [NSMutableDictionary new];
    }
    
    return _treeWidthForTreeArrayObject;
}

#pragma mark -
#pragma build tree methods
-(void)initTree
{
    self.trees = [NSMutableArray new];
    self.treeHeight = 0;
    self.treeWidthForTreeArrayObject = nil;
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
        for (NSMutableArray *level in tree) {
            NSInteger levelWidth= 0;
            for (NSMutableArray *section in level) {
                levelWidth += section.count;
            }
            levelWidth += level.count - 1 ? : 0;
            [self.nodesOnSingleLevelForLevelArrayObject setObject:[NSNumber numberWithInteger:levelWidth] forKey:level];
            if (levelWidth > treeWidth) {
                treeWidth = levelWidth;
            }
        }
        [self.treeWidthForTreeArrayObject setObject:[NSNumber numberWithInteger:treeWidth] forKey:tree];
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
        [self.sectionIndexesForSkillParentName setObject:[NSNumber numberWithUnsignedInt:currentLevel.count] forKey:parentName];
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
            NSInteger treeWidth = [[self.treeWidthForTreeArrayObject objectForKey:tree] integerValue];
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
                        float nodeY = borderSize + ([tree indexOfObject:level] * (nodeDiameter + minimalMarginBetweenNodesY)) + minimalMarginBetweenNodesY;
                        CGRect skillNodeFrame = CGRectMake(nodeX, nodeY, nodeDiameter, nodeDiameter);
                        NodeViewController *newSkillNode = [NodeViewController getInstanceFromStoryboardWithFrame:skillNodeFrame];
                        newSkillNode.skill = skill;
                        [self addChildViewController:newSkillNode];
                        [self.containerView addSubview:newSkillNode.view];
                        newSkillNode.delegate = self;
                    }
                    sectionMargin += section.count * (nodeDiameter + minimalMarginBetweenNodesX) + minimalMarginBetweenNodesX;
                    thisTreeGreatestSectionMargin = (sectionMargin > thisTreeGreatestSectionMargin) ? sectionMargin : thisTreeGreatestSectionMargin;
                }
            }
            treeMargin += thisTreeGreatestSectionMargin + minimalMarginBetweenTrees;
        }
    }
}


#pragma mark UIScrollViewDelegate methods
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"zooming....");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrolling...");
}

#pragma mark #import NodeViewControllerProtocol methods
-(void)didSwipNodeDown:(NodeViewController *)node
{
    NSLog(@"swipe down node %@",node.skill.skillTemplate.name);
}

-(void)didSwipNodeUp:(NodeViewController *)node
{
    NSLog(@"swipe up node %@",node.skill.skillTemplate.name);
}

-(void)didTapNode:(NodeViewController *)node
{
    NSLog(@"did tap node %@",node.skill.skillTemplate.name);
}

-(void)didTapNodeLevel:(NodeViewController *)node
{
    NSLog(@"did tap level of node %@",node.skill.skillTemplate.name);
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
