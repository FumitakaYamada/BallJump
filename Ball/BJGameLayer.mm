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
@property (assign) BOOL flag;
@end

@implementation BJGameLayer
@synthesize ballLayer, cloudLayer;
@synthesize cloud;
@synthesize flag;

+ (id)node{
    return [[[BJGameLayer alloc] init] autorelease];
}

- (id)init{
    self = [super init];
    
    if (self) {

        cloud.interval = 0;
        termNum = 0;
        
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
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(0,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);
/*===================================================================================================*/		
        
        self.ballLayer = [BJBallLayer layer:world];
        [self addChild:ballLayer];
        
        self.cloudLayer = [BJCloudLayer layer:world];
        [self addChild:self.cloudLayer];
        
//        [self.cloudLayer addFirstCloud:world];
        
//        [self addFirstBlock];
        [self schedule: @selector(tick:)];  
    }
    return self;
}

//-(void) addFirstBlock{
//    CCSprite *obj;
//    cloud = [BJCloud new];
//    cloud.imageNum = rand()%3 + 1;
//    if (cloud.imageNum == 1) {
//        obj = [CCSprite spriteWithFile:@"cloud1.png"];
//        [self addChild:obj z:1];
//    }
// 	if (cloud.imageNum == 2) {
//        obj = [CCSprite spriteWithFile:@"cloud2.png"];
//        [self addChild:obj z:1];
//    }
//    if (cloud.imageNum == 3) {
//        obj = [CCSprite spriteWithFile:@"cloud3.png"];
//        [self addChild:obj z:1];
//    }
//    if (cloud.imageNum == 4) {
//        obj = [CCSprite spriteWithFile:@"cloud4.png"];
//        [self addChild:obj z:1];
//    }
//    
//    cloud.width = obj.contentSize.width;
//    cloud.height = obj.contentSize.height;
//    cloud.currentPosX = 320/2;
//    cloud.currentPosY = 0;
//    
//    b2BodyDef bodyDefBlock;
//    bodyDefBlock.type = b2_staticBody;
//    bodyDefBlock.userData = obj;
//    bodyDefBlock.position.Set(cloud.currentPosX/PTM_RATIO, cloud.currentPosY/PTM_RATIO);
//    bodyBlock = world->CreateBody(&bodyDefBlock);
//    b2PolygonShape shape;
//    shape.SetAsBox((obj.contentSize.width/2 - 5)/PTM_RATIO, (obj.contentSize.height/2 - 15)/PTM_RATIO, b2Vec2(0, 0), 0.0f);
//    
//    CCMoveBy *move = [CCMoveBy actionWithDuration:10 
//                                         position:ccp(0, 480)];
//    [self runAction:[CCRepeatForever actionWithAction:move]];
//    bodyBlock->CreateFixture(&shape, 0.0f);
//    
//    cloud.currentPosY = bodyBlock->GetPosition().y * PTM_RATIO;
//}
//
//-(void) addNewObject:(int)count Term:(int)term{
//    
//    CCSprite *obj;
//    cloud = [BJCloud new];
//    cloud.imageNum = rand()%4 + 1;
//    cloud.moveIntervalPosY = 1.0;
//    if (cloud.imageNum == 1) {
//        obj = [CCSprite spriteWithFile:@"cloud1.png"];
//        [self addChild:obj z:1];
//    }
// 	if (cloud.imageNum == 2) {
//        obj = [CCSprite spriteWithFile:@"cloud2.png"];
//        [self addChild:obj z:1];
//    }
//    if (cloud.imageNum == 3) {
//        obj = [CCSprite spriteWithFile:@"cloud3.png"];
//        [self addChild:obj z:1];
//    }
//    if (cloud.imageNum == 4) {
//        obj = [CCSprite spriteWithFile:@"cloud4.png"];
//        [self addChild:obj z:1];
//    }
//    
//    cloud.width = obj.contentSize.width;
//    cloud.height = obj.contentSize.height;
//    cloud.currentPosX = rand()%320;
//    cloud.currentPosY = -480/6*count -480*term;
//        
//    b2BodyDef bodyDefBlock;
//    bodyDefBlock.type = b2_staticBody;
//    bodyDefBlock.userData = obj;
//    bodyDefBlock.position.Set(cloud.currentPosX/PTM_RATIO, cloud.currentPosY/PTM_RATIO);
//    bodyBlock = world->CreateBody(&bodyDefBlock);
//    b2PolygonShape shape;
//    shape.SetAsBox((obj.contentSize.width/2 - 5)/PTM_RATIO, (obj.contentSize.height/2 - 15)/PTM_RATIO, b2Vec2(0, 0), 0.0f);
//
//    CCMoveBy *move = [CCMoveBy actionWithDuration:10 
//                                                     position:ccp(0, 480)];
//    [self runAction:[CCRepeatForever actionWithAction:move]];
//    bodyBlock->CreateFixture(&shape, 0.0f);
//    
//    cloud.currentPosY = bodyBlock->GetPosition().y * PTM_RATIO;
//}
//
//-(void) draw
//{
//	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	// Needed states:  GL_VERTEX_ARRAY, 
//	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_COLOR_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	
//	world->DrawDebugData();
//	
//	// restore default GL states
//	glEnable(GL_TEXTURE_2D);
//	glEnableClientState(GL_COLOR_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//}

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
//    [cloudLayer moveB2Object:world];
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
        if (b->GetUserData() != NULL) {
            CCSprite *myAct = (CCSprite*)b->GetUserData();
			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myAct.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
//    if (cloud.interval % 600 == 0) {
//        for (int i = 1; i < 7; i++) {
//            [self addNewObject:i Term:termNum];
//        }
//        termNum++;
//    }
//    cloud.interval++;
    
//    if (bodyBall->GetPosition().y*PTM_RATIO>(480-480.0/600*block.interval*termNum) || 
//        bodyBall->GetPosition().y*PTM_RATIO<(-30/2-480.0/600*block.interval*(termNum)    )) {
//        if (self.flag == NO) {
//            int score = 100;
//            NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", score] forKey:@"KEY"];
//            NSNotification *n = [NSNotification notificationWithName:@"GameOver" object:self userInfo:dic];
//            [[NSNotificationCenter defaultCenter] postNotification:n];
//            [self removeChild:self.sprite cleanup:YES];
//            self.flag = YES;
//        }
//    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
