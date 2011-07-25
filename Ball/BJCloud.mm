//
//  BJCloud.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJCloud.h"

#define PTM_RATIO 32


@implementation BJCloud
@synthesize currentPosX, currentPosY, width, height, imageNum, interval, count;

- (void)moveWithHeight:(b2Body *)body h:(int)h{
    body->SetLinearVelocity(b2Vec2(0.0, 2.5f));
    if (body->GetPosition().y*PTM_RATIO > 480 + h) {
        float nextPosY = rand()%320/PTM_RATIO;
        if (nextPosY < 40) {
            b2Vec2 moveFoewardPlayer(nextPosY + 40/PTM_RATIO, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }else if (nextPosY > 280){
            b2Vec2 moveFoewardPlayer(nextPosY - 40/PTM_RATIO, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }else {
            b2Vec2 moveFoewardPlayer(nextPosY, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }
    }
}

@end
