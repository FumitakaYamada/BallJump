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
#import "BJGameOverLayer.h"

@implementation BJGameController
@synthesize mainScene;

+ (BJGameController *)controller {
    return [[[BJGameController alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        self.mainScene = [CCScene node];
        
        [self.mainScene addChild:[BJBackgroundLayer node] z:BJLayerZBackground];
        [self.mainScene addChild:[BJGameLayer node] z:BJLayerZMain];
        
        BJGameOverLayer *gameScore = [BJGameOverLayer new];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(gameOverLayer) name:@"GameOver" object:nil];
        [nc addObserver:gameScore selector:@selector(getScore:) name:@"GameOver" object:nil];

        [[CCDirector sharedDirector] runWithScene:self.mainScene];
    }
    return self;
}

- (void)gameOverLayer{
    [self.mainScene addChild:[BJGameOverLayer node] z:BJLayerZMain];
}

@end
