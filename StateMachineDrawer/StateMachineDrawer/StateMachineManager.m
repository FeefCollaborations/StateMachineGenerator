//
//  StateMachineManager.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateMachineManager.h"

#define STATE_MACHINE_LOCAL_STORAGE_KEY @"stateMachineLocalStorage"

@implementation StateMachineManager

//A singleton StateMachineManager
+(instancetype)sharedInstance {
    static dispatch_once_t  onceToken;
    static StateMachineManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[StateMachineManager alloc] init];
        [sSharedInstance setupWithModelArray:[sSharedInstance readFromLocalStorage]];
    });
    
    return sSharedInstance;
}

-(void)writeToLocalStorage {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.models forKey:STATE_MACHINE_LOCAL_STORAGE_KEY];
    
}

#pragma mark - private methods

-(NSArray<UniqueIDModel>*)readFromLocalStorage {
    
    return (NSArray<UniqueIDModel>*)[[NSUserDefaults standardUserDefaults] objectForKey:STATE_MACHINE_LOCAL_STORAGE_KEY];
    
}

@end
