//
//  BJItem.h
//  Ball
//
//  Created by 深谷 哲史 on 11/07/11.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJItem : NSObject{

    float x;
    float y;
    float width;
    float height;
    int interval;
    
    int level;
    
    BOOL touchedFlag;
    
}
@property (assign) float x, y, width, height;
@property (assign) int interval, level;
@property (assign) BOOL touchedFlag;
@end
