//
//  ViewController.m
//  MobileWatch
//
//  Created by Ctrip on 14-8-28.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import "ViewController.h"
#import "MobileCell.h"
#import "DetailController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *wholeString;
@end


@implementation ViewController

@synthesize button1;
@synthesize selectBtn;
@synthesize myPickerView;
@synthesize myPickerData;
@synthesize myMobileData;
@synthesize collectionMain;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.collectionMain registerClass:[MobileCell class] forCellWithReuseIdentifier:@"MobileCell"];
    
    
    [self getBrandFromDB];

    self.myPickerView.hidden = TRUE;
    self.selectBtn.hidden = TRUE;
    self.collectionMain.hidden = TRUE;
    
    
}


- (IBAction)selectBrand:(id)sender {
    NSInteger row = [myPickerView selectedRowInComponent:0];
    NSString *selected = [myPickerData objectAtIndex:row];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    NSString* url = [[NSString alloc] initWithFormat:@"http://192.168.43.202/Pages/H5/Data.ashx?type=GetMobileFromBrand&brand=%@",selected];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *result in responseObject)
        {
            NSString * deviceType = [result objectForKey:@"DeviceType"];
            NSString * deviceImage = [result objectForKey:@"Image"];
            NSString * fenhao = @";";
            NSString * temp = [[deviceType stringByAppendingString:fenhao] stringByAppendingString:deviceImage];
            
            [list addObject:temp];
        }
        
        self.myMobileData = list;
        [collectionMain reloadData];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    self.myPickerView.hidden = TRUE;
    self.selectBtn.hidden = TRUE;
    self.collectionMain.hidden = FALSE;

    
}
- (IBAction)OpenBrand:(id)sender {
    
     self.myPickerView.hidden = FALSE;
     self.selectBtn.hidden = FALSE;
     self.collectionMain.hidden = TRUE;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [myPickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [myPickerData objectAtIndex:row];
}

-(void) getBrandFromDB
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSMutableSet *jsonAcceptableContentTypes = [NSMutableSet setWithSet:jsonResponseSerializer.acceptableContentTypes];
    [jsonAcceptableContentTypes addObject:@"text/html"];
    jsonResponseSerializer.acceptableContentTypes = jsonAcceptableContentTypes;
    manager.responseSerializer = jsonResponseSerializer;
    NSString* url = [NSString stringWithFormat:@"http://192.168.43.202/Pages/H5/Data.ashx?type=GetBrand"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *result in responseObject)
        {
            NSString * temp = [result objectForKey:@"GroupName"];
            [list addObject:temp];
        }
        
        self.myPickerData = list;
        [myPickerView reloadAllComponents];
        
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [myMobileData count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MobileCell *cell = (MobileCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MobileCell" forIndexPath:indexPath];
    
    NSArray *temp = [[self.myMobileData objectAtIndex:indexPath.row] componentsSeparatedByString:@";"];
    
    cell.imageView.image = [UIImage imageNamed:temp[1]];
    cell.imageLabel.text = temp[0];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *temp = [[self.myMobileData objectAtIndex:indexPath.row] componentsSeparatedByString:@";"];
    _wholeString = temp[0];
    
    
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *idetifier = segue.identifier;
    
    if ([idetifier isEqualToString:@"DetailSegue"]) {
        DetailController *detail = segue.destinationViewController;
        detail.tempLabelTEXT = _wholeString;
    }
}


@end
