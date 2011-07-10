//
//  BJCloud.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/07/05.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BJCloud : NSObject {
    float currentX;
    float currentY;
    float nextX;
    float nextY;
    int width;
    int height;
    int imageNum;
    int interval;
    int count;
}
@property (assign) float currentPosX, currentPosY, nextPosX, nextPosY;
@property (assign) int width, height, imageNum, interval, count;
@end
