//
//  StateObserver.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/29/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateMachineComponentView.h"
#import "State.h"
#import "Transition.h"

@interface StateObserver : NSObject

-(instancetype)initWithTarget:(StateMachineComponentView*)target;
-(void)add:(BOOL)add observersForState:(State*)state;
-(void)add:(BOOL)add observersForTransition:(Transition*)transition;

@end
