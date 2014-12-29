//
//  StateIDManager.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateManager.h"

@interface StateManager ()

@property(nonatomic) NSMutableDictionary *states;

@end

@implementation StateManager

//A singleton StateIDManager
+ (StateManager*)sharedInstance
{
    static dispatch_once_t  onceToken;
    static StateManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[StateManager alloc] init];
    });
    
    return sSharedInstance;
}

//A new stateID that can be used by a newly created state
-(NSString*)safeStateID {
    
    //Generate a new stateID by generating a random number and checking that the string value of that number isn't present in the current state dictionary
    u_int32_t rand = arc4random();
    while([self.states objectForKey:[self keyFromUInt32:rand]]) {
        rand++;
    }
    return [self keyFromUInt32:rand];
    
}

//Remove all current states from state dictionary and add given states
-(void)setupWithStateArray:(NSArray*)stateArray {
    
    [self.states removeAllObjects];
    for (State *state in stateArray) {
        [self addState:state];
    }
    
}

//Add a state to the current state dictionary
-(void)addState:(State*)state {
    
    [self.states setObject:state forKey:state.id];
    
}

//Remove a state to the current state dictionary
-(void)removeState:(State*)state {
    
    [self.states removeObjectForKey:state.id];
    
}

//Return the state with the provided id
-(State*)stateForID:(NSString*)id {
    
    return [self.states objectForKey:id];
    
}

#pragma private methods

//create a key from the given u_int32_t
-(NSString*)keyFromUInt32:(u_int32_t)number {
    
    return [NSString stringWithFormat:@"%u",number];
    
}

//Lazy load states
-(NSMutableDictionary *)states
{
    if(!_states) {
        _states = [[NSMutableDictionary alloc] init];
    }
    return _states;
}

@end
