//
//  PicManager.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 19/08/14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicManager : NSObject

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

@end
