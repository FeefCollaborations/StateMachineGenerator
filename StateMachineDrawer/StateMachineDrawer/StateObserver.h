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

@protocol StateObserverDelegate <NSObject>

-(void)stateDidChange:(State*)state;

@end

@interface StateObserver : NSObject

-(instancetype)initWithDelegate:(id<StateObserverDelegate>)delegate;
-(void)add:(BOOL)add observersForState:(State*)state;
-(void)add:(BOOL)add observersForTransition:(Transition*)transition;

@property(nonatomic,weak)id delegate;

@end
