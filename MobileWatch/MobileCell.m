//
//  MobileCell.m
//  MobileWatch
//
//  Created by Ctrip on 14-8-28.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import "MobileCell.h"

@implementation MobileCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MobileCell" owner:self options: nil];
               if(arrayOfViews.count < 1){return nil;}
               if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
                        return nil;
        }
                self = [arrayOfViews objectAtIndex:0];
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
