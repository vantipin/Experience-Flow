//
//  CharacterViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 05.07.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillManager.h"
#import "ClassesDropViewController.h"
#import "CharacterProgressDataArchiver.h"

@interface CharacterViewController : UIViewController <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SkillChangeProtocol, CharacterProgressArchiverProtocol>

-(void)selectNewCharacter;
-(void)selectCharacter:(Character *)character;

@end
