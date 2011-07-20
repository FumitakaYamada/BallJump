//
//  BJItemLayer.h
//  Ball
//
//  Created by 深谷 哲史 on 11/07/11.
//  Copyright 2011 Keio University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol BJItemLayerDelegate <NSObject>
- (void)sendTotalScore:(int)score;
@end

@interface BJItemLayer : CCLayer {
    
    id <BJItemLayerDelegate> _delegate;
    
}
@property (nonatomic, retain) id <BJItemLayerDelegate> delegate;
+ (id)layer;
- (void)didHit:(CGRect)rect;
@end
