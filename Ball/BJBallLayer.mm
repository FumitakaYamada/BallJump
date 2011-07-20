//
//  BJBallLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJBallLayer.h"

#define PTM_RATIO 32


@interface BJBallLayer()
@property (nonatomic, retain) CCSprite *player;
@property (assign) CGRect ballRect;
@end

@implementation BJBallLayer
@synthesize delegate = _delegate;
@synthesize player, ballRect;

+ (id)layer:(b2World *)world{
    return [[[BJBallLayer alloc] initWithWorld:world] autorelease];
}

- (id)initWithWorld:(b2World *)world{
    if ((self = [super init])) {
        
        self.isAccelerometerEnabled = YES;

        _world = world;
    
        CGSize screenSize = [CCDirector sharedDirector].winSize;

        player = [CCSprite spriteWithFile:@"object1.png"];
        [self addChild:player];
        
        int ballPosX = screenSize.width/2;
        int ballPosY = screenSize.height - player.contentSize.height/2;
        player.position = ccp(ballPosX, ballPosY);
        
        b2BodyDef playerBodyDef;
        playerBodyDef.type = b2_dynamicBody;
        playerBodyDef.position.Set(ballPosX/PTM_RATIO, ballPosY/PTM_RATIO);
        playerBodyDef.userData = player;
        ballBody = _world->CreateBody(&playerBodyDef);
        NSLog(@"%@", ballBody->GetUserData());
        b2CircleShape circle;
        circle.m_radius = 0.45f;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;
        fixtureDef.density = 0.5f;  // 鞫ｩ謫ｦ
        fixtureDef.friction = 0.3;  // 鞫ｩ謫ｦ
        fixtureDef.restitution = 0.8f;  // 霍ｳ縺ｭ霑斐ｊ
        ballBody->CreateFixture(&fixtureDef);
        
        [self schedule:@selector(checkBallRect:)];

        _world = NULL;
    }
    return self;
}



- (void)checkBallRect:(ccTime)dt{
    ballRect = CGRectMake(ballBody->GetPosition().x*PTM_RATIO - player.contentSize.width/2, ballBody->GetPosition().y*PTM_RATIO - player.contentSize.height, player.contentSize.width, player.contentSize.height);
    if ([_delegate respondsToSelector:@selector(sendBallRect:)]) {
        [_delegate sendBallRect:ballRect];
    }
    float playerPosY = ballBody->GetPosition().y*PTM_RATIO;
    if (playerPosY > 480 + player.contentSize.width/2 || playerPosY < 0 - player.contentSize.width/2) {
        if ([_delegate respondsToSelector:@selector(gameOver)]) {
            [_delegate gameOver];
        }
    }
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
//	b2Vec2 gravity( accelX * 10, 0.0f);
    ballBody->ApplyForce(b2Vec2(accelX * 20, -10.0f), ballBody->GetPosition());

//	_world->SetGravity( gravity );
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete _world;
	_world = NULL;

	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
