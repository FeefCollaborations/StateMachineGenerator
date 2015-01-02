//
//  StateMachineArchiver.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateMachineArchiver.h"

@implementation StateMachineArchiver

//A singleton StateIDManager
+ (StateMachineArchiver*)sharedInstance
{
    static dispatch_once_t  onceToken;
    static StateMachineArchiver * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[StateMachineArchiver alloc] init];
    });
    
    return sSharedInstance;
}

@end
