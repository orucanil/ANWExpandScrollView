//
//  ViewController.m
//  ExpandScrollViewDemo
//
//  Created by Anil Oruc on 3/10/16.
//  Copyright © 2016 Anil Oruc. All rights reserved.
//

#import "ViewController.h"
#import "PLExpandScrollView.h"

@interface ViewController ()<PLExpandScrollViewDataSource,PLExpandScrollViewDelegate>

@property (nonatomic,strong) NSArray *colors;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _colors = @[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]];
    
    PLExpandScrollView *scrollView = [PLExpandScrollView initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delegate = self;
    scrollView.dataSource = self;
    
    [scrollView reloadData];
    
    [scrollView expandAtIndex:0 animated:NO];
    
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

#pragma mark - PLExpandScrollView delegates & datasources

-(NSUInteger)numberOfItemsInScrollView:(PLExpandScrollView *)scrollView
{
    return _colors.count;
}

-(UIView *)expandScrollView:(PLExpandScrollView *)scrollView viewForItemAtIndex:(NSUInteger)index
{
    UIView * view = [UIView new];
    
    view.backgroundColor = _colors[index];
    
    return view;
}

-(void)expandScrollView:(PLExpandScrollView *)scrollView didSelectItemAtIndex:(NSUInteger)index
{
    
}

-(CGFloat)collapseHeightInScrollView:(PLExpandScrollView *)scrollView index:(NSUInteger)index
{
    return 160.0f;
}

-(void)expandScrollView:(PLExpandScrollView *)scrollView changedStatus:(PLExpandScrollViewStatus)status previousStatus:(PLExpandScrollViewStatus)previousStatus
{
    // Show Animation
}

@end
