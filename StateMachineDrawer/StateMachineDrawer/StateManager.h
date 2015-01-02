//
//  StateManager.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "UniqueIDModelManager.h"
#import "State.h"

@interface StateManager : UniqueIDModelManager

-(State*)stateForID:(NSString*)id;

@end
