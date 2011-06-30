//
//  BJGameOverLayer.m
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/29.
//  Copyright 2011 Keio University. All rights reserved.
//

#import "BJGameOverLayer.h"

@interface BJGameOverLayer()
@property (nonatomic, retain) CCLabelTTF *resultScoreLabel;
//@property (nonatomic, retain) CCLabelTTF *resultScoreNum;
@end


@implementation BJGameOverLayer
@synthesize resultScoreLabel, resultScoreNum, x, y;

+ (id)node {
    return [[[BJGameOverLayer alloc] init] autorelease];
}

- (id)init {
    self = [super init];
    if (self) {
        self.resultScoreLabel = [CCLabelTTF labelWithString:@"Score:" fontName:@"Arial" fontSize:32];
        self.resultScoreLabel.color = ccc3(255, 0, 0);
        [self addChild:self.resultScoreLabel z:1];
        [self.resultScoreLabel setPosition: ccp(200, 110)];
        
        self.resultScoreNum = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:32];
        self.resultScoreNum.color = ccc3(255, 0, 0);
        [self.resultScoreNum setPosition: ccp(280, 110)];
        [self addChild:self.resultScoreNum z:1];
        
        [self unscheduleAllSelectors];
    }
    return self;
}

- (void)getScore:(NSNotification *)nortification{
    NSString *score = [[nortification userInfo] objectForKey:@"KEY"];
    NSLog(@"%@", score);
    [self.resultScoreNum setString:[NSString stringWithFormat:@"%@", score]];
}

@end
