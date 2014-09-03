//
//  DetailController.h
//  MobileWatch
//
//  Created by Ctrip on 14-8-29.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface DetailController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mobileTable;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)clickBackBtn:(id)sender;

@property(nonatomic,strong) NSString *tempLabelTEXT;
@end
