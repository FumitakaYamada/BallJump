//
//  HelloWorldLayer.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/13.
//  Copyright Keio University 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    CCLayer *backgroundLayer;
    CCLayer *scrollLayer;
    CCLayer *ballLayer;
    
    float pos[16];
    
    CCSprite *background[2];
    CCSprite *obj;
    CCSprite *sprite;
    
    CCMoveBy* scrollBackground;
    CCMoveBy* scrollBackgroundReturn;
    
    b2Body *bodyBall;
    b2Body *bodyBlock;
    
    int randTag;
    int randX;
    int interval;
    float currentPosX;
    float currentPosY;
    float nextPosX;
    float nextPosY;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
-(void) addNewObject:(int)tag point:(CGPoint)p;

@end
