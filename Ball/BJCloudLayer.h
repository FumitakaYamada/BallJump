//
//  BJCloudLayer.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


@interface BJCloudLayer : CCLayer {
    
    b2World* _world;
    GLESDebugDraw *m_debugDraw;
    
    b2Body *cloudBody[7];
    
    int cloudCount;
    
}
+ (id)layer:(b2World *)world;
- (id)initWithWorld:(b2World *)world;
- (void)addNewObject:(int)count;
@end
