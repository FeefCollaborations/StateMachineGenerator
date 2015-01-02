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
    
    NSMutableArray *archivedObjects = [[NSMutableArray alloc] init];
    for (StateMachine *sm in self.models) {
        [archivedObjects addObject:[NSKeyedArchiver archivedDataWithRootObject:sm]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:archivedObjects forKey:STATE_MACHINE_LOCAL_STORAGE_KEY];
    
}

#pragma mark - private methods

-(NSArray<UniqueIDModel>*)readFromLocalStorage {
    
    return nil;
    
    NSMutableArray *stateMachines = [[NSMutableArray alloc] init];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:STATE_MACHINE_LOCAL_STORAGE_KEY];
    for (NSData *objectData in array) {
        [stateMachines addObject:[NSKeyedUnarchiver unarchiveObjectWithData:objectData]];
    }
    
    return (NSArray<UniqueIDModel>*)stateMachines;
    
}

@end
