//
//  ViewController.h
//  MobileWatch
//
//  Created by Ctrip on 14-8-28.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"


@interface ViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *button1;

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (strong, nonatomic) NSArray *myPickerData;
@property (strong, nonatomic) NSArray *myMobileData;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionMain;

@end
