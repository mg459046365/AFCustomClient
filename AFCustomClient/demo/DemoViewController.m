//
//  DemoViewController.m
//  AFCustomClient
//
//  Created by Cindy on 14-10-24.
//  Copyright (c) 2014年 plusub. All rights reserved.
//

#import "DemoViewController.h"
#import "AFCustomClient.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"AFCustomClient Demo";
    
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customBtn setTitle:@"请求网络" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(getNet) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    [self.navigationItem setRightBarButtonItem:customItem];
    
}

#pragma mark 实现方法
- (void)getNet
{
    [AFCustomClient requestSameWithHttpMethod:HttpMethodGet URLStr:@"ll" params:nil networkBlock:^{
        UIAlertView *alertCus = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertCus show];
    } successBlock:^(AFCustomClient *request, id responseObject) {
        NSLog(@"%@",responseObject);
    } failedBlock:^(AFCustomClient *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
