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

#define CLOUD_NUM 7

@interface BJCloud : CCSprite {

    b2World *_world;
    CCSprite *cloudSprite[CLOUD_NUM];
    b2Body *cloudBody[CLOUD_NUM];

}
@property (assign) float currentPosX, currentPosY;
@property (assign) int width, height, interval, count;
@property (assign) BOOL exist;
- (void)addNewCloud:(CCLayer *)layer world:(b2World *)world number:(int)number;
- (void)moveCloud:(int)number;
@end
