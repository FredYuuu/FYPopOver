//
//  FYPopoverView.h
//  nicaifustock
//
//  Created by Yu Haoran on 16/8/3.
//  Copyright © 2016年 chenchuanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FYPopoverArrowType) {
    FYPopoverArrowUp,
    FYPopoverArrowDown
};

typedef void(^PopoverBlock)(NSInteger index);

@interface FYPopoverView : UIView

// 菜单列表集合
@property (nonatomic, copy) NSArray *menuTitles;

/*!
 *  @brief 显示弹窗
 *
 *  @param aView    箭头指向的控件
 *  @param selected 选择完成回调
 */
- (void)showFromView:(UIView *)aView selected:(PopoverBlock)selected;
@end


@interface FYPopoverArrow : UIView

@property (nonatomic, assign) FYPopoverArrowType arrowType;
- (instancetype)initWithType:(FYPopoverArrowType)arrowType;

@end