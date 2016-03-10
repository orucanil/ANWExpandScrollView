//
//  PLExpandScrollView.m
//  OmsaTech
//
//  Created by Anil Oruc on 7/23/15.
//  Copyright (c) 2015 OmsaTech. All rights reserved.
//

#import "PLExpandScrollView.h"

#define COLLAPSE_DEFAULTH_HEIGHT 44.0f

@interface PLExpandScrollView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UIPinchGestureRecognizer *pgr;
    
    NSInteger _indexOfPinchingElement;
    CGFloat _initialHeightOfPinchingElement;
    CGPoint _offsetTableViewBeforePinching;
    UIEdgeInsets _insetTableView;
    CGFloat _expandedHeight;
    CGFloat _collapsedHeight;
    
    NSMutableArray *_items;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) CGFloat height;

@end

@implementation PLExpandScrollView

+ (instancetype)init
{
    PLExpandScrollView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (view) {
        
        [view loadView];
    }
    return view;
}

+ (instancetype)initWithFrame:(CGRect)frame
{
    PLExpandScrollView *view = [self init];
    if (view)
    {
        [view setFrame:frame];
    }
    return view;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

-(void)loadView
{
    _isExpand = NO;
    _scrollEnabledCollapse = YES;
    _scrollEnabledExpand = NO;
    _currentPageIndex = NSNotFound;
    _status = PLExpandScrollViewStatusCollapse;
    
    [self addPinchGestureRecognizer];
}

-(void)addPinchGestureRecognizer
{
    [pgr removeTarget:self action:@selector(handlePinch:)];
    pgr = nil;
    pgr = [[UIPinchGestureRecognizer alloc]
           initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    
    [self addGestureRecognizer:pgr];
}


- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self onPinchBegan:pinchGestureRecognizer];
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self onPinchChanged:pinchGestureRecognizer];
    }
    else if ((pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled) || (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded)) {
        [self onPinchEnded:pinchGestureRecognizer];
    }
}

- (void)onPinchBegan:(UIPinchGestureRecognizer*)pinchRecognizer
{
    _indexOfPinchingElement = NSNotFound;
    
    CGPoint pinchLocation = [pinchRecognizer locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:pinchLocation];
    
    if (indexPath != nil) {
        
        self.status = PLExpandScrollViewStatusPinching;
        
        _indexOfPinchingElement = indexPath.row;
        
        _initialHeightOfPinchingElement = _height;
        _offsetTableViewBeforePinching = _tableView.contentOffset;
        
        _tableView.contentInset = UIEdgeInsetsMake(_tableView.frame.size.height, 0.f, _tableView.frame.size.height, 0.f);
    }
}

- (void)onPinchChanged:(UIPinchGestureRecognizer*)pinchRecognizer
{
    if (_indexOfPinchingElement == NSNotFound) {
        return;
    }
    
    CGFloat newHeight = (_initialHeightOfPinchingElement * pinchRecognizer.scale);
    
    self.height = newHeight;
    
    [self updateCellsHeightsAnimated:NO];
    
    CGFloat diffHeight = newHeight - _initialHeightOfPinchingElement;
    CGFloat yOffsetTableView = _offsetTableViewBeforePinching.y + (_indexOfPinchingElement * diffHeight) + (diffHeight / 2.f);
    _tableView.contentOffset = CGPointMake(_offsetTableViewBeforePinching.x, yOffsetTableView);
    
}

- (void)onPinchEnded:(UIPinchGestureRecognizer*)pinchRecognizer
{
    if (_indexOfPinchingElement == NSNotFound) {
        return;
    }
    
    CGPoint offset = _tableView.contentOffset;
    _tableView.contentInset = _insetTableView;
    _tableView.contentOffset = offset;
    
    BOOL open = NO;
    if (_initialHeightOfPinchingElement > _height) { //open
        open = _height > _expandedHeight * 0.8f;
    }
    else { //close
        open = _height > _expandedHeight * 0.2f;
    }
    
    if (open) {
        [self expandAtIndex:_indexOfPinchingElement animated:NO];
        
    }
    else {
        [self collapseWithAnimated:NO];
    }
}

-(void)setHeight:(CGFloat)height
{
    _height = MIN(_expandedHeight, MAX(height, _collapsedHeight));
    
    [self allCellsHeightChanged];
}

-(void)allCellsHeightChanged
{
    for (UIView *item in _items) {
        if ([item isKindOfClass:[UIView class]]) {
            
            CGRect frame = item.frame;
            frame.size.height = _height;
            frame.size.width = self.frame.size.width;
            [item setFrame:frame];
        }
    }
}

- (void)updateCellsHeightsAnimated:(BOOL)animated
{
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    [_tableView beginUpdates];
    [_tableView reloadData];
    [_tableView endUpdates];
    [UIView setAnimationsEnabled:animationsEnabled];
}

- (void)scrollToTopCellAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    @try {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tableView scrollToRowAtIndexPath:([_tableView numberOfRowsInSection:0] > index ? indexPath : [NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0]-1 inSection:0]) atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
    @catch (NSException *exception) {
        [_tableView reloadData];
    }
    @finally {
        
    }
}

- (void)scrollToContentBoundsCellAtIndex:(NSInteger)indexSelected animated:(BOOL)animated
{
    CGFloat visibleTableHeight = _tableView.frame.size.height - _insetTableView.top - _insetTableView.bottom;
    
    NSUInteger indexofLastCell = [_tableView numberOfRowsInSection:0] - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexofLastCell inSection:0];
    CGFloat heightOfContent = [_tableView rectForRowAtIndexPath:indexPath].origin.y + _collapsedHeight;
    
    CGPoint newContentOffset = CGPointZero;
    
    if (visibleTableHeight > heightOfContent) {
        newContentOffset = CGPointMake(_tableView.contentOffset.x, 0.f - _insetTableView.top);
    }
    else {
        CGFloat maxContentOffset = heightOfContent - visibleTableHeight;
        CGFloat percentOfMaxOffset = 0.0f;
        
        if ((CGFloat)(indexofLastCell - 2) != 0) {
            percentOfMaxOffset = MIN(1.f, indexSelected / (CGFloat)(indexofLastCell - 2));
        }
        
        newContentOffset = CGPointMake(_tableView.contentOffset.x, maxContentOffset * percentOfMaxOffset - _insetTableView.top);
    }
    
    void (^blockScrollToBorder)(void) = ^(void)
    {
        _tableView.contentOffset = newContentOffset;
        
        CGPoint offset = _tableView.contentOffset;
        _tableView.contentInset = _insetTableView;
        _tableView.contentOffset = offset;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3f animations:blockScrollToBorder];
    }
    else {
        blockScrollToBorder();
    }
}

-(void)setScrollEnabledExpand:(BOOL)scrollEnabledExpand
{
    _scrollEnabledExpand = scrollEnabledExpand;
    
    if (_isExpand) {
        _tableView.scrollEnabled = scrollEnabledExpand;
    }
}

-(void)setScrollEnabledCollapse:(BOOL)scrollEnabledCollapse
{
    _scrollEnabledCollapse = scrollEnabledCollapse;
    
    if (!_isExpand) {
        _tableView.scrollEnabled = scrollEnabledCollapse;
    }
}

-(void)setStatus:(PLExpandScrollViewStatus)status
{
    if (status == _status) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(expandScrollView:changedStatus:previousStatus:)]) {
        [_delegate expandScrollView:self changedStatus:status previousStatus:_status];
    }
    
    _status = status;
}

- (void)expandAtIndex:(NSInteger)index animated:(BOOL)animated
{
    _currentPageIndex = index;
    
    self.height = _expandedHeight;
    
    _isExpand = YES;
    
    [self updateCellsHeightsAnimated:animated];
    
    [self scrollToTopCellAtIndex:index animated:animated];
    
    _tableView.scrollEnabled = self.scrollEnabledExpand;
    
    self.status = PLExpandScrollViewStatusExpand;
    
    _tableView.separatorColor = [UIColor clearColor];
}

- (void)collapseWithAnimated:(BOOL)animated
{
    _currentPageIndex = NSNotFound;
    
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.frame.size.height, 0.f, _tableView.frame.size.height, 0.f);
    
    self.height = _collapsedHeight;
    
    self.isExpand = NO;
    
    [self updateCellsHeightsAnimated:animated];
    
    [self scrollToContentBoundsCellAtIndex:_indexOfPinchingElement animated:animated];
    
    _tableView.scrollEnabled = self.scrollEnabledCollapse;
    
    self.status = PLExpandScrollViewStatusCollapse;
    
    _tableView.separatorColor = [UIColor whiteColor];
}

- (void)reloadData
{
    _items = [NSMutableArray array];
    for (NSUInteger i = 0; i < [_dataSource numberOfItemsInScrollView:self]; i++) {
        [_items addObject:@""];
    }
    
    _expandedHeight = [UIScreen mainScreen].bounds.size.height;
    _collapsedHeight = COLLAPSE_DEFAULTH_HEIGHT;
    
    if ([_delegate respondsToSelector:@selector(collapseHeightInScrollView:index:)]) {
        _collapsedHeight = [_delegate collapseHeightInScrollView:self index:_indexOfPinchingElement];
    }
    
    if ([_delegate respondsToSelector:@selector(expandHeightInScrollView:index:)]) {
        _expandedHeight = [_delegate expandHeightInScrollView:self index:_indexOfPinchingElement];
    }
    self.height = _isExpand ? _expandedHeight : _collapsedHeight;
    
    [_tableView reloadData];
}

-(UIView*)itemWithIndex:(NSUInteger)index
{
    UIView *view = nil;
    
    if (_items.count > index) {
        
        view = _items[index];
        if (![view isKindOfClass:[UIView class]]) {
            view = [_dataSource expandScrollView:self viewForItemAtIndex:index];
            [_items replaceObjectAtIndex:index withObject:view];
        }
        
        if (view) {
            
            CGRect frame = view.frame;
            frame.size.height = _height;
            frame.size.width = self.frame.size.width;
            [view setFrame:frame];
        }
    }
    return view;
}

-(UIView*)visibleItemAtIndex:(NSUInteger)index
{
    UIView *view = nil;
    
    if (_items.count > index) {
        
        view = _items[index];
        if (![view isKindOfClass:[UIView class]]) {
            view = nil;
        }
        
    }
    
    return view;
}

-(NSArray *)visibleItemIndexs
{
    NSMutableArray *indexes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in _tableView.indexPathsForVisibleRows) {
        [indexes addObject:@(indexPath.row)];
    }
    
    return indexes;
}

#pragma mark - UITableView Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(expandScrollView:didSelectItemAtIndex:)]) {
        [_delegate expandScrollView:self didSelectItemAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expandScrollViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"expandScrollViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.layer.masksToBounds = YES;
    }
    
    UIView *view = [self itemWithIndex:indexPath.row];
    
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    [view setFrame:view.bounds];
    
    [cell.contentView setFrame:view.bounds];
    
    [cell setFrame:view.bounds];
    
    [cell.contentView addSubview:view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UIScrollView Delegates


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
