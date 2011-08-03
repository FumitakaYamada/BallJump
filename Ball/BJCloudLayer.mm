//
//  BJCloudLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJCloudLayer.h"
#import "BJBallLayer.h"
#import "BJGameOverLayer.h"


#define PTM_RATIO 32

enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@implementation BJCloudLayer

+ (id)layer:(b2World *)world{
    return [[[BJCloudLayer alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world{
    if ((self = [super init])) {
        srand(time(NULL));
        
        _world = world;
        
        cloud[0] = [BJCloud new];
        [cloud[0] addNewCloud:self world:_world number:0];
        cloud[0].exist = YES;

        [self schedule:@selector(timer:)];

    }
    return self;
}

- (void)timer:(ccTime) dt
{
    for (int i = 0; i < CLOUD_NUM; i++) {
        if (cloud[i].exist == YES) {
            [cloud[i] moveCloud:i];
            cloud[i].interval++;
            if (cloud[i].interval%60 == 0) {
                if (i < CLOUD_NUM - 1) {
                    if (cloud[i+1].exist == NO) {
                        cloud[i+1] = [BJCloud new];
                        [cloud[i+1] addNewCloud:self world:_world number:(i+1)];
                        cloud[i+1].exist = YES;
                    }
                }
            }
        }
    }
}

- (void) dealloc
{
	delete _world;
	_world = NULL;
	    
	[super dealloc];
}

@end
