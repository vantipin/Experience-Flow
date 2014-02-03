//
//  DropDownView.m
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Greatly upgrated and rewritten by Vlad Antipin at 2014

#import "DropDownViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface DropDownViewController ()

@property (nonatomic) UIView *cancelingView;
@property (nonatomic) CGFloat openTime;
@property (nonatomic) CGFloat closeTime;


@end

@implementation DropDownViewController

@synthesize dropDownTableView = _dropDownTableView;
@synthesize dropDownDataSource = _dropDownDataSource;
@synthesize anchorView = _anchorView;
@synthesize heightOfCell = _heightOfCell;
@synthesize openTime = _openTime;
@synthesize closeTime = _closeTime;
@synthesize heightTableView = _heightTableView;
@synthesize widthTableView = _widthTableView;
@synthesize selectedCell = _selectedCell;
@synthesize textColor = _textColor;
@synthesize font = _font;
@synthesize topView = _topView;

@synthesize cancelingView = _cancelingView;


-(UIView *)cancelingView
{
    if (!_cancelingView)
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        //prepare view for canceling dropview
        _cancelingView = [[UIView alloc] initWithFrame:screenRect];
        _cancelingView.opaque = false;
        _cancelingView.backgroundColor = [UIColor clearColor];
        
        
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAnimation)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        
        [_cancelingView addGestureRecognizer:tapRecognizer];
    }
    
    return _cancelingView;
}

- (id)initWithArrayData:(NSArray*)data
             cellHeight:(CGFloat)cHeight
         widthTableView:(CGFloat)tWidhtTableView
                refView:(UIView*)rView
              animation:(AnimationType)tAnimation
{
    if ((self = [super init])) {
        
		self.dropDownDataSource = data;
		self.heightOfCell = cHeight;
		self.anchorView = rView;
		self.heightTableView = cHeight*data.count;
        self.widthTableView = tWidhtTableView;
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		self.view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
		self.view.layer.shadowOpacity =1.0f;
		self.view.layer.shadowRadius = 1.0f;
		animationType = tAnimation;
	}
	
	return self;
}

- (id)initWithArrayData:(NSArray*)data
             cellHeight:(CGFloat)cHeight
         widthTableView:(CGFloat)tWidhtTableView
                refView:(UIView*)rView
              animation:(AnimationType)tAnimation
        backGroundColor:(UIColor *)color
{
    if ((self = [super init])) {
        
		self.dropDownDataSource = data;
		self.heightOfCell = cHeight;
		self.anchorView = rView;
		self.heightTableView = cHeight*data.count;
        self.widthTableView = tWidhtTableView;
		
        if (!color)
        {
            color = [UIColor clearColor];
        }
        [self.view setBackgroundColor:color];
		self.view.layer.shadowColor = [color CGColor];
		self.view.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
		self.view.layer.shadowOpacity =1.0f;
		self.view.layer.shadowRadius = 1.0f;
		animationType = tAnimation;
		
	}
	
	return self;
}


- (void)viewDidLoad {
    
	[super viewDidLoad];
	
    
    self.openTime = 0.15;
    self.closeTime = 0.15;
    self.view.autoresizesSubviews = true;
    self.view.autoresizingMask = UIViewAutoresizingNone;
	self.dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.widthTableView, self.heightOfCell) style:UITableViewStylePlain];
    self.dropDownTableView.backgroundColor = [UIColor clearColor];
	self.dropDownTableView.dataSource = self;
	self.dropDownTableView.delegate = self;
	[self.view addSubview:self.dropDownTableView];
	self.view.hidden = YES;
	if(animationType == AlphaAndHeightChange || animationType == AlphaChange)
		[self.view setAlpha:1];
}

- (void)rebuildFramesAccordingToPositionOnScreen
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float screenHeight = screenRect.size.height>screenRect.size.width?screenRect.size.width:screenRect.size.height;
    
	CGRect refFrame = [self.anchorView convertRect:self.anchorView.frame toView:(self.topView)?self.topView:self.anchorView];
    //NSLog(@"%@",NSStringFromCGRect(self.refView.frame));
    //NSLog(@"%@",NSStringFromCGRect(refFrame));
    
    
    //reset table height accordinaly
    self.heightTableView = self.dropDownDataSource.count*self.heightOfCell;
    
    float originalX = refFrame.origin.x;
    float originalY = refFrame.origin.y+refFrame.size.height;
    
    float viewHeightOnScreen; //used to check if dropdown goes beyond screen view
    float safeHeight;
    
    //decide if dropdown should go up or drop down according to giving position on screen AND check for popup to not go out of screen
    if (originalY > screenHeight*0.6)
    {
        //go up
        viewHeightOnScreen = (screenHeight - originalY) + self.heightTableView;
        safeHeight = viewHeightOnScreen > screenHeight ? screenHeight - (screenHeight - originalY) + 100 : self.heightTableView;
    }
    else
    {
        //drop down
        viewHeightOnScreen = originalY+self.heightTableView;
        safeHeight  = viewHeightOnScreen > screenHeight ? screenHeight - (originalY + 100) : self.heightTableView;
    }

    

    self.dropDownTableView.frame = CGRectMake(0,
                                              0,
                                              self.widthTableView,
                                              safeHeight);
    
    self.view.frame = CGRectMake(originalX,
                                 originalY,
                                 self.widthTableView,
                                 (animationType == AlphaChange)?safeHeight:1);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

/*
- (void)dealloc
{
	
}
 */

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.heightOfCell;
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.dropDownDataSource count];
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"dropDownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
    {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.frame = cell.bounds;
    }
    else
    {
        for (UIView *subview in [cell.contentView subviews])
        {
            [subview removeFromSuperview];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if ([[self.dropDownDataSource lastObject] isKindOfClass:[NSString class]])  
    {
        if (self.textColor)
        {
            [cell.textLabel setTextColor:self.textColor];
        }
        if (self.font)
        {
            [cell.textLabel setFont:self.font];
        }
        cell.textLabel.text = self.dropDownDataSource[indexPath.row];
    }
    else if ([[self.dropDownDataSource lastObject] isKindOfClass:[UIView class]])
    {
        UIView *subview = self.dropDownDataSource[indexPath.row];
        cell.frame = CGRectMake(0,
                                0,
                                subview.frame.size.width,
                                subview.frame.size.height);
        subview.frame = cell.bounds;
        [cell.contentView addSubview:subview];
    }
		
	return cell;
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell = indexPath;
	[self.delegateDropDown dropDownCellSelected:indexPath.row];
	[self closeAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"";
}

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation
{
    [self rebuildFramesAccordingToPositionOnScreen];
    //update table data before showing
    [self.dropDownTableView reloadData];
	self.view.hidden = NO;
    
    //add view for cancel dropdown
    [self.view.superview addSubview:self.cancelingView];
    
    //push forward dropdown anyway
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:self.openTime animations:^{
        
        if(animationType == AlphaAndHeightChange || animationType == HeightChange)
            self.view.frame = CGRectMake(self.view.frame.origin.x,
                                         self.view.frame.origin.y,
                                         self.view.frame.size.width,
                                         self.heightTableView);
        
        if(animationType == AlphaAndHeightChange || animationType == AlphaChange)
            self.view.alpha = 1;
    }];
}

-(void)closeAnimation
{
    //remove view for canceling dropdown
    [self.cancelingView removeFromSuperview];
    
    [UIView animateWithDuration:self.openTime animations:^{
        if(animationType == AlphaAndHeightChange || animationType == HeightChange)
            self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                self.view.frame.origin.y,
                                                self.view.frame.size.width,
                                                1);
        
        if(animationType == AlphaAndHeightChange || animationType == AlphaChange)
            self.view.alpha = 0;
    } completion:^(BOOL finished){
        [self hideView];
    }];
    
    if (self.selectedCell)
    [self.dropDownTableView deselectRowAtIndexPath:self.selectedCell animated:NO];
}

	 
-(void)hideView
{
	self.view.hidden = YES;
}

@end
