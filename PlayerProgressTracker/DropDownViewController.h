//
//  DropDownView.h
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Greatly upgrated and rewritten by Vlad Antipin at 2014

#import <UIKit/UIKit.h>

typedef enum {
    AlphaChange,
	HeightChange,
	AlphaAndHeightChange
} AnimationType;

@class DropDownViewController;

@protocol DropDownViewDelegate
@required
-(void)dropDownController:(DropDownViewController *)dropDown cellSelected:(NSIndexPath *)returnIndex;
@end


@interface DropDownViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	NSInteger animationType;
}
@property (assign) id<DropDownViewDelegate> delegateDropDown;
@property (nonatomic,retain)UITableView *dropDownTableView;
@property (nonatomic,retain) NSArray *dropDownDataSource;      //table data source. View can process array of strings or array of views
@property (nonatomic) CGFloat heightOfCell;
@property (nonatomic) CGFloat heightTableView;
@property (nonatomic) CGFloat widthTableView;
@property (nonatomic,retain)UIView *anchorView;  //anchor view used to place dropdown under it
@property (nonatomic) NSIndexPath *selectedCell;
@property (nonatomic,weak) UIView *topView;      //(optional) global view used for calculating original x,y. If nil anchor view is used instead
@property (nonatomic) UIView *cancelingView;

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIFont *font;

- (id)initWithArrayData:(NSArray*)data
             cellHeight:(CGFloat)cHeight
         widthTableView:(CGFloat)tWidhtTableView
                refView:(UIView*)rView
              animation:(AnimationType)tAnimation;

- (id)initWithArrayData:(NSArray*)data
             cellHeight:(CGFloat)cHeight
         widthTableView:(CGFloat)tWidhtTableView
                refView:(UIView*)rView
              animation:(AnimationType)tAnimation
        backGroundColor:(UIColor *)color;

-(void)customReshapeFrames;//rewrite this method in child class for additional offsets and frame changes before dropDown opens
-(void)customActionOnClose;//rewrite this method in child class to perform changes when element just closed
-(void)customActionOnOpen;//rewrite this method in child class to perform changes when element just opened
-(void)closeAnimation;
-(void)openAnimation;


@end
