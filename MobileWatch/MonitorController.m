//
//  MonitorController.m
//  MobileWatch
//
//  Created by Ctrip on 14-9-2.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import "MonitorController.h"
#import "Message.h"
#import "SocketIO.h"


@interface MonitorController()

@property (assign, nonatomic) NSInteger selectedRow;
@property (strong, nonatomic) NSMutableArray *messages;
@property (assign, nonatomic) NSString *lastImageAddress;

@end

@implementation MonitorController

@synthesize mobile;

@synthesize lastImageAddress;


- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel* mobileUDID = (UILabel*)[self.view viewWithTag:1];
    UILabel* mobileIP = (UILabel*)[self.view viewWithTag:2];
    mobileUDID.text = mobile.deviceName;
    mobileIP.text = mobile.ip;
    lastImageAddress = @"";
    
    // Call start to record
    
    //SocketIO * s = [[SocketIO alloc]init];
    //[s connectToHost:mobile.ip onPort:6789];
    //NSDictionary * sendJosn = [NSDictionary dictionaryWithObjectsAndKeys:@"asd",@"udid","true",@"isStart", nil];
    //[s sendJSON:sendJosn];
    
    //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
    //                      @"value1", @"key1", @"value2", @"key2", nil];

    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
    NSThread *threadImage = [[NSThread alloc] initWithTarget:self selector:@selector(newThreadImage) object:nil];
    
    [thread start];
    [threadImage start];
    
}

-(void) newThread
{
    @autoreleasepool {
      
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(GetMessage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void) newThreadImage
{
    @autoreleasepool {
        
        [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(GetImageSource) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void)GetMessage
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    _messages = [[NSMutableArray alloc] init];
    [self.messageTable reloadData];
    //[self.messages removeAllObjects];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    NSString* url = [NSString stringWithFormat:@"http://192.168.43.202/Pages/H5/Data.ashx?type=GetDebugMessage&infoType=All&MobileUdid=%@",mobile.deviceName];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *result in responseObject)
        {
            Message *msg = [[Message alloc] init];
            msg.messageID = [result objectForKey:@"ID"];
            msg.messageBody = [result objectForKey:@"Message"];
            msg.messageTime = [result objectForKey:@"CreateTime"];
            msg.messageType = [result objectForKey:@"Category"];
                        
            
            [_messages addObject:msg];
        }
        
        [self.messageTable reloadData];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idetifier = @"MessageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    
    NSInteger row = [indexPath row];
    
    Message *msg = _messages[row];
    
    UILabel* messageTypeLabel = (UILabel *)[cell.contentView viewWithTag:3];
    messageTypeLabel.text =  msg.messageType;
    
    if([messageTypeLabel.text isEqual: @"DEBUG"])
    {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    if([messageTypeLabel.text isEqual: @"INFO"])
    {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    if([messageTypeLabel.text isEqual: @"WARN"])
    {
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    if([messageTypeLabel.text isEqual: @"VERBOSE"])
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if([messageTypeLabel.text isEqual: @"ERROR"])
    {
        cell.backgroundColor = [UIColor redColor];
    }
    
    UILabel* messageBodyLabel = (UILabel *)[cell.contentView viewWithTag:4];
    messageBodyLabel.text = msg.messageBody;
    
    
    [cell setUserInteractionEnabled:YES];
    
    return cell;
    
}

-(void)GetImageSource
{

    NSString* url = [NSString stringWithFormat:@"http://192.168.43.202/Pages/H5/Data.ashx?type=GetImageSource&MobileUdid=%@",mobile.deviceName];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString * aStr;
    aStr = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    
    if([lastImageAddress isEqual: @""])
    {
        lastImageAddress = aStr;
        
        UIImageView *currentImage = (UIImageView *)[self.view viewWithTag:10];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: aStr]]];
        currentImage.image = image;

    }
    else if([lastImageAddress isEqual:aStr])
    {
        
    }
    else
    {
        UIImageView *preImage = (UIImageView *)[self.view viewWithTag:11];
        UIImage *imagePRE = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: lastImageAddress]]];
        preImage.image = imagePRE;
        
        UIImageView *currentImage = (UIImageView *)[self.view viewWithTag:10];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: aStr]]];
        currentImage.image = image;
        
        lastImageAddress = aStr;

    }
    
    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = [indexPath row];
    //[self performSegueWithIdentifier:@"MobileMonitor" sender:self];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

-(void)StartGetImageAndMessage
{
    

}


- (IBAction)selectBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end