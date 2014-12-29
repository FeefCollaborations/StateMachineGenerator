//
//  StateIDManager.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface StateManager : NSObject

+(instancetype)sharedInstance; //A singleton StateIDManager
-(NSString*)safeStateID; //A new stateID that can be used by a newly created state
-(void)setupWithStateArray:(NSArray<State>*)stateArray; //Remove all current states from state dictionary and add given states
-(void)addState:(State*)state; //Add a state to the current state dictionary
-(void)removeState:(State*)state; //Remove a state to the current state dictionary
-(State*)stateForID:(NSString*)id; //Return the state with the provided id

@end
