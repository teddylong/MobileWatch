//
//  MonitorController.h
//  MobileWatch
//
//  Created by Ctrip on 14-9-2.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mobile.h"
#import "AFNetworking.h"

@interface MonitorController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Mobile *mobile;
@property (weak, nonatomic) IBOutlet UITableView *messageTable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)selectBack:(id)sender;

@end
