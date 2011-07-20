//
//  BJGameLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJGameLayer.h"
#import "BJBallLayer.h"
#import "BJCloudLayer.h"
#import "BJItemLayer.h"
#import "BJScoreLayer.h"
#import "BJGameOverLayer.h"
#import "BJCloud.h"


#define PTM_RATIO 32

enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@interface BJGameLayer()
@property (nonatomic, retain) BJBallLayer *ballLayer;
@property (nonatomic, retain) BJCloudLayer *cloudLayer;
@property (nonatomic, retain) BJCloud *cloud;
@property (nonatomic, retain) BJItemLayer *itemLayer;
@property (nonatomic, retain) BJScoreLayer *scoreLayer;
@property (assign) int totalScore;
@property (assign) BOOL flag;
@end

@implementation BJGameLayer
@synthesize ballLayer, cloudLayer, itemLayer, scoreLayer;
@synthesize cloud;
@synthesize totalScore, flag;

+ (id)layer{
    return [[[BJGameLayer alloc] init] autorelease];
}

- (id)init{
    self = [super init];
    
    if (self) {

        cloud.interval = 0;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;

        // Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		bool doSleep = false;
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
        //		flags += b2DebugDraw::e_jointBit;
        //		flags += b2DebugDraw::e_aabbBit;
        //		flags += b2DebugDraw::e_pairBit;
        //		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
/*===================================================================================================*/		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
//        // bottom
//        groundBox.SetAsEdge(b2Vec2(0, 0), b2Vec2(screenSize.width/PTM_RATIO, 0));
//        groundBody->CreateFixture(&groundBox,0);
//		
//        // top
//        groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
//        groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(0,-screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
/*===================================================================================================*/		
        
        self.ballLayer = [BJBallLayer layer:world];
        [self addChild:ballLayer z:BJLayerZPlayer];
        
        ballLayer.delegate = self;
        
        self.cloudLayer = [BJCloudLayer layer:world];
        [self addChild:self.cloudLayer z:BJLayerZCloud];
        
        self.itemLayer = [BJItemLayer layer];
        [self addChild:self.itemLayer z:BJLayerZItem];
        
        itemLayer.delegate = self;
        
        self.scoreLayer = [BJScoreLayer layer];
        [self addChild:self.scoreLayer z:BJLayerZScore];
        
        [self schedule: @selector(tick:)];
    }
    return self;
}

-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	//Iterate over the bodies in the physics world
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
        if (b->GetUserData() != NULL) {
            CCSprite *myAct = (CCSprite*)b->GetUserData();
			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myAct.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
}

- (void)sendBallRect:(CGRect)rect{
    [itemLayer didHit:rect];
}

- (void)sendTotalScore:(int)score{
    totalScore = score;
    [scoreLayer rewriteScore:score];
}

- (void)gameOver{
    [self removeChild:ballLayer cleanup:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", totalScore] forKey:@"KEY"];
    NSNotification *n = [NSNotification notificationWithName:@"GameOver" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	[super dealloc];
}

@end
