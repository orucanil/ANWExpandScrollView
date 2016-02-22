# ExpandScrollView
Expand - Collapse Scroll View - Animate With Pinch Gesture 


## Display Type Visual Examples 

----
![Visual1](http://g.recordit.co/YIPEARCPeZ.gif)


Properties
--------------

The PLExpandScrollView has the following properties (note: for iOS, UIView when using properties):

    @property (nonatomic, weak) IBOutlet id<PLExpandScrollViewDataSource> dataSource;

An object that supports the PLExpandScrollViewDataSource protocol and can provide views to populate the scroll.

    @property (nonatomic, weak) IBOutlet id<PLExpandScrollViewDelegate> delegate;

An object that supports the PLExpandScrollViewDelegate protocol and can respond to scroll events and layout requests.

    @property (nonatomic, assign, readonly) BOOL isExpand;

Returns the scroll is currently being state programatically.

    @property (nonatomic, assign) BOOL scrollEnabledExpand;

Enables and disables user scrolling on expand state of the scroll. The scroll can still be scrolled programmatically on expand state if this property is set to NO.

    @property (nonatomic, assign) BOOL scrollEnabledCollapse;

Enables and disables user scrolling on collapse state of the scroll. The scroll can still be scrolled programmatically on collapse state if this property is set to YES.

    @property (nonatomic, assign, readonly) PLExpandScrollViewStatus status;

Returns the scroll is currently being status programatically.

    @property (nonatomic, assign, readonly) NSUInteger currentPageIndex;

Returns the scroll is currently being page index programatically. Expanding Status: Current Item Index - Collapse Status: Top Item Index.

    @property (nonatomic, strong, readonly) NSArray *visibleItemIndexs;

An array containing the indexes of only visible item views currently loaded and visible in the scroll. The array contains NSNumber objects whose integer values match the indexes of the views. The indexes for item views start at zero and match the indexes passed to the dataSource to load the view, however the indexes not equal to numberOfItems.


Methods
--------------

The PLExpandScrollView class has the following methods (note: for iOS, UIView in method arguments):

    + (instancetype)init;

Custom initialize method.

    + (instancetype)initWithFrame:(CGRect)frame;

Custom initialize method.

    - (UIView*)visibleItemAtIndex:(NSUInteger)index;

Returns the visible item view with the specified index. Note that the index relates to the position in the scroll, and not the position in the visibleItemIndexs array, which may be different. Pass a negative index or one greater than or equal to numberOfItems to retrieve placeholder views. The method only works for visible item views and will return nil if the view at the specified index has not been loaded, or if the index is out of bounds.

    - (void)expandAtIndex:(NSInteger)index animated:(BOOL)animated;

This will center the scroll expand on the specified item, either immediately or with a smooth animation.

    - (void)collapseWithAnimated:(BOOL)animated;

This will top the scroll collapse on the specified item, either immediately or with a smooth animation.

    - (void)reloadData;

This reloads all scroll views from the dataSource and refreshes the scroll display.


Protocols
--------------

The PLExpandScrollView follows the Apple convention for data-driven views by providing two protocol interfaces, PLExpandScrollViewDataSource and PLExpandScrollViewDelegate. The PLExpandScrollViewDataSource protocol has the following required methods (note: for iOS, UIView in method arguments):

    -(NSUInteger)numberOfItemsInScrollView:(PLExpandScrollView *)scrollView;

Return the number of items (views) in the scroll.

    -(UIView*)expandScrollView:(PLExpandScrollView *)scrollView viewForItemAtIndex:(NSUInteger)index;

Return a view to be displayed at the specified index in the scroll.

The PLExpandScrollViewDelegate protocol has the following optional methods:

    -(void)expandScrollView:(PLExpandScrollView*)scrollView didSelectItemAtIndex:(NSUInteger)index;

This method will fire if the user taps any scroll item view, including the currently selected view. This method will not fire if the user taps a control within the currently selected view (i.e. any view that is a subclass of UIControl).

    -(void)expandScrollView:(PLExpandScrollView*)scrollView changedStatus:(PLExpandScrollViewStatus)status previousStatus:(PLExpandScrollViewStatus)previousStatus;

This method is called whenever the scroll scrolls far enough for the currentItemIndex property to change. It is called regardless of whether the item index was updated programatically or through user interaction.

    -(CGFloat)expandHeightInScrollView:(PLExpandScrollView *)scrollView index:(NSUInteger)index;

This method is called whenever the scroll change status far enough for the currentItemIndex property to change. It is called regardless of whether the item index was updated programatically or through user interaction. The scroll can still be scrolled programmatically on expand state if this property is set to [UIScreen mainScreen].bounds.size.height.

    -(CGFloat)collapseHeightInScrollView:(PLExpandScrollView *)scrollView index:(NSUInteger)index;

This method is called whenever the scroll change status far enough for the currentItemIndex property to change. It is called regardless of whether the item index was updated programatically or through user interaction. The scroll can still be scrolled programmatically on collapse state if this property is set to 44.0f.


How to use ?
----------

![Visual4](http://g.recordit.co/ykx1SbnAmZ.gif)
----

```Objective-C
#import "EndlessTableView.h"
...

@property (weak, nonatomic) IBOutlet EndlessTableView *tableViewProduct;
@property (weak, nonatomic) IBOutlet EndlessTableView *tableViewCampaign;

- (void)loadView
{
[super loadView];

PLExpandScrollView *scrollView = [PLExpandScrollView initWithFrame:[UIScreen mainScreen].bounds];
scrollView.delegate = self;
scrollView.dataSource = self;

[view reloadData];

[view expandAtIndex:0 animated:NO];

}
```

Build and run the project files. Enjoy more examples!