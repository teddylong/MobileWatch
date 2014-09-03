//
//  DetailController.m
//  MobileWatch
//
//  Created by Ctrip on 14-8-29.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import "DetailController.h"
#import "Mobile.h"
#import "MonitorController.h"


@interface DetailController()

@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *mobiles;

@end

@implementation DetailController

@synthesize IDLabel;
@synthesize tempLabelTEXT;
@synthesize backBtn;



- (void)viewDidLoad
{
    [super viewDidLoad];
	IDLabel.text = tempLabelTEXT;
    _mobiles = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    NSString* url = [NSString stringWithFormat:@"http://192.168.43.202/Pages/H5/Data.ashx?type=GetMobileFromType&MobileType=%@",tempLabelTEXT];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *result in responseObject)
        {
            Mobile *tempMobile = [[Mobile alloc] init];
            tempMobile.runID = [result objectForKey:@"RunID"];
            tempMobile.deviceName = [result objectForKey:@"DeviceName"];
            tempMobile.slaveName = [result objectForKey:@"SlaveName"];
            tempMobile.labelName = [result objectForKey:@"Label"];
            tempMobile.status = [result objectForKey:@"Status"];
            tempMobile.ip = [result objectForKey:@"IOSIPAddress"];
            
            
            [_mobiles addObject:tempMobile];
        }

        [self.mobileTable reloadData];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifier = @"MobileTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    NSInteger row = [indexPath row];
    
    Mobile *mobile = _mobiles[row];

    UILabel* mobileLabel = (UILabel *)[cell.contentView viewWithTag:1];
    mobileLabel.text =  mobile.labelName;
    
    UILabel* mobileSlave = (UILabel *)[cell.contentView viewWithTag:2];
    mobileSlave.text = mobile.slaveName;
    
    
    
    UILabel *mobileUDID = (UILabel *)[cell.contentView viewWithTag:5];
    mobileUDID.text = mobile.deviceName;
    
    if([mobile.status isEqual: @"busy"])
    {
        UIWebView *statusWebView = (UIWebView *)[cell.contentView viewWithTag:3];
        
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Loading" ofType:@"gif"]];
        [statusWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        
        
        UILabel* mobileRunID = (UILabel *)[cell.contentView viewWithTag:4];
        NSString *runidText = @"RunID: ";
        mobileRunID.text = [runidText stringByAppendingString:mobile.runID];
    }
    else
    {
        UIWebView *statusWebView = (UIWebView *)[cell.contentView viewWithTag:3];
        [statusWebView setScalesPageToFit:NO];
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"sleep" ofType:@"png"]];
        [statusWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        UILabel* mobileRunID = (UILabel *)[cell.contentView viewWithTag:4];
        mobileRunID.text =  mobile.status;
    }
    
    [cell setUserInteractionEnabled:YES];
    
    return cell;

}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = [indexPath row];
    [self performSegueWithIdentifier:@"MobileMonitor" sender:self];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mobiles count];
}


- (IBAction)clickBackBtn:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *idetifier = segue.identifier;
    
    if ([idetifier isEqualToString:@"MobileMonitor"]) {
        MonitorController *monitor = segue.destinationViewController;
        monitor.mobile = _mobiles[_selectedRow];
    }
}

@end
