//
//  ViewController.m
//  TextMatchEmail
//
//  Created by ching on 16/3/8.
//  Copyright © 2016年 杭州中新力合-程朋. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray * hzArr;//后缀数组
@property(nonatomic,strong)NSMutableArray * ppMuArr;//匹配中的数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadHzArray];
    [self loadArray];
    [self loadUI];
}
/**
 *  加载邮箱后缀数组
 */
-(void)loadHzArray{
    _hzArr = @[@"@qq.com", @"@163.com", @"@126.com", @"@gmail.com", @"@sina.com", @"@hotmail.com",
               @"@sohu.com", @"@foxmail.com", @"@outlook.com"];
}
/**
 *  初始化匹配数组
 */
-(void)loadArray{
    _ppMuArr = [NSMutableArray array];
}
/**
 *  加载UI控件
 */
- (void)loadUI
{
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 40)];
    label.text = @"TextField邮箱后缀联想输入";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tf = [[UITextField alloc] init];
    _tf.borderStyle = UITextBorderStyleRoundedRect;
    _tf.placeholder = @"请输入邮箱";
    _tf.font = [UIFont systemFontOfSize:13];
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf.frame = CGRectMake(0,100,self.view.frame.size.width,30);
    [self.view addSubview:_tf];
    _tf.delegate = self;
    // email后缀列表
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,130,self.view.frame.size.width,120)];
    _table.dataSource=self;
    _table.delegate=self;
    _table.hidden = YES;
    [self.view addSubview:_table];
}
#pragma mark 文本框字符变化时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.table.hidden = NO;
    if (!range.length)
    {
        [self loadArray];
        [_hzArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * ppString = [textField.text stringByAppendingString:[NSString stringWithFormat:@"%@%@",string,obj]];
            [self.ppMuArr addObject:ppString];
        }];
    }
    else
    {
        [self loadArray];
        if (textField.text.length - 1 == 0) {
            self.table.hidden = YES;
        }else{
            [_hzArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *matchStr = [textField.text substringToIndex:(textField.text.length - 1)];
                NSString * ppString = [NSString stringWithFormat:@"%@%@",matchStr,obj];
                [self.ppMuArr addObject:ppString];
            }];
        }
    }
    [self.table reloadData];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.table.hidden = YES;
    return YES;
}
// 进入编辑状态是否需要匹配
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.length != 0)
    {
        self.table.hidden = NO;
        [self.table reloadData];
    }
    return YES;
}

#pragma mark dataSource method and delegate method

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return self.ppMuArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.ppMuArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 30;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 将完整email填入输入框
    self.tf.text = self.ppMuArr[indexPath.row];
    self.table.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.table.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
