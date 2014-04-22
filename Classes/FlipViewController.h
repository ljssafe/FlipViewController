//
//  FlipViewController.h
//  FlipViewControllerDemo
//
//  Created by Vincenzo Romano on 08/04/14.
//  Copyright (c) 2014 Vincenzo Romano. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipViewController;

@protocol FlipViewControllerDelegate <NSObject>

@optional
- (void)flippedToNext:(FlipViewController *)fvc;
- (void)flippedToPrev:(FlipViewController *)fvc;

@end

typedef enum FlipOrientation : NSUInteger {
    FlipHorizontal,
    FlipVertical
} FlipOrientation;

typedef enum FlipDirection : NSUInteger {
    NotSetted,
    PrevPage,
    NextPage
} FlipDirection;

@interface FlipViewController : UIViewController


- (id)init;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

- (void)setPrevious:(FlipViewController *)fvc;
- (void)setNext:(FlipViewController *)fvc;
- (void)setOrientation:(FlipOrientation)orientation;

- (void)setDefaultImage:(UIImage *)image;
- (void)refreshCurrentSlices;

@property (nonatomic, retain, readonly) FlipViewController *prevController;
@property (nonatomic, retain, readonly) FlipViewController *nextController;
@property (nonatomic, readonly) FlipOrientation orientation;
@property (weak)id<FlipViewControllerDelegate> delegate;

@end
