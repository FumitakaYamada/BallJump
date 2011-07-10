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
        if (cloud.imageNum == 1) {
            cloudSprite = [CCSprite spriteWithFile:@"cloud1.png"];
            [self addChild:cloudSprite z:1];
        }
        if (cloud.imageNum == 2) {
            cloudSprite = [CCSprite spriteWithFile:@"cloud2.png"];
            [self addChild:cloudSprite z:1];
        }
        if (cloud.imageNum == 3) {
            cloudSprite = [CCSprite spriteWithFile:@"cloud3.png"];
            [self addChild:cloudSprite z:1];
        }
        if (cloud.imageNum == 4) {
            cloudSprite = [CCSprite spriteWithFile:@"cloud4.png"];
            [self addChild:cloudSprite z:1];
        }
        
        cloud.width = cloudSprite.contentSize.width;
        cloud.height = cloudSprite.contentSize.height;
        cloud.currentPosX = 320/2;
        cloud.currentPosY = 0;
        
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
    
    CCSprite *obj;
    cloud = [BJCloud new];
    cloud.imageNum = rand()%4 + 1;
    if (cloud.imageNum == 1) {
        obj = [CCSprite spriteWithFile:@"cloud1.png"];
        [self addChild:obj z:1];
    }
 	if (cloud.imageNum == 2) {
        obj = [CCSprite spriteWithFile:@"cloud2.png"];
        [self addChild:obj z:1];
    }
    if (cloud.imageNum == 3) {
        obj = [CCSprite spriteWithFile:@"cloud3.png"];
        [self addChild:obj z:1];
    }
    if (cloud.imageNum == 4) {
        obj = [CCSprite spriteWithFile:@"cloud4.png"];
        [self addChild:obj z:1];
    }
    
    cloud.width = obj.contentSize.width;
    cloud.height = obj.contentSize.height;
    cloud.currentPosX = rand()%320;
    cloud.currentPosY = -obj.contentSize.height/2;
    
    b2BodyDef bodyDefBlock;
    bodyDefBlock.type = b2_dynamicBody;
    bodyDefBlock.userData = obj;
    bodyDefBlock.position.Set(cloud.currentPosX/PTM_RATIO, cloud.currentPosY/PTM_RATIO);
    cloudBody[count] = _world->CreateBody(&bodyDefBlock);
    b2PolygonShape shape;
    shape.SetAsBox((obj.contentSize.width/2 - 5)/PTM_RATIO, (obj.contentSize.height/2 - 15)/PTM_RATIO, b2Vec2(0, 0), 0.0f);
    
    cloudBody[count]->CreateFixture(&shape, 0.0f);
    
    cloud.currentPosY = cloudBody[count]->GetPosition().y * PTM_RATIO;
}
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

- (void)moveCloud:(ccTime) dt
{
//    NSLog(@"%f", cloudBody->GetLinearVelocity().y);
    for (int i = 0; i <= cloudCount; i++) {
        cloudBody[i]->SetLinearVelocity(b2Vec2(0.0, 5.0f));
//        NSLog(@"%d", i);
    }
//    NSLog(@"x:%f, y:%f", cloudBody[0]->GetPosition().x*PTM_RATIO, cloudBody[0]->GetPosition().y*PTM_RATIO);
    for (int i = 0; i <= cloudCount; i++) {
        if (cloudBody[i]->GetPosition().y*PTM_RATIO > 480) {
            b2Vec2 moveFoewardPlayer(rand()%320/PTM_RATIO, 0);
            cloudBody[i]->SetTransform(moveFoewardPlayer, 0);
            NSLog(@"x:%f, y:%f", cloudBody[i]->GetPosition().x, cloudBody[i]->GetPosition().y);
        }
    }
//    cloudBody->ApplyForce(b2Vec2(0.0f, 18.0f), cloudBody->GetPosition());
//    cloudBody->ApplyLinearImpulse(b2Vec2(0.0f, 3.0f), cloudBody->GetPosition());
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
//	int32 velocityIterations = 8;
//	int32 positionIterations = 1;
//	
//	// Instruct the world to perform a single step of simulation. It is
//	// generally best to keep the time step and iterations fixed.
//	world->Step(dt, velocityIterations, positionIterations);
//	//Iterate over the bodies in the physics world
//    //    [cloudLayer moveB2Object:world];
//    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
//	{
//        if (b->GetUserData() != NULL) {
//            CCSprite *myAct = (CCSprite*)b->GetUserData();
//			myAct.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
//			myAct.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
//        }
//    }
    if (cloud.interval % 40 == 39) {
        if (cloudCount < 6) {
            cloudCount++;
            [self addNewObject:cloudCount];
//            cloudBody[cloud.count]->SetLinearVelocity(b2Vec2(0.0, 5.0f));        
        }
        termNum++;
    }
    cloud.interval++;
//    NSLog(@"%d", cloud.interval);
    
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

//- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
//{	
//	static float prevX=0;
//	
//	//#define kFilterFactor 0.05f
//#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
//	
//	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
//	
//	prevX = accelX;
//	
//	// accelerometer values are in "Portrait" mode. Change them to Landscape left
//	// multiply the gravity by 10
//	b2Vec2 gravity( accelX * 10, -10.0f);
//	
//	world->SetGravity( gravity );
//}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete _world;
	_world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
