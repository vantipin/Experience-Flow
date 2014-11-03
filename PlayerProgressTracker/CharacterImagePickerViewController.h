//
//  CharacterImagePickerViewController.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 31/10/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import "CustomPopoverViewController.h"
#import "iCarousel.h"

@protocol CharacterImagePickerProtocol <NSObject>

- (void) didPickImageNamed:(NSString *)name;

@end

@interface CharacterImagePickerViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>

+(CharacterImagePickerViewController *)getInstanceFromStoryboard;

@property (nonatomic,assign) id<CharacterImagePickerProtocol> delegate;

@end
