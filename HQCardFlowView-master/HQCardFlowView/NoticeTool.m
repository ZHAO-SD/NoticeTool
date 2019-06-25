






#import "NoticeTool.h"

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define KSWidth [UIScreen mainScreen].bounds.size.width
#define KNavHeight ([UIApplication sharedApplication].statusBarFrame.size.height+44.0f)
#define KViewHeight 30.0f
#define KBackgroundColorAndAlpha(A) [RGBCOLOR(254, 252, 237) colorWithAlphaComponent:A]

@interface NoticeTool()<UIScrollViewDelegate>

/** 喇叭 */
@property (nonatomic, strong) UIImageView *hornImgView;
/** 滚动背景 */
@property (nonatomic, strong) UIScrollView *scrollBgView;
/** 滚动label */
@property (nonatomic, strong) UILabel *textLabel;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 滚动文字 */
@property (nonatomic, copy) NSString *scrollText;
/** 滚动文字的宽度 */
@property (nonatomic, assign) CGFloat scrollTextWidth;
/** 记录父视图 */
@property (nonatomic, strong) UIView *superView;

@end

@implementation NoticeTool

-(instancetype)initWithText:(NSString *)text{
    if (self = [super init]) {
        self.frame = CGRectMake(0, KNavHeight-KViewHeight, KSWidth, KViewHeight);
        self.backgroundColor = KBackgroundColorAndAlpha(0);
        self.scrollText = text;
        
        //喇叭
        [self addSubview:self.hornImgView];
        
        //滚动内容
        [self addSubview:self.scrollBgView];
        
        //关闭
        [self addSubview:self.closeBtn];
    }
    return self;
}

#pragma mark - 文字开始滚动
-(void)startScrollText{
    
    //默认的偏移量
    CGPoint defaultPoint = _scrollBgView.contentOffset;
    
    //时间 = 总路径 / 速度
    CGFloat wholeWidth = _scrollTextWidth + KSWidth;
    CGFloat speed = 80;
    CGFloat duration = wholeWidth / speed;

    //开启动画
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // 计算移动的距离
                         CGPoint point = weakSelf.scrollBgView.contentOffset;
                         point.x = wholeWidth;
                         weakSelf.scrollBgView.contentOffset = point;
                     }
                     completion:^(BOOL finished) {
                         
                         //滚动结束,回到默认的偏移量
                         weakSelf.scrollBgView.contentOffset = defaultPoint;
                         
                         //开启循环滚动
                         [weakSelf startScrollText];
                     }];

    
}

#pragma mark - 显示公告
+(void)showWithText:(NSString *)text superView:(UIView *)superView{
    
    NoticeTool *noticeView = [[NoticeTool alloc] initWithText:text];
    noticeView.superView = superView;
    [superView addSubview:noticeView];
    
    //如果父视图的类型是ScrollView
    if ([superView isKindOfClass:[UIScrollView class]]) {
        noticeView.frame = CGRectMake(0, -KViewHeight, KSWidth, KViewHeight);
        noticeView.tag = 0;
        UIScrollView *scrollView = (UIScrollView *)superView;
        //显示公告
        [noticeView scrollViewShowNotice:scrollView];
    //如果父视图的类型是View
    }else{
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            noticeView.backgroundColor = KBackgroundColorAndAlpha(1);
            CGRect frame = noticeView.frame;
            frame.origin.y = KNavHeight;
            noticeView.frame = frame;
        }completion:^(BOOL finished) {
            
            //让文字开始滚动
            [noticeView startScrollText];
            
        }];
        
        
        
    }
    
}
#pragma mark - 隐藏公告
+(void)hideWithSuperView:(UIView *)superView{
    
    for (UIView *view in superView.subviews) {
    
        if ([view isKindOfClass:[NoticeTool class]]) {
            
            //如果父视图的类型是ScrollView
            if ([superView isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)superView;
                if (view.tag == 1) {
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        view.backgroundColor = KBackgroundColorAndAlpha(0);
                        UIEdgeInsets inset = scrollView.contentInset;
                        inset.top = scrollView.contentInset.top - KViewHeight;
                        scrollView.contentInset = inset;
                        [scrollView scrollRectToVisible:view.bounds animated:YES];
                        
                    }completion:^(BOOL finished) {
                        
                        //移除公告
                        [view removeFromSuperview];
                        
                    }];
                }
            //如果父视图的类型是View
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    view.backgroundColor = KBackgroundColorAndAlpha(0);
                    CGRect frame = view.frame;
                    frame.origin.y = KNavHeight - KViewHeight;
                    view.frame = frame;
                }completion:^(BOOL finished) {
                    //移除公告
                    [view removeFromSuperview];
                }];
            }
        }
    }
}


#pragma mark - 懒加载
-(UIImageView *)hornImgView{
    if (_hornImgView == nil) {
        _hornImgView = [[UIImageView alloc] init];
        _hornImgView.image = [UIImage imageNamed:@"trumpet"];
        [_hornImgView sizeToFit];
        
        
        //等比例缩放图片
        CGFloat maxHeight = KViewHeight - 8;
        CGFloat newWidth = _hornImgView.image.size.width / (_hornImgView.image.size.height / maxHeight);
 
        CGFloat w = newWidth;
        CGFloat h = maxHeight;
        CGFloat y = (KViewHeight - h)*0.5;
        CGFloat x = 8;
        _hornImgView.frame = CGRectMake(x, y, w, h);
        
    }
    return _hornImgView;
}

-(UIScrollView *)scrollBgView{
    if (_scrollBgView == nil) {
        _scrollBgView = [[UIScrollView alloc] init];
        _scrollBgView.showsHorizontalScrollIndicator = NO;
        
        CGFloat x = CGRectGetMaxX(self.hornImgView.frame) + 2;
        CGFloat y = 0;
        CGFloat w = self.closeBtn.frame.origin.x - x - 4;
        CGFloat h = KViewHeight;
        _scrollBgView.frame = CGRectMake(x, y, w, h);
        [_scrollBgView addSubview:self.textLabel];
        _scrollBgView.contentSize = CGSizeMake(_scrollTextWidth, KViewHeight);
    }
    return _scrollBgView;
}

-(UILabel *)textLabel{
    if (_textLabel == nil) {
        //计算文字的宽度
        _scrollTextWidth = [self.scrollText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.text = self.scrollText;
        _textLabel.textColor = RGBCOLOR(255, 98, 0);
        _textLabel.frame = CGRectMake(CGRectGetMaxX(self.scrollBgView.frame), 0, _scrollTextWidth, KViewHeight);
    }
    return _textLabel;
}

-(UIButton *)closeBtn{
    if (_closeBtn == nil) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn addTarget:self action:@selector(closeViewAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundImage: [UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
        CGFloat h = KViewHeight - 16;
        CGFloat w = h;
        CGFloat x = KSWidth - w - 8;
        CGFloat y = 8;
         _closeBtn.frame = CGRectMake(x, y, w, h);
    }
    return _closeBtn;
}

#pragma mark - 在scrollView上显示公告
-(void)scrollViewShowNotice:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= -KViewHeight) {
  
        self.tag = 1;
        if (self.tag == 1) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.backgroundColor = KBackgroundColorAndAlpha(1);
                
                UIEdgeInsets inset = scrollView.contentInset;
                inset.top = scrollView.contentInset.top + KViewHeight;
                scrollView.contentInset = inset;
                [scrollView scrollRectToVisible:self.bounds animated:YES];
                
            }completion:^(BOOL finished) {
                //让文字开始滚动
                [self startScrollText];
                
            }];
        }

    }
    
}

#pragma mark - 关闭点击
-(void)closeViewAction{
    [NoticeTool hideWithSuperView:self.superView];
}

@end
