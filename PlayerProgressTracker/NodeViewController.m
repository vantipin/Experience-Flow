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

@interface NodeViewController ()

@property (nonatomic) IBOutlet UIButton *skillLevelButton;

@property (nonatomic) CGPoint anchorPoint;
@property (nonatomic) CAKeyframeAnimation *driftAnimation;

@end

@implementation NodeViewController

+(NodeViewController *)getInstanceFromStoryboardWithFrame:(CGRect)frame;
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NodeView" bundle:nil];
    NodeViewController *controller = [storyboard instantiateInitialViewController];
    controller.view.frame =  frame;
    
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
    [self nodeAnimationInvokeWithPoint1:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])
                             withPoint2:CGPointMake([self getRandomPointWithAnchor:self.anchorPoint.x], [self getRandomPointWithAnchor:self.anchorPoint.y])];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    [self.view.layer removeAllAnimations];
}

-(void)setSkill:(Skill *)skill
{
    _skill = skill;
    if (_skill) {
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

-(void)updateInterface
{
    [self.skillButton setTitle:_skill.skillTemplate.name forState:UIControlStateNormal];
    [self.skillLevelButton setTitle:[NSString stringWithFormat:@"%d",_skill.currentLevel] forState:UIControlStateNormal];
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
        
        if (velocity.y > 0) {
            [self.delegate didSwipNodeDown:self];
        }
        else {
            [self.delegate didSwipNodeUp:self];
        }
    }
}


#pragma mark manage links

-(void)setParentNodeLink:(NodeViewController *)parentNodeLink;
{
    if (self.nodeLinkParent) {
        [self.nodeLinkParent.parent.nodeLinksChild removeObject:parentNodeLink];
        [self removeLink:self.nodeLinkParent];
    }
    self.nodeLinkParent = [self addLinkWithParent:parentNodeLink andChild:self];
}

-(void)removeLink:(NodeLinkController *)link;
{
    [link removeFromParentViewController];
    [link.view removeFromSuperview];
}

-(NodeLinkController *)addLinkWithParent:(NodeViewController *)parent andChild:(NodeViewController *)child
{
    CGPoint parentCenter = parent.view.center;
    CGPoint childCenter  = CGPointMake(child.view.center.x, child.view.center.y - (child.view.frame.size.height / 5));
    
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
    
    [self.parentViewController addChildViewController:newNodeLink];
    [parent.view.superview addSubview:newNodeLink.view];
    [parent.view.superview sendSubviewToBack:newNodeLink.view];

    return newNodeLink;
}


- (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    return bearingRadians;
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
    
    NSLog(@"did stop");
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
