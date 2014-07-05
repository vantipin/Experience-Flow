//
//  ColorConstants.h
//  PlayerProgressTracker
//
//  Created by Vlad Antipin on 01.01.14.
//  Copyright (c) 2014 WierdMasks. All rights reserved.
//

#define kRGB(r, g, b, a) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)]

#define defaultFont      [UIFont fontWithName:@"Bodoni 72 Smallcaps" size:17]

#define lightBodyColor   kRGB(225., 225., 235.,0.8)//kRGB(255., 249., 239.,1.)
#define bodyColor        kRGB(209., 219., 219.,1.)
#define darkBodyColor    kRGB(220., 229., 229.,1.)
#define textEditColor    kRGB(0., 122., 255.,1.)

/*
 For cash free image usage. Using imageNamed instead of imageWithContantsOfFile will not free memory from loaded images leading to memory crash on retina.
 */
#define filePathWithName(fileEndPath) [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],(fileEndPath)]