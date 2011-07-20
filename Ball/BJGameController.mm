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
#import "BJCloudLayer.h"
#import "BJGameOverLayer.h"


@interface BJGameController()
@property (nonatomic, retain) BJBallLayer *ballLayer;
@end

@implementation BJGameController
@synthesize mainScene;
@synthesize ballLayer;

+ (BJGameController *)controller {
    return [[[BJGameController alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        self.mainScene = [CCScene node];
        
        [self.mainScene addChild:[BJBackgroundLayer layer] z:BJLayerZBackground];
        [self.mainScene addChild:[BJGameLayer layer] z:BJLayerZMain];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(gameOverLayer:) name:@"GameOver" object:nil];

        [[CCDirector sharedDirector] runWithScene:self.mainScene];

    }
    return self;
}

- (void)gameOverLayer:(NSNotification *)n{
    NSString *value = [[n userInfo] objectForKey:@"KEY"];
    int score = [value intValue];
    [self.mainScene addChild:[BJGameOverLayer layer:score] z:BJLayerZGameOver];
}

@end
