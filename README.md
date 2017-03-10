# FYPopOver
- 可自适应位置的popover视图控件

## Usage

```Objective-C
//创建PopOver
FYPopoverView *popoverView = [FYPopoverView new];
//设置titles
popoverView.menuTitles = @[@"title1",@"title2"];
//传入需要弹出popOver的aView
[popoverView showFromView:aView selected:^(NSInteger index) {
    //Do whatever you want   
}];
```

## Installation

手动添加:
- 将FYPopoverView文件夹中拖拽到项目中
- 导入头文件：`#import "FYPopoverView.h"`

## License

FYPopover is released under the MIT license. See LICENSE for details.
