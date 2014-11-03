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
#import "CharacterDataArchiver.h"
#import "CharacterImagePickerViewController.h"

@protocol CharacterControllerProtocol <NSObject>

-(void)didUpdateCharacter:(Character *)character;

@end

@interface CharacterViewController : UIViewController <UITextFieldDelegate,DropDownViewDelegate,UIAlertViewDelegate,DeleteStatSetProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SkillChangeProtocol, CharacterImagePickerProtocol>

-(void)selectNewCharacter;
-(void)selectCharacter:(Character *)character;

-(IBAction)changePlayerIconTap:(id)sender;

@property (nonatomic) id<CharacterControllerProtocol> delegate;

@end
