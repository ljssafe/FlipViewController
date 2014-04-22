//
//  AppDelegate.h
//  FlipViewControllerDemo
//
//  Created by PHI dev on 22/04/14.
//  Copyright (c) 2014 Razorfish Healthware. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum DeviceType : NSUInteger {
    DEVICE_TYPE_IPAD,
    DEVICE_TYPE_IPHONE4,
    DEVICE_TYPE_IPHONE5,
} DeviceType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
