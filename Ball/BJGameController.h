//
//  BJGameController.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum _BJLayerZ {
    BJLayerZBackground  = 0x00000001 << 0,
    BJLayerZMain        = 0x00000001 << 1,
    BJLayerZAlert       = 0x00000001 << 2
} BJLayerZ;

@interface BJGameController : NSObject

@property (nonatomic, retain) CCScene *mainScene;

+ (BJGameController *)controller;

@end
