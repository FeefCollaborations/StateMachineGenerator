//
//  StateManager.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateManager.h"

@implementation StateManager

//A singleton StateManager
+(instancetype)sharedInstance {
    static dispatch_once_t  onceToken;
    static StateManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[StateManager alloc] init];
    });
    
    return sSharedInstance;
}

//Return the state with the provided id
-(State*)stateForID:(NSString*)id {
    
    return (State*)[self.models objectForKey:id];
    
}

@end
