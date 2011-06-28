//
//  BJBlocks.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/29.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BJBlocks : NSObject {
    float currentX;
    float currentY;
    float nextX;
    float nextY;
    int width;
    int height;
    int imageNum;
    float moveIntervalPosY;
    int interval;
}
@property (assign) float currentPosX, currentPosY, nextPosX, nextPosY, moveIntervalPosY;
@property (assign) int width, height, imageNum, interval;
@end
