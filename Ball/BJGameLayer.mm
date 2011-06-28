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
@property (nonatomic,retain) BJBlocks *block;
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
        [self addNewSpriteWithCoords:ccp(160, 480 - 15)];
        [self schedule: @selector(tick:)];
        
    }
    return self;
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
    CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"Ball.png" capacity:0];
    [self addChild:batch z:0 tag:kTagBatchNode];
    
	batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
    CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,30,30)];
	[batch addChild:sprite];
	
	sprite.position = ccp(p.x, p.y);
	
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
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

-(void) addNewObject{
    
    CCSprite *obj;
    block = [BJBlocks new];
    self.block.imageNum = random()%3 + 1;
    self.block.interval = 0;
    self.block.moveIntervalPosY = 1.0;
    
    if (self.block.imageNum == 1) {
        obj = [CCSprite spriteWithFile:@"Block1.png"];
        [self addChild:obj z:1];
    }
 	if (self.block.imageNum == 2) {
        obj = [CCSprite spriteWithFile:@"Block2.png"];
        [self addChild:obj z:1];
    }
    if (self.block.imageNum == 3) {
        obj = [CCSprite spriteWithFile:@"Block3.png"];
        [self addChild:obj z:1];
    }
    
    self.block.width = obj.contentSize.width;
    self.block.height = obj.contentSize.height;
    self.block.currentPosX = (int)random()%320 + 50;
    self.block.currentPosY = -self.block.height/2;
        
    b2BodyDef bodyDefBlock;
    bodyDefBlock.type = b2_staticBody;
    bodyDefBlock.userData = obj;
    bodyDefBlock.position.Set(self.block.currentPosX/PTM_RATIO, self.block.currentPosY/PTM_RATIO);
    bodyBlock = world->CreateBody(&bodyDefBlock);
    b2PolygonShape shape;
    shape.SetAsBox(obj.contentSize.width/2/PTM_RATIO, obj.contentSize.height/2/PTM_RATIO, b2Vec2(0, 0), 0.0f);

    bodyBlock->CreateFixture(&shape, 0.0f);
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
	}
    
    if (self.block.interval % 120 == 0) {
        [self addNewObject];
    }
    self.block.interval++;
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
