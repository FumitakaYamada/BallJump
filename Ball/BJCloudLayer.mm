//
//  BJCloudLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJCloudLayer.h"
#import "BJCloud.h"
#import "BJBallLayer.h"
#import "BJGameOverLayer.h"


#define PTM_RATIO 32

enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@interface BJCloudLayer()
@property (nonatomic, retain) BJCloud *cloud;
@property (assign) BOOL flag;
@end

@implementation BJCloudLayer
@synthesize cloud;
@synthesize flag;

+ (id)layer:(b2World *)world{
    return [[[BJCloudLayer alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world{
    if ((self = [super init])) {
        srand(time(NULL));
        
        _world = world;
        
        cloud.count = 0;
        cloudCount = 0;
        
        CCSprite *cloudSprite;
        cloud = [BJCloud new];
        cloud.imageNum = rand()%3 + 1;
        for (int i = 1; i < 5; i++) {
            if (cloud.imageNum == i) {
                cloudSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cloud%d.png", i]];
                [self addChild:cloudSprite z:1];
            }
        }
        
        cloud.width = cloudSprite.contentSize.width;
        cloud.height = cloudSprite.contentSize.height;
        cloud.currentPosX = [CCDirector sharedDirector].winSize.width/2;
        cloud.currentPosY = -cloudSprite.contentSize.height/2;
        
        b2BodyDef cloudBodyDef;
        cloudBodyDef.type = b2_dynamicBody;
        cloudBodyDef.userData = cloudSprite;
        cloudBodyDef.position.Set(cloud.currentPosX/PTM_RATIO, cloud.currentPosY/PTM_RATIO);
        cloudBody[0] = _world->CreateBody(&cloudBodyDef);
        b2PolygonShape shape;
        shape.SetAsBox((cloudSprite.contentSize.width/2 - 5)/PTM_RATIO, (cloudSprite.contentSize.height/2 - 15)/PTM_RATIO, b2Vec2(0, 0), 0.0f);
        b2FixtureDef cloudFixtureDef;
        cloudFixtureDef.shape = &shape;
        
        cloudBody[0]->CreateFixture(&shape, 0.0f);

        [self schedule:@selector(moveCloud:)];

    }
    return self;
}

-(void) addNewObject:(int)count{
    
    srand(time(NULL));
    
    CCSprite *cloudSprite;
    cloud = [BJCloud new];
    cloud.imageNum = rand()%4 + 1;
    for (int i = 1; i < 5; i++) {
        if (cloud.imageNum == i) {
            cloudSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cloud%d.png", i]];
            [self addChild:cloudSprite z:1];
        }
    }
    
    cloud.width = cloudSprite.contentSize.width;
    cloud.height = cloudSprite.contentSize.height;
    cloud.currentPosX = rand()%320;
    cloud.currentPosY = -cloudSprite.contentSize.height/2;
    
    b2BodyDef cloudbBodyDef;
    cloudbBodyDef.type = b2_dynamicBody;
    cloudbBodyDef.userData = cloudSprite;
    cloudbBodyDef.position.Set(cloud.currentPosX/PTM_RATIO, cloud.currentPosY/PTM_RATIO);
    cloudBody[count] = _world->CreateBody(&cloudbBodyDef);
    b2PolygonShape shape;
    shape.SetAsBox((cloudSprite.contentSize.width/2 - 5)/PTM_RATIO, (cloudSprite.contentSize.height/2 - 15)/PTM_RATIO, b2Vec2(0, 0), 0.0f);
    
    cloudBody[count]->CreateFixture(&shape, 0.0f);
    
    cloud.currentPosY = cloudBody[count]->GetPosition().y * PTM_RATIO;
}

- (void)moveCloud:(ccTime) dt
{
    for (int i = 0; i <= cloudCount; i++) {
        [cloud moveWithHeight:cloudBody[i] h:cloud.height];
    }
    
    if (cloud.interval % 75 == 74) {
        if (cloudCount < 5) {
            cloudCount++;
            [self addNewObject:cloudCount];
        }
    }
    cloud.interval++;
}

- (void) dealloc
{
	delete _world;
	_world = NULL;
	    
	[super dealloc];
}

@end
