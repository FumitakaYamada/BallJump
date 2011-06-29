//
//  BJGameLayer.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "BJBlocks.h"


@interface BJGameLayer : CCLayer{

    b2World* world;
    GLESDebugDraw *m_debugDraw;
    b2Body *bodyBall;
    
    int termNum;

}
+ (id)node;
-(void) addNewBall;
-(void) addFirstBlock;
-(void) addNewObject:(int)count Term:(int)term;
@end
