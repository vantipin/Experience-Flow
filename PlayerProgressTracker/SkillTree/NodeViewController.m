//
//  NodeViewController.m
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 14.05.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "NodeViewController.h"
#import "NodeLinkController.h"
#import "SkillTemplate.h"
#import "SkillManager.h"
#import "DefaultSkillTemplates.h"
#import "Constants.h"

#define healthyNodeShiningColor kRGB(128, 181, 231, 1)
#define undevelopedNodeShiningColor kRGB(208, 215, 231, 1)

@interface NodeViewController ()

@property (nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (nonatomic) IBOutlet UIImageView *xpAuraImageView;
@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CAKeyframeAnimation *driftAnimation;
@property (nonatomic) SkillTemplate *skillTemplate;
@property (nonatomic) BOOL isLightUp;
@property (nonatomic) NSInteger expectedMinLevel;

@end

@implementation NodeViewController

@synthesize skill = _skill;

+(NodeViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NodeView" bundle:nil];
    NodeViewController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame =  frame;
    controller.isLightUp = false;
    
    return controller;
}

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

-(void)viewWillAppear:(BOOL)animated
{
    self.anchorPoint = self.view.center;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self nodeAnimationInvokeWithPoint1:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])
//                             withPoint2:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.view.layer removeAllAnimations];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    [self.view.layer removeAllAnimations];
}

-(Skill *)skill
{
    if (!_skill) {
        if (self.delegate && self.skillTemplate) {
            self.skill = [self.delegate needNewSkillObjectWithTemplate:self.skillTemplate];
        }
    }
    
    return _skill;
}

-(void)setSkill:(Skill *)skill
{
    _skill = skill;
    if (_skill) {
        self.skillTemplate = _skill.skillTemplate;
        
        if ([self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].toughness.name]) {
            self.expectedMinLevel = expectedMinLevelForToughness;
        }
        else if ([self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].physique.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].intelligence.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].melee.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].range.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].crashing.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].cutting.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].piercing.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].thrown.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].bow.name] ||
                 [self.skill.skillTemplate.name isEqualToString:[DefaultSkillTemplates sharedInstance].firearm.name]) {
            self.expectedMinLevel = expectedMinLevelForCoreSkills;
        }
        else {
            self.expectedMinLevel = expectedMinLevelForOtherAdvanced;
        }
        
        [self updateInterface];
    }
}


-(CAKeyframeAnimation *)driftAnimation
{
    if (!_driftAnimation) {
        _driftAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        _driftAnimation.repeatCount = 1;
        _driftAnimation.delegate = self;
        _driftAnimation.removedOnCompletion = true;
        _driftAnimation.autoreverses = true;
        _driftAnimation.fillMode = kCAFillModeForwards;
        _driftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    
    return _driftAnimation;
}

-(NSMutableArray *)nodeLinksChild
{
    if (!_nodeLinksChild) {
        _nodeLinksChild = [NSMutableArray new];
    }
    
    return _nodeLinksChild;
}


-(void)processXPAura
{
    CAShapeLayer *layer = [CAShapeLayer new];//initWithLayer:self.xpAuraImageView.layer];
    
    float portionToShow =  self.skill.currentProgress / [[SkillManager sharedInstance] countXpNeededForNextLevel:self.skill];

    CGFloat angle = (portionToShow * 2 * M_PI) + (3 * M_PI / 2);
    CGPoint center = self.xpAuraImageView.center;
    CGFloat radius = self.xpAuraImageView.frame.size.width / 2;

    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf((3 * M_PI / 2)), center.y + radius * sinf((3 * M_PI / 2)))];
    [piePath addArcWithCenter:center radius:radius startAngle:(3 * M_PI / 2) endAngle:angle clockwise:YES];
    [piePath addLineToPoint:center];
    [piePath closePath]; // this will automatically add a straight line to the center
    
    layer.path = piePath.CGPath;//[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:(3 * M_PI / 2) endAngle:angle clockwise:true].CGPath;
    
    self.xpAuraImageView.layer.mask = layer;
}

-(void)updateInterface
{
    NSInteger level = [[SkillManager sharedInstance] countUsableLevelValueForSkill:self.skill];
    self.skillLevelLabel.text = [NSString stringWithFormat:@"%ld",(long)level];
    BOOL isDeveloped = [self isDeveloped];
    
    
    if (self.skill.skillTemplate.isMediator) {
        UIImage *image = isDeveloped ? [UIImage imageNamed:@"skillNodeMediator"] : [UIImage imageNamed:@"skillNodeMediatorUndeveloped"];
        [self.skillButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.skillButton setBackgroundImage:[UIImage imageNamed:@"skillNodeMediatorHightlited"] forState:UIControlStateHighlighted];
        self.xpAuraImageView.image = [UIImage imageNamed:@"xpMediatorAura"];
        self.skillLevelLabel.hidden = true;
    }
    else {
        UIImage *image = isDeveloped ? [UIImage imageNamed:@"skillNode"] : [UIImage imageNamed:@"skillNodeUndeveloped"];
        [self.skillButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.skillButton setBackgroundImage:[UIImage imageNamed:@"skillNodeHighlited"] forState:UIControlStateHighlighted];
        self.xpAuraImageView.image = [UIImage imageNamed:@"xpAura"];
        self.skillLevelLabel.hidden = false;
        self.skillLevelLabel.textColor = isDeveloped ? healthyNodeShiningColor : undevelopedNodeShiningColor;
    }
    
    [self processLinkVisibility];
    self.view.alpha = isDeveloped ? 1 : 0.95;
    [self.skillButton setTitle:self.skill.skillTemplate.name forState:UIControlStateNormal];
    
    [self processXPAura];
}

-(void)processLinkVisibility
{
    self.nodeLinkParent.view.alpha = [self isDeveloped] ? 1 : 0.4;
}

-(BOOL)isDeveloped
{
    NSInteger level = self.skillLevelLabel.text.integerValue;
    return (self.expectedMinLevel >= level) ? false : true;
}

-(IBAction)didTabSkillButton:(id)sender
{
    [self.delegate didTapNode:self];
}


-(IBAction)didTabSkillLevelButton:(id)sender
{
    [self.delegate didTapNodeLevel:self];
}


- (IBAction)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed || gestureRecognizer.state == UIGestureRecognizerStateCancelled){
        CGPoint velocity = [gestureRecognizer velocityInView:self.view];
        
        if (abs(velocity.x) < abs(velocity.y)) {
            if (velocity.y > 0) {
                [self.delegate didSwipNodeDown:self];
            }
            else {
                [self.delegate didSwipNodeUp:self];
            }
        }
    }
}


#pragma mark manage links

-(void)setParentNodeLink:(NodeViewController *)parentNodeLink placeInView:(UIView *)containerView addToController:(UIViewController *)controller;
{
    if (self.nodeLinkParent) {
        [self.nodeLinkParent.parent.nodeLinksChild removeObject:parentNodeLink];
        [self removeLink:self.nodeLinkParent];
    }
    self.nodeLinkParent = [self addLinkWithParent:parentNodeLink andChild:self placeInView:containerView addToController:controller];
    
    [self processLinkVisibility];
}

-(void)removeLink:(NodeLinkController *)link;
{
    [link removeFromParentViewController];
    [link.view removeFromSuperview];
}

-(NodeLinkController *)addLinkWithParent:(NodeViewController *)parent andChild:(NodeViewController *)child placeInView:(UIView *)containerView addToController:(UIViewController *)controller;
{
    CGPoint parentCenter = parent.view.center;
    CGPoint childCenter  = CGPointMake(child.view.center.x, child.view.center.y - (child.view.frame.size.height / 6));
    
    float originX = parentCenter.x;
    float originY = parentCenter.y;
    float sizeX   = hypotf(parentCenter.x - childCenter.x, parentCenter.y - childCenter.y);
    float sizeY   = 90;
    
    CGRect linkFrame = CGRectMake(originX, originY, sizeX, sizeY);
    
    NodeLinkController *newNodeLink = [NodeLinkController getInstanceFromStoryboardWithFrame:linkFrame];
    //turn the image
    //...
    CGFloat angle = [self pointPairToBearingDegrees:parentCenter secondPoint:childCenter];
    newNodeLink.view.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
    newNodeLink.view.layer.position = linkFrame.origin;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(angle);
    [newNodeLink.view setTransform:rotate];

    
    [parent.nodeLinksChild addObject:newNodeLink];
    child.nodeLinkParent = newNodeLink;
    
    newNodeLink.parent = parent;
    newNodeLink.child  = child;
    
    [containerView addSubview:newNodeLink.view];
    [containerView sendSubviewToBack:newNodeLink.view];
    [controller addChildViewController:newNodeLink];
    
    return newNodeLink;
}


- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    return bearingRadians;
}


-(void)lightUp;
{
    if (!self.isLightUp) {
        self.isLightUp = true;
        [UIView animateWithDuration:0.5 animations:^{
            self.skillButton.highlighted = true;
        } completion:^(BOOL success){
            [UIView animateWithDuration:0.1 animations:^{
                self.skillButton.highlighted = false;
                self.isLightUp = false;
            }];
        }];
    }
}

#pragma mark animations


-(CAKeyframeAnimation *)nodeAnimationInvokeWithPoint1:(CGPoint)point1 withPoint2:(CGPoint)point2;
{
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    self.point1 = point1;
    self.point2 = point2;
    
    CGPathMoveToPoint(thePath, nil, self.anchorPoint.x, self.anchorPoint.y);
    CGPathAddCurveToPoint(thePath, nil,
                          point1.x, point1.y,
                          point2.x, point2.y,
                          self.anchorPoint.x, self.anchorPoint.y);
    
    self.driftAnimation.path = thePath;
    
    float duration = 4;
    self.driftAnimation.duration = duration;
    
    [self.view.layer addAnimation:_driftAnimation forKey:@"position"];
    
    self.driftAnimation.removedOnCompletion = true;
    
    return self.driftAnimation;
}


-(float)getRandomPointWithAnchor:(float)anchorValue
{
    int movingRadius = 70;
    float randomVal = arc4random() % movingRadius;
    randomVal -= movingRadius / 2;
    float result = anchorValue + randomVal;
    return result;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //NSLog(@"reinvoke animation");
    if (self.view.window) {
        [self nodeAnimationInvokeWithPoint1:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])
                                 withPoint2:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])];
    }
    
    self.point1 = CGPointZero;
    self.point2 = CGPointZero;
}


- (void)invokeAnimationWithX:(float)x withY:(float)y
{
    x = (arc4random() %30);
    y = (arc4random() %30);
    x -= 15;
    y -= 15;
    
    float duration = (abs(x) > 9 || abs(y) > 9) ? 3 : 1.5 + arc4random() %2;
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x + x,
                                     self.view.frame.origin.y + y,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    } completion:^(BOOL success){
        float duration = (abs(x) > 9 || abs(y) > 9) ? 3 : 1.5 + arc4random() %2;
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x - x,
                                         self.view.frame.origin.y - y,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
        } completion:^(BOOL success){
            [self invokeAnimationWithX:x withY:y];
        }];
    }];
}



@end
