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

static float minimalMarginBetweenTrees = 70;
static float minimalMarginBetweenNodes = 70;
static float borderSize = 200;
static float nodeDiameter = 200;

@interface SkillTreeViewController ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *containerView;

@property (nonatomic) NSMutableArray *treeLevels;
@property (nonatomic) NSMutableDictionary *treeLevelIndexesForSkillNames;
@property (nonatomic) long treeHeight;
@property (nonatomic) long treeWidth;

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
    
    float width = (self.treeWidth * (nodeDiameter + minimalMarginBetweenNodes)) + minimalMarginBetweenNodes;
    float height = (self.treeHeight * (nodeDiameter + minimalMarginBetweenNodes)) + minimalMarginBetweenNodes;
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

-(NSMutableDictionary *)treeLevelIndexesForSkillNames
{
    if (!_treeLevelIndexesForSkillNames) {
        _treeLevelIndexesForSkillNames = [NSMutableDictionary new];
    }
    
    return _treeLevelIndexesForSkillNames;
}

-(void)initTree
{
    self.treeLevels = [NSMutableArray new];
    self.treeHeight = 0;
    self.treeWidth = 0;
    
    NSArray *allTemplates = [[DefaultSkillTemplates sharedInstance] allSkillTemplates];
    
    for (SkillTemplate *skill in allTemplates) {
        
        long levelInATree = [[SkillManager sharedInstance] countSkillsInChainStartingWithSkill:skill];
        
        long notYetInitedLevelsOfTree = (levelInATree - self.treeLevels.count > 0) ? levelInATree - self.treeLevels.count : 0;
        for (int i = 0; i < notYetInitedLevelsOfTree; i++) {
            [self.treeLevels addObject:[NSMutableArray new]];
        }
        
        if (levelInATree > self.treeHeight) {
            self.treeHeight = levelInATree;
        }
        
        long level = levelInATree - 1;
        NSMutableArray *currentLevel = [self.treeLevels objectAtIndex:level];
        [currentLevel addObject:skill];
        [self.treeLevelIndexesForSkillNames setObject:[NSNumber numberWithLong:level] forKey:skill.name];
        
        
        if (currentLevel.count > self.treeWidth) {
            self.treeWidth = currentLevel.count;
        }
    }

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
        
        NSArray *allSkillTemplates = [[DefaultSkillTemplates sharedInstance] allSkillTemplates];
        
        for (SkillTemplate *skillTemplate in allSkillTemplates) {
            Skill *skill = [[SkillManager sharedInstance] getOrAddSkillWithTemplate:skillTemplate withCharacter:self.character];
            
            NSNumber *levelNumber = [self.treeLevelIndexesForSkillNames valueForKey:skillTemplate.name];
            float nodeYInTree = [levelNumber floatValue];
            
            NSMutableArray *levelArray = [self.treeLevels objectAtIndex:[levelNumber intValue]];
            float nodeXInTree = [levelArray indexOfObject:skillTemplate];
            
            float nodeX = (self.containerView.frame.size.width / ((float)levelArray.count + 1)) * (nodeXInTree + 1);//(nodeXInTree * (nodeDiameter + minimalMarginBetweenNodes)) + minimalMarginBetweenNodes;
            float nodeY = (nodeYInTree * (nodeDiameter + minimalMarginBetweenNodes)) + minimalMarginBetweenNodes;
            CGRect skillNodeFrame = CGRectMake(nodeX, nodeY, nodeDiameter, nodeDiameter);
            NodeViewController *newSkillNode = [NodeViewController getInstanceFromStoryboardWithFrame:skillNodeFrame];
            newSkillNode.skill = skill;
            [self addChildViewController:newSkillNode];
            [self.containerView addSubview:newSkillNode.view];
            newSkillNode.delegate = self;
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
