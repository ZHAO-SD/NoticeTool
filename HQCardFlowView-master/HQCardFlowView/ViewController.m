




#define KNavHeight ([UIApplication sharedApplication].statusBarFrame.size.height+44.0f)
#import "ViewController.h"

#import "NoticeTool.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView; // 轮播图容器

@end

@implementation ViewController


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 30;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
        
        // 设置 Cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text =  [NSString stringWithFormat:@"数据---%zd",indexPath.row];
        return cell;
        

    
}

#pragma mark - 创建TableView
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.contentInset = UIEdgeInsetsMake(KNavHeight, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        _tableView.rowHeight = 60;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellid"];
        
    }
    return _tableView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    

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
        [NoticeTool showWithText:@"测试测试文字测试文字测试文字测试试文字测试文字测试文字试文字测试文字测试文字文字测试文字字" superView:self.tableView];
    }else{
        [NoticeTool hideWithSuperView:self.tableView];
    }
}

@end
