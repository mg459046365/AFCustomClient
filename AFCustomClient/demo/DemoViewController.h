//
//  DemoViewController.h
//  AFCustomClient
//
//  Created by Cindy on 14-10-24.
//  Copyright (c) 2014年 plusub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
