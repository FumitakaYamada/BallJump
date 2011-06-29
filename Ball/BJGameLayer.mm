//
//  BJGameLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJGameLayer.h"

#define PTM_RATIO 32

enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@interface BJGameLayer()
@property (nonatomic, retain) BJBlocks *block;
@end

@implementation BJGameLayer
@synthesize block;

+ (id)node{
    return [[[BJGameLayer alloc] init] autorelease];
}

- (id)init{
    self = [super init];
    
    if (self) {
        
        self.isAccelerometerEnabled = YES;
        block.interval = 0;
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
//        groundBox.SetAsEdge(b2Vec2(0,-screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO));
//        groundBody->CreateFixture(&groundBox,0);
//		
//        // top
//        groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2));
//        groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(0,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);
/*===================================================================================================*/		
        [self addNewBall];
        [self schedule: @selector(tick:)];        
    }
    return self;
}

-(void) addNewBall
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;

//    CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"Ball.png" capacity:0];
//    [self addChild:batch z:0 tag:kTagBatchNode];
//    
//	batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
//	
//    CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,30,30)];
//	[batch addChild:sprite];
    CCSprite *sprite = [CCSprite spriteWithFile:@"Ball.png"];
    [self addChild:sprite];
	
    int ballPosX = screenSize.width/2;
    int ballPosY = screenSize.height - sprite.contentSize.height/2;
	sprite.position = ccp(ballPosX, ballPosY);
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(ballPosX/PTM_RATIO, ballPosY/PTM_RATIO);
	bodyDef.userData = sprite;
	bodyBall = world->CreateBody(&bodyDef);
	NSLog(@"%@", bodyBall->GetUserData());
    b2CircleShape circle;
    circle.m_radius = 0.45f;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 0.5f;  // 鞫ｩ謫ｦ
    fixtureDef.friction = 0.3;  // 鞫ｩ謫ｦ
    fixtureDef.restitution = 0.3f;  // 霍ｳ縺ｭ霑斐ｊ
    bodyBall->CreateFixture(&fixtureDef);
    
}

-(void) addNewObject:(int)count Term:(int)term{
    
    CCSprite *obj;
    block = [BJBlocks new];
    block.imageNum = rand()%3 + 1;
    block.moveIntervalPosY = 1.0;
    if (block.imageNum == 1) {
        obj = [CCSprite spriteWithFile:@"Block1.png"];
        [self addChild:obj z:1];
    }
 	if (block.imageNum == 2) {
        obj = [CCSprite spriteWithFile:@"Block2.png"];
        [self addChild:obj z:1];
    }
    if (block.imageNum == 3) {
        obj = [CCSprite spriteWithFile:@"Block3.png"];
        [self addChild:obj z:1];
    }
    
    block.width = obj.contentSize.width;
    block.height = obj.contentSize.height;
    block.currentPosX = rand()%320;
    block.currentPosY = -480/6*count -480*term;
        
    b2BodyDef bodyDefBlock;
    bodyDefBlock.type = b2_staticBody;
    bodyDefBlock.userData = obj;
    bodyDefBlock.position.Set(block.currentPosX/PTM_RATIO, block.currentPosY/PTM_RATIO);
    b2Body *bodyBlock = world->CreateBody(&bodyDefBlock);
    b2PolygonShape shape;
    shape.SetAsBox(obj.contentSize.width/2/PTM_RATIO, obj.contentSize.height/2/PTM_RATIO, b2Vec2(0, 0), 0.0f);

    CCMoveBy *move = [CCMoveBy actionWithDuration:10 
                                                     position:ccp(0, 480)];
    [self runAction:[CCRepeatForever actionWithAction:move]];
    bodyBlock->CreateFixture(&shape, 0.0f);
    
    block.currentPosY = bodyBlock->GetPosition().y * PTM_RATIO;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
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
    block.nextPosY = block.currentPosY + block.moveIntervalPosY;
    block.currentPosY = block.nextPosY;
	//Iterate over the bodies in the physics world
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
        if (b->GetUserData() != NULL) {
            CCSprite *myAct = (CCSprite*)b->GetUserData();
			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myAct.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
/*
		if (b->GetUserData() != NULL && b->GetUserData() == bodyBall->GetUserData()){
			//Synchronize the AtlasSprites position and rotation with the corresponding body
            CCSprite *myAct = (CCSprite*)b->GetUserData();
			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
        }else {
            self.block.nextPosY = self.block.currentPosY + self.block.moveIntervalPosY;
			//Synchronize the AtlasSprites position and rotation with the corresponding body
            CCSprite *myAct = (CCSprite*)b->GetUserData();
			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, self.block.nextPosY);
			myAct.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            self.block.currentPosY = self.block.nextPosY;
            //            NSLog(@"obj:%d:%@", num, b->GetUserData());
        }
*/
	}
    
    if (block.interval % 600 == 0) {
        for (int i = 1; i < 7; i++) {
            [self addNewObject:i Term:termNum];
        }
        termNum++;
    }
    block.interval++;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	
	prevX = accelX;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( accelX * 10, -10.0f);
	
	world->SetGravity( gravity );
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
