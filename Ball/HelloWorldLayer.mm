//
//  HelloWorldLayer.mm
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/13.
//  Copyright Keio University 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        for (int i = 0; i < 15; i++) {
            pos[15] = 0;
        }
        
        backgroundLayer = [CCLayer node];
        [self addChild:backgroundLayer z:1];
        
        scrollLayer = [CCLayer node];
        [self addChild:scrollLayer z:1];
        
        ballLayer = [CCLayer node];
        [scrollLayer addChild:ballLayer z:1];

        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
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
		
//		// bottom
//		groundBox.SetAsEdge(b2Vec2(0,-screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO));
//		groundBody->CreateFixture(&groundBox,0);
		
//		// top
//		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2));
//		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO*2), b2Vec2(0,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO*2), b2Vec2(screenSize.width/PTM_RATIO,-screenSize.height/PTM_RATIO*100));
		groundBody->CreateFixture(&groundBox,0);

/*===================================================================================================*/		
        
        [self addNewSpriteWithCoords:ccp(160, 480 - 15)];
        [self addNewObject:2 point:ccp(160        , - 70*1 - 10/2*1)];
        [self addNewObject:3 point:ccp(130/2      , - 70*2 - 10/2*3)];
        [self addNewObject:3 point:ccp(320 - 130/2, - 70*2 - 10/2*3)];
        [self addNewObject:2 point:ccp(250/2      , - 70*3 - 10/2*5)];
        [self addNewObject:3 point:ccp(130/2      , - 70*4 - 10/2*7)];
        [self addNewObject:3 point:ccp(320 - 130/2, - 70*4 - 10/2*7)];
        [self addNewObject:2 point:ccp(320 - 250/2, - 70*5 - 10/2*9)];
        
        [self addNewObject:1 point:ccp(160        , - 480 - 70*0 - 10/2*1)];
        [self addNewObject:2 point:ccp(160        , - 480 - 70*1 - 10/2*1)];
        [self addNewObject:3 point:ccp(130/2      , - 480 - 70*2 - 10/2*3)];
        [self addNewObject:3 point:ccp(320 - 130/2, - 480 - 70*2 - 10/2*3)];
        [self addNewObject:2 point:ccp(250/2      , - 480 - 70*3 - 10/2*5)];
        [self addNewObject:3 point:ccp(130/2      , -480 - 70*4 - 10/2*7)];
        [self addNewObject:3 point:ccp(320 - 130/2, - 480 - 70*4 - 10/2*7)];
        [self addNewObject:2 point:ccp(320 - 250/2, - 480 - 70*5 - 10/2*9)];

		[self schedule: @selector(tick:)];
        
        background[0] = [CCSprite spriteWithFile:@"Background.png"];
        background[1] = [CCSprite spriteWithFile:@"Background.png"];
        background[0].position = ccp(screenSize.width/2, screenSize.height/2);
        background[1].position = ccp(screenSize.width/2, -screenSize.height/2);
        [backgroundLayer addChild:background[0] z:0];
        [backgroundLayer addChild:background[1] z:0];

        scrollBackground = [CCMoveBy actionWithDuration:30 
                                     position:ccp(0, 480*1)];
        scrollBackgroundReturn = [CCMoveBy actionWithDuration:30 
                                     position:ccp(0, -480*1)];
        [backgroundLayer runAction:[CCRepeatForever actionWithAction:[CCSequence actions:scrollBackground, scrollBackgroundReturn, nil]]];
    }
	return self;
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

-(void) addNewSpriteWithCoords:(CGPoint)p
{
    CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"Ball.png" capacity:0];
    [ballLayer addChild:batch z:0 tag:kTagBatchNode];
    
	batch = (CCSpriteBatchNode*) [ballLayer getChildByTag:kTagBatchNode];
	
    sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,30,30)];
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
    fixtureDef.density = 0.5f;  // 摩擦
    fixtureDef.friction = 0.3;  // 摩擦
    fixtureDef.restitution = 0.3f;  // 跳ね返り
    bodyBall->CreateFixture(&fixtureDef);
    
}

-(void) addNewObject:(int)tag point:(CGPoint)p
{
    float block_center_x = p.x/PTM_RATIO;
    float block_center_y = p.y/PTM_RATIO;
    
//    CCSprite *obj;
    if (tag == 1) {
        obj = [CCSprite spriteWithFile:@"Block1.png"];
        [scrollLayer addChild:obj z:1];
    }
 	if (tag == 2) {
        obj = [CCSprite spriteWithFile:@"Block2.png"];
        [scrollLayer addChild:obj z:1];
    }
    if (tag == 3) {
        obj = [CCSprite spriteWithFile:@"Block3.png"];
        [scrollLayer addChild:obj z:1];
    }

    b2BodyDef bodyDefBlock;
    bodyDefBlock.type = b2_kinematicBody;
    bodyDefBlock.userData = obj;
    bodyDefBlock.position.Set(block_center_x, block_center_y);
    bodyBlock = world->CreateBody(&bodyDefBlock);
    b2PolygonShape shape;
    shape.SetAsBox(obj.contentSize.width/2/PTM_RATIO, obj.contentSize.height/2/PTM_RATIO, b2Vec2(0, 0), 0.0f);
    
//    b2Body *bodyBlock;
//    bodyDefBlock[num].type = b2_kinematicBody;
//    bodyDefBlock[num].userData = obj;
//    bodyDefBlock[num].position.Set(block_center_x, block_center_y);
//    bodyBlock = world->CreateBody(&bodyDefBlock[num]);
//    b2PolygonShape shape;
//    shape.SetAsBox(obj.contentSize.width/2/PTM_RATIO, obj.contentSize.height/2/PTM_RATIO, b2Vec2(0, 0), 0.0f);
    
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
    
    int num = 0;
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
            currentPosX = b->GetPosition().x * PTM_RATIO;
            currentPosY = b->GetPosition().y * PTM_RATIO;
            nextPosX = currentPosX;
            nextPosY = currentPosY + pos[num];
            
			//Synchronize the AtlasSprites position and rotation with the corresponding body
            if (nextPosY < 480) {
                pos[num] = pos[num] + 0.8;
            }else {
                pos[num] = -480;
            }
            obj = (CCSprite*)b->GetUserData();
			obj.position = CGPointMake(nextPosX, nextPosY);
			obj.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            num++;
		}
	}
    
//    interval++;
//    if (interval % 480 == 0) {
//        interval = 0;
//        randTag = rand()%3 + 1;
//        randX = rand()%300;
//        [self addNewObject:randTag point:ccp(randX, -50)];
//    }
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
