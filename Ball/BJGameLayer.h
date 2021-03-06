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
#import "BJBallLayer.h"
#import "BJItemLayer.h"


typedef enum _BJGameLayerZ {
    BJLayerZItem    = 0x0001 << 0,
    BJLayerZPlayer  = 0x0001 << 1,
    BJLayerZCloud   = 0x0001 << 2,
    BJLayerZScore   = 0x0001 << 3
} BJGameLayerZ;

@interface BJGameLayer : CCLayer <BJBallLayerDelegate, BJItemLayerDelegate> {

    b2World* world;
    GLESDebugDraw *m_debugDraw;
    
    b2Body *bodyBlock;
    
}
+ (id)layer;
@end
