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
    self.title = @"成都天气";
    
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customBtn setTitle:@"点击请求网络" forState:UIControlStateNormal];
    [customBtn setBackgroundColor:[UIColor redColor]];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(getNet) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    [self.navigationItem setRightBarButtonItem:customItem];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
}

#pragma mark 实现方法
- (void)getNet
{
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    NSDictionary *params = @{@"city":@"成都"};
    [AFCustomClient requestSameWithHttpMethod:HttpMethodGet URLStr:@"weather_mini" params:params networkBlock:^{
        UIAlertView *alertCus = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertCus show];
    } successBlock:^(AFCustomClient *request, id responseObject) {
        
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (status == 1000) {
            NSDictionary *data = [[responseObject objectForKey:@"data"] objectForKey:@"forecast"];
            for (NSDictionary *item in data) {
                [self.dataArray addObject:item];
                [self.tableview reloadData];
                
            }
        }
        
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


#pragma mark table代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"demoCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    NSDictionary *weather = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [weather objectForKey:@"high"];
    cell.detailTextLabel.text = [weather objectForKey:@"date"];
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}







@end
