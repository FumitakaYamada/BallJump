//
//  AppDelegate.h
//  Ball
//
//  Created by Akifumi Fukaya on 11/06/13.
//  Copyright Keio University 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
