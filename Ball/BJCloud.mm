//
//  BJCloud.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJCloud.h"

#define PTM_RATIO 32


@interface BJCloud()
@property (assign) int imageNumber;
@property (assign) float posX, posY;
@end

@implementation BJCloud
@synthesize currentPosX, currentPosY, width, height, interval, count, exist;
@synthesize imageNumber, posX, posY;

- (void)addNewCloud:(CCLayer *)layer world:(b2World *)world number:(int)number{
    srand(time(NULL));
    
    _world = world;
    
    imageNumber = rand()%3 + 1;
    for (int i = 1; i < 5; i++) {
        if (imageNumber == i) {
            cloudSprite[number] = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cloud%d.png", i]];
            [layer addChild:cloudSprite[number] z:100];
        }
    }

    if (number == 0) {
        posX = [CCDirector sharedDirector].winSize.width/2;
        posY = -cloudSprite[number].contentSize.height/2;
    }else {
        posX = rand()%320;
        posY = -cloudSprite[number].contentSize.height/2;
    }
    
    b2BodyDef cloudBodyDef;
    cloudBodyDef.type = b2_dynamicBody;
    cloudBodyDef.userData = cloudSprite[number];
    cloudBodyDef.position.Set(posX/PTM_RATIO, posY/PTM_RATIO);
    cloudBody[number] = _world->CreateBody(&cloudBodyDef);
    b2PolygonShape shape;
    shape.SetAsBox((cloudSprite[number].contentSize.width/2 - 5)/PTM_RATIO, (cloudSprite[number].contentSize.height/2 - 15)/PTM_RATIO);
    b2FixtureDef cloudFixtureDef;
    cloudFixtureDef.shape = &shape;
    
    cloudBody[number]->CreateFixture(&shape, 0.0f);
    
    _world = NULL;
}

- (void)moveCloud:(int)number{
    cloudBody[number]->SetLinearVelocity(b2Vec2(0.0, 2.5f));
    if (cloudBody[number]->GetPosition().y*PTM_RATIO > 480 + cloudSprite[number].contentSize.height/2) {
        float nextPosY = rand()%320/PTM_RATIO;
        if (nextPosY < 40) {
            b2Vec2 moveFoewardPlayer(nextPosY + 40/PTM_RATIO, - cloudSprite[number].contentSize.height/2/PTM_RATIO);
            cloudBody[number]->SetTransform(moveFoewardPlayer, 0);
        }else if (nextPosY > 280){
            b2Vec2 moveFoewardPlayer(nextPosY - 40/PTM_RATIO, - cloudSprite[number].contentSize.height*2/PTM_RATIO);
            cloudBody[number]->SetTransform(moveFoewardPlayer, 0);
        }else {
            b2Vec2 moveFoewardPlayer(nextPosY, - cloudSprite[number].contentSize.height*2/PTM_RATIO);
            cloudBody[number]->SetTransform(moveFoewardPlayer, 0);
        }
    }
}

@end
