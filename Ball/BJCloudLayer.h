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
#import "BJCloud.h"


@interface BJCloudLayer : CCLayer {
    
    b2World* _world;
    BJCloud *cloud[CLOUD_NUM];
    
}
+ (id)layer:(b2World *)world;
- (id)initWithWorld:(b2World *)world;
@end
