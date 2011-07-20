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
@property (assign) int score;
@end

@implementation BJItemLayer
@synthesize delegate = _delegate;
@synthesize item, itemSprite, score;

+ (id)layer{
    return [[[BJItemLayer alloc] init] autorelease];
    
}

- (id)init{
    if ((self = [super init])) {
        srand(time(NULL));
        item = [BJItem new];
        item.interval = 0;
        score = 0;
        
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
    item.touchedFlag = NO;
    itemSprite.position = ccp(item.x, item.y);
    [self addChild:itemSprite];
}

- (void)timer:(ccTime)dt{
    if (item.touchedFlag == NO) {
        if (item.y > 480 + item.height/2) {
            item.touchedFlag = YES;
            [self removeChild:itemSprite cleanup:YES];
        }else {
            item.y = item.y + 1.2;
            itemSprite.position = ccp(item.x, item.y);
        }
    }
    item.interval++;
    if (item.interval % 480 == 0) {
        [self addNewItem];
    }
}

- (void)didHit:(CGRect)rect{
    if (item.touchedFlag == NO) {
        CGRect itemRect = CGRectMake(itemSprite.position.x - itemSprite.contentSize.width/2, itemSprite.position.y - itemSprite.contentSize.height, itemSprite.contentSize.width, itemSprite.contentSize.height);
        if(CGRectIntersectsRect(rect, itemRect)) {
            item.touchedFlag = YES;
            score = score + item.level;
            NSLog(@"score:%d", score);
            itemSprite.position = ccp(rand()%280 + 20, -itemSprite.position.y);
            [self removeChild:itemSprite cleanup:YES];
            if ([_delegate respondsToSelector:@selector(sendTotalScore:)]) {
                [_delegate sendTotalScore:score];
            }
        }
    }
}

@end
