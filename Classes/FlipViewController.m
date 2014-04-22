//
//  FlipViewController.m
//  FlipViewControllerDemo
//
//  Created by Vincenzo Romano on 08/04/14.
//  Copyright (c) 2014 Vincenzo Romano. All rights reserved.
//

#import "FlipViewController.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define FLIP_OFFSET 300

@interface FlipViewController (){
    UIImageView *sliceA, *sliceB, *prev, *next;
    UIView *shadowA, *shadowB;
    NSArray *prevSlices, *nextSlices, *currentSlices;
    NSArray *prevFlippedSlices, *nextFlippedSlices, *currentFlippedSlices;
    CGPoint startPoint;
    BOOL moved;
    FlipDirection direction;
    UIImage *defaultImage;
    CAGradientLayer *gradientLayer;
    BOOL isNextMove;
    BOOL completeNext;
    BOOL completePrev;
}

@end

@implementation FlipViewController

static int MIN_OFFSET = 10;

#pragma mark initMethods

- (id)init
{
    _orientation = FlipHorizontal;
    return [super init];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    _orientation = FlipHorizontal;
    return [super initWithCoder:aDecoder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    _orientation = FlipHorizontal;
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)setPrevious:(FlipViewController *)fvc{
    _prevController = fvc;
}

- (void)setNext:(FlipViewController *)fvc{
    _nextController = fvc;
}

- (void)setOrientation:(FlipOrientation)orientation{
    _orientation = orientation;
}

- (void)setDefaultImage:(UIImage *)image{
    defaultImage = image;
}

#pragma mark viewControllerMethods

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    prevSlices = [self getSlicesFrom:_prevController flipped:NO];
    prevFlippedSlices = [self getInvertedSlicesFrom:_prevController flipped:YES];
  
    nextSlices = [self getSlicesFrom:_nextController flipped:NO];
    nextFlippedSlices = [self getInvertedSlicesFrom:_nextController flipped:YES];
 
    currentSlices = [self getSlicesFrom:self flipped:NO];
    currentFlippedSlices = [self getInvertedSlicesFrom:self flipped:YES];
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark FlipTriggers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(moved)return;
    completeNext = completePrev = NO;
    if((!_prevController || !_nextController) && !defaultImage){
        NSLog(@"you have to set a dafault image");
        return;
    }
    direction = NotSetted;
    startPoint = [[[event allTouches] anyObject] locationInView:self.view];

    if(prevSlices){
        prev = [[UIImageView alloc] initWithImage:[prevSlices objectAtIndex:0]];
        prev.frame = [self getRectForSlice:0];
    }
    
    if(nextSlices){
        next = [[UIImageView alloc] initWithImage:[nextSlices objectAtIndex:1]];
        next.frame = [self getRectForSlice:1];
    }
    
    sliceA = [[UIImageView alloc] initWithImage:[currentSlices objectAtIndex:0]];
    sliceA.frame = [self getRectForSlice:0];
    sliceB = [[UIImageView alloc] initWithImage:[currentSlices objectAtIndex:1]];
    sliceB.frame = [self getRectForSlice:1];
    
    if(prev){
        [self.view addSubview:prev];
    }else{
        prev = [[UIImageView alloc] initWithImage:defaultImage];
        prev.frame = [self getRectForSlice:0];
        prevSlices = [[NSArray alloc] initWithObjects:defaultImage, defaultImage, nil];
        [self.view addSubview:prev];
    }
    
    if(next){
        [self.view addSubview:next];
    }else{
        
        next = [[UIImageView alloc] initWithImage:defaultImage];
        next.frame = [self getRectForSlice:1];
        nextSlices = [[NSArray alloc] initWithObjects:defaultImage, defaultImage, nil];
        [self.view addSubview:next];
    }
    
    [self.view addSubview:sliceA];
    [self.view addSubview:sliceB];

    if(!shadowA)shadowA = [[UIView alloc] initWithFrame:[self getRectForSlice:0]];
    if(!shadowB)shadowB = [[UIView alloc] initWithFrame:[self getRectForSlice:1]];
    shadowA.backgroundColor = shadowB.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if((!_prevController || !_nextController) && !defaultImage){
        NSLog(@"you have to set a dafault image");
        return;
    }
    CGPoint currentPoint = [[[event allTouches] anyObject] locationInView:self.view];
    
    float dX = currentPoint.x - startPoint.x;
    float dY = currentPoint.y - startPoint.y;
    
    switch (_orientation) {
        case FlipHorizontal:
            if(fabs(dX) > MIN_OFFSET){
                if(dX>0){
                    if(!moved){
                        direction = PrevPage;
                        shadowA.alpha = 1.0f;
                        shadowB.alpha = 0.0f;
                        [self setFlipGradient:sliceA toLeft:NO];
                        
                        [self.view insertSubview:shadowA belowSubview:sliceA];
                        [self.view insertSubview:shadowB aboveSubview:sliceB];
                    }
                    if(direction==PrevPage){
                        [self moveToFlipPrev:dX];
                    }
                }
                else if(dX<0){
                    if(!moved){
                        direction = NextPage;
                        shadowA.alpha = 0.0f;
                        shadowB.alpha = 1.0f;
                        [self setFlipGradient:sliceB toLeft:YES];
                    
                        [self.view insertSubview:shadowA aboveSubview:sliceA];
                        [self.view insertSubview:shadowB belowSubview:sliceB];
                    }
                    if(direction==NextPage){
                        [self moveToFlipNext:dX];
                    }
                }
                moved = YES;
            }
            break;
            
        case FlipVertical:
            if(fabs(dY) > MIN_OFFSET){
                if(dY>0){
                    if(!moved){
                        direction = PrevPage;
                        shadowA.alpha = 1.0f;
                        shadowB.alpha = 0.0f;
                        [self setFlipGradient:sliceA toLeft:NO];
                        
                        [self.view insertSubview:shadowA belowSubview:sliceA];
                        [self.view insertSubview:shadowB aboveSubview:sliceB];
                    }
                    if(direction==PrevPage){
                        [self moveToFlipPrev:dY];
                    }
                }
                else if(dY<0){
                    if(!moved){
                        direction = NextPage;
                        shadowA.alpha = 0.0f;
                        shadowB.alpha = 1.0f;
                        [self setFlipGradient:sliceB toLeft:YES];
                        
                        [self.view insertSubview:shadowA aboveSubview:sliceA];
                        [self.view insertSubview:shadowB belowSubview:sliceB];
                    }
                    if(direction==NextPage){
                        [self moveToFlipNext:dY];
                    }
                }
                
                moved = YES;
            }
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.view setUserInteractionEnabled:NO];
    if((!_prevController || !_nextController) && !defaultImage){
        NSLog(@"you have to set a dafault image");
        return;
    }
    
    if(moved){
        switch (_orientation) {
            case FlipHorizontal:
                if(isNextMove){
                    if(completeNext){
                        [self snapToNext];
                    }else{
                        [self snapToPrev];
                    }
                }else{
                    if(completePrev){
                        [self snapToPrev];
                    }else{
                        [self snapToNext];
                    }
                }
                break;
            
            case FlipVertical:
                if(isNextMove){
                    if(completeNext){
                        [self snapToNext];
                    }else{
                        [self snapToPrev];
                    }
                }else{
                    if(completePrev){
                        [self snapToPrev];
                    }else{
                        [self snapToNext];
                    }
                }
                break;
        }
    }else{
        [self completeAnimation];
        [self.view setUserInteractionEnabled:YES];
    }
    
    moved = NO;
}

- (void)moveToFlipPrev:(float)d{
    isNextMove = NO;
    
    if(_orientation == FlipHorizontal){
        sliceA.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        sliceA.layer.position = CGPointMake(self.view.bounds.size.width/2, sliceB.layer.position.y);
    }else{
        sliceA.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
        sliceA.layer.position = CGPointMake(sliceB.layer.position.x, self.view.bounds.size.height/2);
    }
    
    CATransform3D t = CATransform3DIdentity;
    
    float deg = degreesToRadians((d*180.0f)/FLIP_OFFSET);
    if(fabs(deg) >= 0 && fabs(deg) < M_PI){
        
        if(!_prevController && fabs(deg) >= M_PI/4){
            completePrev = NO;
            return;
        }
        
        if(fabs(deg) > M_PI/2){
            shadowA.alpha = 0.0;
            shadowB.alpha = 1.0 - (float)((M_PI - fabs(deg)) / (M_PI/2));
            gradientLayer.opacity = (float)((M_PI - fabs(deg)) / (M_PI/2));
            [sliceA setImage:[prevFlippedSlices objectAtIndex:1]];
            completePrev = YES;
        }else{
            shadowA.alpha = 1.0 - (float)(fabs(deg)/(M_PI/2));
            gradientLayer.opacity = (float)(fabs(deg)/(M_PI/2));
            shadowB.alpha = 0.0;
            [sliceA setImage:[currentSlices objectAtIndex:0]];
            completePrev = NO;
        }
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, deg, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, -deg, 1, 0, 0);
        }
        sliceA.layer.transform = t;
    }
}

- (void)moveToFlipNext:(float)d{
    isNextMove = YES;
    
    if(_orientation == FlipHorizontal){
        sliceB.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
        sliceB.layer.position = CGPointMake(self.view.bounds.size.width/2, sliceB.layer.position.y);
    }else{
        sliceB.layer.anchorPoint = CGPointMake(0.5f, 0.0f);
        sliceB.layer.position = CGPointMake(sliceB.layer.position.x, self.view.bounds.size.height/2);
    }
    
    CATransform3D t = CATransform3DIdentity;
    
    float deg = degreesToRadians((d*180.0f)/FLIP_OFFSET);
    if(fabs(deg) >= 0 && fabs(deg) < M_PI){
        
        
        if(!_nextController && fabs(deg) > M_PI/4){
            completeNext = NO;
            return;
        }
        
        if(fabs(deg) > M_PI/2){
            shadowA.alpha = 1.0 - (float)((M_PI-fabs(deg)) / (M_PI/2));
            gradientLayer.opacity = (float)((M_PI-fabs(deg)) / (M_PI/2));
            shadowB.alpha = 0.0;
            [sliceB setImage:[nextFlippedSlices objectAtIndex:0]];
            completeNext = YES;
        }else{
            shadowA.alpha = 0.0;
            shadowB.alpha = 1.0 - (float)(fabs(deg)/(M_PI/2));
            gradientLayer.opacity = (float)(fabs(deg)/(M_PI/2));
            [sliceB setImage:[currentSlices objectAtIndex:1]];
            completeNext = NO;
        }
        
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, deg, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, -deg, 1, 0, 0);
        }
        
        sliceB.layer.transform = t;
    }
}

- (void)snapToPrev{
    float duration = 0.2f;
    
    CATransform3D t = CATransform3DIdentity;
    
    UIView *currentSlice;
    if(isNextMove){
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, 0, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, 0, 1, 0, 0);
        }
        currentSlice = sliceB;
    }else{
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, M_PI-0.01, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, M_PI+0.01, 1, 0, 0);
        }
        currentSlice = sliceA;
    }
    
    [UIView animateWithDuration:duration animations:^{
        shadowA.alpha = 0.0;
        shadowB.alpha = 0.0;
        currentSlice.layer.transform = t;
        gradientLayer.opacity = 0;
    } completion:^(BOOL finished) {
        if(completePrev){
            [self.delegate flippedToPrev:self];
        }
        [self completeAnimation];
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (void)snapToNext{
    float duration = 0.2f;
    
    CATransform3D t = CATransform3DIdentity;
    
    UIView *currentSlice;
    if(isNextMove){
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, M_PI, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, M_PI, 1, 0, 0);
        }
        currentSlice = sliceB;
    }else{
        if(_orientation == FlipHorizontal){
            t = CATransform3DRotate(t, 0.01, 0, 1, 0);
        }else{
            t = CATransform3DRotate(t, -0.01, 1, 0, 0);
        }
        currentSlice = sliceA;
    }
    [UIView animateWithDuration:duration animations:^{
        shadowA.alpha = 1.0;
        shadowB.alpha = 0.0;
        currentSlice.layer.transform = t;
        gradientLayer.opacity = 0;
    } completion:^(BOOL finished) {
        if(completeNext){
            [self.delegate flippedToNext:self];
        }
        [self completeAnimation];
        [self.view setUserInteractionEnabled:YES];
    }];
}

- (void)completeAnimation{
    if([prev superview]){
        [prev removeFromSuperview];
        prev = nil;
    }
    
    if([next superview]){
        [next removeFromSuperview];
        next = nil;
    }
    
    if([sliceA superview]){
        [sliceA removeFromSuperview];
        sliceA = nil;
    }
    
    if([sliceB superview]){
        [sliceB removeFromSuperview];
        sliceB = nil;
    }
    
    if([shadowA superview]){
        [shadowA removeFromSuperview];
        shadowA = nil;
    }
    
    if([shadowB superview]){
        [shadowB removeFromSuperview];
        shadowB = nil;
    }
}

#pragma mark accessoryMethods

- (UIImage *)getImageFrom:(FlipViewController *)fvc
{
    return [self captureView:fvc.view inSize:self.view.bounds.size inRect:self.view.bounds flipped:NO];
}

- (NSArray *)getSlicesFrom:(FlipViewController *)fvc flipped:(BOOL)flipped
{
    if(!fvc)return nil;
    UIImage *tmpA = [self captureView:fvc.view inSize:self.view.bounds.size inRect:[self getRectForSlice:0] flipped:NO];
    UIImage *tmpB = [self captureView:fvc.view inSize:self.view.bounds.size inRect:[self getRectForSlice:1] flipped:NO];
    
    return [[NSArray alloc] initWithObjects:tmpA, tmpB, nil];
}

- (NSArray *)getInvertedSlicesFrom:(FlipViewController *)fvc flipped:(BOOL)flipped
{
    if(!fvc)return nil;
    UIImage *tmpA = [self captureView:fvc.view inSize:self.view.bounds.size inRect:[self getRectForSlice:0] flipped:YES];
    UIImage *tmpB = [self captureView:fvc.view inSize:self.view.bounds.size inRect:[self getRectForSlice:1] flipped:YES];
    
    return [[NSArray alloc] initWithObjects:tmpA, tmpB, nil];
}

- (UIImage *)captureView: (UIView *)view inSize: (CGSize)size inRect:(CGRect)rect flipped:(BOOL)flipped
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef tmp = CGImageCreateWithImageInRect([viewImage CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
    CGImageRelease(tmp);
    
    if(flipped){
        if(_orientation==FlipHorizontal){
            croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:croppedImage.scale orientation: UIImageOrientationUpMirrored];
        }else{
            croppedImage = [UIImage imageWithCGImage:croppedImage.CGImage scale:croppedImage.scale orientation: UIImageOrientationDownMirrored];
        }
    }
    
    return croppedImage;
}

- (CGRect)getRectForSlice:(int)index
{
    switch (index) {
        case 0:
            return CGRectMake(self.view.bounds.origin.x,
                              self.view.bounds.origin.y,
                              (_orientation == FlipHorizontal) ? self.view.bounds.size.width/2 : self.view.bounds.size.width,
                              (_orientation == FlipHorizontal) ? self.view.bounds.size.height : self.view.bounds.size.height/2);
            
        case 1:
            return CGRectMake((_orientation == FlipHorizontal) ? self.view.bounds.size.width/2 : self.view.bounds.origin.x,
                              (_orientation == FlipHorizontal) ? self.view.bounds.origin.y : self.view.bounds.size.height/2,
                              (_orientation == FlipHorizontal) ? self.view.bounds.size.width/2 : self.view.bounds.size.width,
                              (_orientation == FlipHorizontal) ? self.view.bounds.size.height : self.view.bounds.size.height/2);
    }
    
    return CGRectMake(0, 0, 0, 0);
}

- (void)setFlipGradient:(UIView *)view toLeft:(BOOL)left{
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:0.0f alpha:0.3f].CGColor,
                            (id)[UIColor colorWithWhite:0.3f alpha:0.0f].CGColor,
                            nil];
    if(left){
        if(_orientation == FlipHorizontal){
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.2, 0.0);
        }else{
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.0, 0.2);
        }
    }else{
        if(_orientation == FlipHorizontal){
            gradientLayer.startPoint = CGPointMake(1.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.8, 0.0);
        }else{
            gradientLayer.startPoint = CGPointMake(0.0, 1.0);
            gradientLayer.endPoint = CGPointMake(0.0, 0.8);
        }
    }
    
    gradientLayer.opacity = 0.0f;
    
    [view.layer addSublayer:gradientLayer];
}

- (void)refreshCurrentSlices{
    currentSlices = [self getSlicesFrom:self flipped:NO];
    currentFlippedSlices = [self getInvertedSlicesFrom:self flipped:YES];
}

@end