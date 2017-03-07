//
//  FYPopoverView.m
//  nicaifustock
//
//  Created by Yu Haoran on 16/8/3.
//  Copyright © 2016年 chenchuanbo. All rights reserved.
//

#import "FYPopoverView.h"

// 字体大小
#define kPopoverFontSize 16.f
// 箭头高度
#define kArrowH 8
// 箭头宽度
#define kArrowW 15

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//
//#define KBgColor [UIColor colorWithRed:51.f green:59.f blue:70.f alpha:1]
//
//#define KBorderColor [UIColor colorWithRed:30.f green:36.f blue:43.f alpha:1]

@interface FYPopoverView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FYPopoverArrow *arrowView;
@property (nonatomic, copy) PopoverBlock selectedBlock;

@end

@implementation FYPopoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置tableView默认的分割线起终点位置
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.layer.cornerRadius  = 2.f;
    self.tableView.layer.borderColor   = [UIColor cyanColor].CGColor;
    self.tableView.layer.borderWidth   = 1.f;
}

#pragma mark - getter

- (UITableView *)tableView
{
    if (_tableView) return _tableView;
    
    _tableView = [UITableView new];
    
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.rowHeight       = 38;
    _tableView.separatorColor  = [UIColor grayColor];
    _tableView.scrollEnabled   = NO;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kPopoverCellIdentifier"];
    
    _tableView.tableFooterView = UIView.new;
    
    return _tableView;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPopoverCellIdentifier"];
    cell.textLabel.font              = [UIFont systemFontOfSize:kPopoverFontSize];
    cell.textLabel.textAlignment     = NSTextAlignmentCenter;
    cell.textLabel.textColor         = [UIColor whiteColor];
    cell.textLabel.text              = [self.menuTitles objectAtIndex:indexPath.row];
    cell.selectionStyle              = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
        if (_selectedBlock) {
            _selectedBlock(indexPath.row);
        }
        
        [self removeFromSuperview];
    }];
}

#pragma mark - private
// 点击透明层隐藏
- (void)hide
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark - public

/*!
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected
{
    if (selected) _selectedBlock = selected;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 背景遮挡
    _backgroundView = UIView.new;
    _backgroundView.frame = keyWindow.bounds;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.userInteractionEnabled = YES;
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [keyWindow addSubview:_backgroundView];
    
    // 刷新数据更新contentSize
    [self.tableView reloadData];
    
    // 获取触发弹窗的按钮在window中的坐标
    CGRect triggerRect   = [aView convertRect:aView.bounds toView:keyWindow];
    // 箭头指向的中心点
    CGFloat arrowCenterX = CGRectGetMaxX(triggerRect)-CGRectGetWidth(triggerRect)/2;
    
    // 取得标题中的最大宽度
    CGFloat maxWidth = 0;
    for (id obj in self.menuTitles) {
        if ([obj isKindOfClass:[NSString class]]) {
            CGSize titleSize = [obj sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kPopoverFontSize]}];
            if (titleSize.width > maxWidth) {
                maxWidth = titleSize.width;
            }
        }
    }
    CGFloat curWidth  = ((maxWidth+50)>SCREEN_WIDTH-30)?SCREEN_WIDTH-30:(maxWidth+50);
    CGFloat curHeight = self.tableView.contentSize.height+kArrowH;
    CGFloat curX      = arrowCenterX-curWidth/2;
    CGFloat curY      = CGRectGetMaxY(triggerRect)+10;
    
    // 如果箭头指向点距离屏幕右边减去5px不足curWidth的一半的话就重新设置curX
    if ((SCREEN_WIDTH-arrowCenterX-5)<curWidth/2) {
        curX = curX-(curWidth/2-(SCREEN_WIDTH-arrowCenterX-5));
    }
    // 如果箭头指向点距离屏幕左边加上5px不足curWidth的一半的话就重新设置curX
    if (arrowCenterX+5<curWidth/2) {
        curX = curX+(curWidth/2-arrowCenterX)+5;
    }
    FYPopoverArrowType type = FYPopoverArrowUp;
    // 如果popoverView出了屏幕下边，调整curY
    if (curY + curHeight > [UIScreen mainScreen].bounds.size.height - (triggerRect.size.height + triggerRect.origin.y)) {
        curY = triggerRect.origin.y - 20 - curHeight;
        type = FYPopoverArrowDown;
    }
    // 箭头
    _arrowView = [[FYPopoverArrow alloc] initWithType:type];
    
    self.frame = CGRectMake(curX, curY, curWidth, curHeight);
    // 根据type设置箭头的frame
    if (type == FYPopoverArrowUp) {
        _arrowView.frame = CGRectMake(arrowCenterX-curX-kArrowW/2, 1, kArrowW, kArrowH*2+1);
    } else {
        _arrowView.frame = CGRectMake(arrowCenterX-curX-kArrowW/2, curHeight-kArrowH-2 , kArrowW, kArrowH*2+1);
    }
    [self addSubview:_arrowView];
    
    // tableView放在箭头底下, 用于箭头挡住tableView边框
    [self insertSubview:self.tableView belowSubview:_arrowView];
    self.tableView.frame = CGRectMake(0, kArrowH, curWidth, self.tableView.contentSize.height);
    [keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

@end

// 箭头
@implementation FYPopoverArrow

- (instancetype)initWithType:(FYPopoverArrowType)arrowType {
    if (self = [super init]) {
        self.arrowType = arrowType;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize curSize = rect.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextBeginPath(context);
    if (self.arrowType == FYPopoverArrowUp) {
        CGContextMoveToPoint(context, 0, curSize.height/2);
        CGContextAddLineToPoint(context, curSize.width/2, 0);
        CGContextAddLineToPoint(context, curSize.width, curSize.height/2);
    } else {
        CGContextMoveToPoint(context, 0, curSize.height/2);
        CGContextAddLineToPoint(context, curSize.width/2, curSize.height);
        CGContextAddLineToPoint(context, curSize.width, curSize.height/2);
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end

