//
//  NewCharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainContextObject.h"
#import "SkillManager.h"
#import "ColorConstants.h"
#import "ClassesDropViewController.h"
#import "AddSkillDropViewController.h"


@interface NewCharacterViewController : UIViewController <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol,AddNewSkillControllerProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@end
