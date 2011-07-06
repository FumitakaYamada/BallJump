//
//  BJBallLayer.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface BJBallLayer : CCLayer {
    
    b2World *_world;
    
}
+ (id)layer:(b2World *)world;
- (id)initWithWorld:(b2World *)world;
- (void)checkGameOver;
@end
