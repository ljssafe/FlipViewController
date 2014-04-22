//
//  iPadNavigationController.h
//  FlipViewControllerDemo
//
//  Created by Vincenzo Romano on 15/04/14.
//  Copyright (c) 2014 Vincenzo Romano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipViewController.h"

@interface iPadNavigationController : UINavigationController<FlipViewControllerDelegate>

- (id)init;

@end
