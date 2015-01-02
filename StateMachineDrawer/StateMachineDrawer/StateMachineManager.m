//
//  StateMachineManager.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateMachineManager.h"
#import "SMHelperFunctions.h"

#define STATE_MACHINE_LOCAL_STORAGE_KEY @"stateMachineLocalStorage3"

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
    
    [[NSUserDefaults standardUserDefaults] setObject:[SMHelperFunctions archiveDatasOfObjects:self.models.allValues] forKey:STATE_MACHINE_LOCAL_STORAGE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//Return the state with the provided id
-(StateMachine*)stateMachineForID:(NSString*)id {
    
    return (StateMachine*)[self.models objectForKey:id];
    
}

#pragma mark - private methods

-(NSArray<UniqueIDModel>*)readFromLocalStorage {
    
    return (NSArray<UniqueIDModel>*)[SMHelperFunctions unarchiveArrayOfObjectsFromDataArray:[[NSUserDefaults standardUserDefaults] objectForKey:STATE_MACHINE_LOCAL_STORAGE_KEY]];
    
}

@end
