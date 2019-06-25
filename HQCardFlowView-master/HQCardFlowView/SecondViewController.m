








#import "SecondViewController.h"

#import "NoticeTool.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 90, 40)];
    confirmButton.backgroundColor = [UIColor purpleColor];
    [confirmButton setTitle:@"显示" forState:UIControlStateNormal];
    [confirmButton setTitle:@"隐藏" forState:UIControlStateSelected];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.view addSubview:confirmButton];
}

-(void)confirmButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [NoticeTool showWithText:@"测试测试文字测试文字测试文字测试试文字测试文字测试文字试文字测试文字测试文字文字测试文字字" superView:self.view];
    }else{
        [NoticeTool hideWithSuperView:self.view];
    }
}

@end
