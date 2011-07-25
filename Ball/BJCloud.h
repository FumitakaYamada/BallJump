//
//  BJCloud.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface BJCloud : NSObject {
    float currentX;
    float currentY;
    int width;
    int height;
    int imageNum;
    int interval;
    int count;
}
@property (assign) float currentPosX, currentPosY;
@property (assign) int width, height, imageNum, interval, count;
- (void)moveWithHeight:(b2Body *)body h:(int)h;
@end
