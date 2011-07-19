//
//  BJItem.h
//  Ball
//
//  Created by 深谷 哲史 on 11/07/11.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BJItem : NSObject{

    int x;
    int y;
    int width;
    int height;
    int interval;
    
    int level;
    
}
@property (assign) int x, y, width, height, interval, level;
@end
