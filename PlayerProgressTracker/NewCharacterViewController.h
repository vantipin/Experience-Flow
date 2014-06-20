//
//  NewCharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 30.12.13.
//  Copyright (c) 2013 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillManager.h"
#import "ClassesDropViewController.h"


@interface NewCharacterViewController : UIViewController <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SkillChangeProtocol>


@end
