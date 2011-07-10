//
//  BJGameOverLayer.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/29.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BJGameOverLayer : CCLayer{

    int x;
    int y;
    CCLabelTTF *resultScoreNum;
}
@property int x, y;
@property (nonatomic, retain) CCLabelTTF *resultScoreNum;
+ (id)layer:(int)score;
- (id)initWithScore:(int)score;
@end