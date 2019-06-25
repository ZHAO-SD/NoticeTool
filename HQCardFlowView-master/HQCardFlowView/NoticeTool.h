

/**
 显示公告工具
    1,无限滚动显示
    2,scrollView上显示时,可以让scorllView下移
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTool : UIView


/**
 显示公告

 @param text 公告内容
 @param superView 父视图
 */
+(void)showWithText:(NSString *)text superView:(UIView *)superView;


/**
 隐藏公告

 @param superView 父视图
 */
+(void)hideWithSuperView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
