//
//  BJItemLayer.m
//  Ball
//
//  Created by 深谷 哲史 on 11/07/11.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJItemLayer.h"
#import "BJItem.h"


@interface BJItemLayer()
@property (nonatomic, retain) BJItem *item;
@property (nonatomic, retain) CCSprite *itemSprite;
@end

@implementation BJItemLayer
@synthesize item, itemSprite;

+ (id)layer{
    return [[[BJItemLayer alloc] init] autorelease];
    
}

- (id)init{
    if ((self = [super init])) {
        srand(time(NULL));
        item = [BJItem new];
        item.interval = 0;
        
        [self schedule:@selector(timer:)];
    }
    return self;
}

- (void)addNewItem{
    itemSprite = [CCSprite spriteWithFile:@"coin.png"];
    item.width = itemSprite.contentSize.width;
    item.height = itemSprite.contentSize.height;
    item.x = rand()%280 + 20;
    item.y = -item.height/2;
    item.level = 1;
    itemSprite.position = ccp(item.x, item.y);
    id move = [CCMoveTo actionWithDuration:7 position:ccp(item.x, 480 + item.height/2)];
    [itemSprite runAction:move];
    [self addChild:itemSprite];
}

- (void)timer:(ccTime)dt{
    item.interval++;
    if (item.interval % 400 == 0) {
        [self addNewItem];
    }
}

@end
