//
//  PLExpandScrollView.h
//  OmsaTech
//
//  Created by Anil Oruc on 7/23/15.
//  Copyright (c) 2015 OmsaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PLExpandScrollViewStatusExpand = 0,
    PLExpandScrollViewStatusCollapse,
    PLExpandScrollViewStatusPinching
}
PLExpandScrollViewStatus;

@class PLExpandScrollView;

@protocol PLExpandScrollViewDelegate <NSObject>

@optional

-(void)expandScrollView:(PLExpandScrollView*)scrollView changedStatus:(PLExpandScrollViewStatus)status previousStatus:(PLExpandScrollViewStatus)previousStatus;

-(void)expandScrollView:(PLExpandScrollView*)scrollView didSelectItemAtIndex:(NSUInteger)index;

// Default value: [UIScreen mainScreen].bounds.size.height
-(CGFloat)expandHeightInScrollView:(PLExpandScrollView *)scrollView index:(NSUInteger)index;

// Default value: 44.0f
-(CGFloat)collapseHeightInScrollView:(PLExpandScrollView *)scrollView index:(NSUInteger)index;

@end

@protocol PLExpandScrollViewDataSource <NSObject>

@required

-(UIView*)expandScrollView:(PLExpandScrollView *)scrollView viewForItemAtIndex:(NSUInteger)index;

-(NSUInteger)numberOfItemsInScrollView:(PLExpandScrollView *)scrollView;

@end

@interface PLExpandScrollView : UIView

+ (instancetype)init;

+ (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) IBOutlet id<PLExpandScrollViewDataSource> dataSource;

@property (nonatomic, weak) IBOutlet id<PLExpandScrollViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isExpand;

// Default value: NO
@property (nonatomic, assign) BOOL scrollEnabledExpand;

// Default value: YES
@property (nonatomic, assign) BOOL scrollEnabledCollapse;

@property (nonatomic, assign, readonly) PLExpandScrollViewStatus status;

// Default value: Expanding Status: Current Item Index - Collapse Status: Top Item Index
@property (nonatomic, assign, readonly) NSUInteger currentPageIndex;

-(UIView*)visibleItemAtIndex:(NSUInteger)index;

@property (nonatomic, strong, readonly) NSArray *visibleItemIndexs;

- (void)expandAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)collapseWithAnimated:(BOOL)animated;

- (void)reloadData;

@end
