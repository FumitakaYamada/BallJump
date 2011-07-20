//
//  BJScoreLayer.m
//  Ball
//
//  Created by 深谷 哲史 on 11/07/20.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJScoreLayer.h"


@interface BJScoreLayer()
@property (nonatomic, retain) CCLabelTTF *scoreNum;
@end

@implementation BJScoreLayer
@synthesize scoreNum;

+ (id)layer{
    return [[[BJScoreLayer alloc] init] autorelease];
}

- (id)init{
    if ((self = [super init])) {
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score:" fontName:@"Arial" fontSize:24];
		[self addChild: scoreLabel z:1];
		[scoreLabel setPosition:ccp(250, 450)];
        
        scoreNum = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:24];
		[self addChild: scoreNum z:1];
		[scoreNum setPosition:ccp(300, 450)];
    }
    return self;
}

- (void)rewriteScore:(int)score{
    [scoreNum setString:[NSMutableString stringWithFormat:@"%d", score]];
}

@end
