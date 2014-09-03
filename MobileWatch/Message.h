//
//  Message.h
//  MobileWatch
//
//  Created by Ctrip on 14-9-2.
//  Copyright (c) 2014年 T&C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *messageID;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic) NSString *messageTime;
@property (strong, nonatomic) NSString *messageBody;

@end
