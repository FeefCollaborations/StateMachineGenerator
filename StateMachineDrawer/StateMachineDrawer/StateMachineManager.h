//
//  StateMachineManager.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "UniqueIDModelManager.h"
#import "StateMachine.h"

@interface StateMachineManager : UniqueIDModelManager

-(void)writeToLocalStorage;
-(StateMachine*)stateMachineForID:(NSString*)id;

@end
