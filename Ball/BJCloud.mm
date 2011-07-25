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
@synthesize currentPosX, currentPosY, nextPosX, nextPosY, width, height, imageNum, interval, count;

- (void)moveWithHeight:(b2Body *)body h:(int)h{
    body->SetLinearVelocity(b2Vec2(0.0, 2.5f));
    if (body->GetPosition().y*PTM_RATIO > 480 + h) {
        float nextY = rand()%320/PTM_RATIO;
        if (nextPosY < 40) {
            b2Vec2 moveFoewardPlayer(nextY + 40/PTM_RATIO, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }else if (nextY > 280){
            b2Vec2 moveFoewardPlayer(nextY - 40/PTM_RATIO, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }else {
            b2Vec2 moveFoewardPlayer(nextY, - h*2/PTM_RATIO);
            body->SetTransform(moveFoewardPlayer, 0);
        }
    }
}

@end
