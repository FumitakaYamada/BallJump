//
//  BJGameController.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJGameController.h"
#import "BJBackgroundLayer.h"
#import "BJGameLayer.h"

@implementation BJGameController
@synthesize mainScene;

- (id)init {
    self = [super init];
    if (self) {
        self.mainScene = [CCScene node];
        
        [self.mainScene addChild:[BJBackgroundLayer node] z:BJLayerZBackground];
        [self.mainScene addChild:[BJGameLayer node] z:BJLayerZMain];
        
        [[CCDirector sharedDirector] runWithScene:self.mainScene];
    }
    return self;
}

+ (BJGameController *)controller {
    return [[[BJGameController alloc] init] autorelease];
}

@end
