//
//  ANWExpandScrollView.h
//  OmsaTech
//
//  Created by Anil Oruc on 7/23/15.
//  Copyright (c) 2015 OmsaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ANWExpandScrollViewStatusExpand = 0,
    ANWExpandScrollViewStatusCollapse,
    ANWExpandScrollViewStatusPinching
}
ANWExpandScrollViewStatus;

@class ANWExpandScrollView;

@protocol ANWExpandScrollViewDelegate <NSObject>

@optional

-(void)expandScrollView:(ANWExpandScrollView*)scrollView changedStatus:(ANWExpandScrollViewStatus)status previousStatus:(ANWExpandScrollViewStatus)previousStatus;

-(void)expandScrollView:(ANWExpandScrollView*)scrollView didSelectItemAtIndex:(NSUInteger)index;

// Default value: [UIScreen mainScreen].bounds.size.height
-(CGFloat)expandHeightInScrollView:(ANWExpandScrollView *)scrollView index:(NSUInteger)index;

// Default value: 44.0f
-(CGFloat)collapseHeightInScrollView:(ANWExpandScrollView *)scrollView index:(NSUInteger)index;

@end

@protocol ANWExpandScrollViewDataSource <NSObject>

@required

-(UIView*)expandScrollView:(ANWExpandScrollView *)scrollView viewForItemAtIndex:(NSUInteger)index;

-(NSUInteger)numberOfItemsInScrollView:(ANWExpandScrollView *)scrollView;

@end

@interface ANWExpandScrollView : UIView

+ (instancetype)init;

+ (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) IBOutlet id<ANWExpandScrollViewDataSource> dataSource;

@property (nonatomic, weak) IBOutlet id<ANWExpandScrollViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isExpand;

// Default value: NO
@property (nonatomic, assign) BOOL scrollEnabledExpand;

// Default value: YES
@property (nonatomic, assign) BOOL scrollEnabledCollapse;

@property (nonatomic, assign, readonly) ANWExpandScrollViewStatus status;

// Default value: Expanding Status: Current Item Index - Collapse Status: Top Item Index
@property (nonatomic, assign, readonly) NSUInteger currentPageIndex;

-(UIView*)visibleItemAtIndex:(NSUInteger)index;

@property (nonatomic, strong, readonly) NSArray *visibleItemIndexs;

- (void)expandAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)collapseWithAnimated:(BOOL)animated;

- (void)reloadData;

@end
