//
//  BJScoreLayer.h
//  Ball
//
//  Created by 深谷 哲史 on 11/07/20.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BJScoreLayer : CCLayer {
    
}
+ (id)layer;
- (void)rewriteScore:(int)score;
@end
