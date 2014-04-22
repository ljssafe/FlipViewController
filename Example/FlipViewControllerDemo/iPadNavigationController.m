//
//  iPadNavigationController.m
//  FlipViewControllerDemo
//
//  Created by Vincenzo Romano on 15/04/14.
//  Copyright (c) 2014 Vincenzo Romano. All rights reserved.
//

#import "iPadNavigationController.h"
#import "FlipViewController.h"

@interface iPadNavigationController (){
    FlipViewController *flip_1, *flip_2, *flip_3, *flip_4, *flip_5;
    NSArray *flipControllers;
    int currentIndex;
}

@end

@implementation iPadNavigationController

- (id)init{
    flip_1 = [[FlipViewController alloc] init];
    flip_1.delegate = self;
    [flip_1 setDefaultImage:[UIImage imageNamed:@"default-iPad"]];
    [flip_1 setOrientation:FlipHorizontal];
    [flip_1.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_1.jpg"]]];
    
    flip_2 = [[FlipViewController alloc] init];
    flip_2.delegate = self;
    [flip_2 setOrientation:FlipHorizontal];
    [flip_2.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_2.jpg"]]];
    
    flip_3 = [[FlipViewController alloc] init];
    flip_3.delegate = self;
    [flip_3 setOrientation:FlipHorizontal];
    [flip_3.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_3.jpg"]]];
    
    flip_4 = [[FlipViewController alloc] init];
    flip_4.delegate = self;
    [flip_4 setOrientation:FlipHorizontal];
    [flip_4.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_4.jpg"]]];
    
    flip_5 = [[FlipViewController alloc] init];
    flip_5.delegate = self;
    [flip_5 setDefaultImage:[UIImage imageNamed:@"default-iPad"]];
    [flip_5 setOrientation:FlipHorizontal];
    [flip_5.view addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat_5.jpg"]]];
    
    [flip_1 setNext:flip_2];
    
    [flip_2 setPrevious:flip_1];
    [flip_2 setNext:flip_3];
    
    [flip_3 setPrevious:flip_2];
    [flip_3 setNext:flip_4];
    
    [flip_4 setPrevious:flip_3];
    [flip_4 setNext:flip_5];
    
    [flip_5 setPrevious:flip_4];
    
    flipControllers = @[flip_1, flip_2, flip_3, flip_4, flip_5];
    currentIndex = 0;
    
    self = [self initWithRootViewController:flip_1];
    if(self){
        [self setNavigationBarHidden:YES];
    }
    return self;
}

- (void)flippedToPrev:(FlipViewController *)fvc{
    currentIndex--;
    NSLog(@"%i", currentIndex);
    [self popViewControllerAnimated:NO];
}

- (void)flippedToNext:(FlipViewController *)fvc{
    currentIndex++;
    NSLog(@"%i", currentIndex);
    [self pushViewController:[flipControllers objectAtIndex:currentIndex] animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
