//
//  BJBackgroundLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/28.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJBackgroundLayer.h"

@interface BJBackgroundLayer()
@property (nonatomic, retain) CCSprite *background1;
@property (nonatomic, retain) CCSprite *background2;
@end

@implementation BJBackgroundLayer
@synthesize background1;
@synthesize background2;

- (id)init {
    self = [super init];
    if (self) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        self.background1 = [CCSprite spriteWithFile:@"Background.png"];
        self.background2 = [CCSprite spriteWithFile:@"Background.png"];
        self.background1.position = ccp(screenSize.width/2, screenSize.height/2);
        self.background2.position = ccp(screenSize.width/2, -screenSize.height/2);
        [self addChild:self.background1 z:0];
        [self addChild:self.background2 z:0];
        
        CCMoveBy *scrollBackground = [CCMoveBy actionWithDuration:30 
                                                         position:ccp(0, 480*1)];
        CCMoveBy *scrollBackgroundReturn = [CCMoveBy actionWithDuration:0 
                                                               position:ccp(0, -480*1)];
        [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:scrollBackground, scrollBackgroundReturn, nil]]];
    }
    return self;
}

+ (id)node {
    return [[[BJBackgroundLayer alloc] init] autorelease];
}
@end
