//
//  StateMachine.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "UniqueIDModel.h"
#import "StateView.h"

@protocol StateMachine <NSObject>
@end

@interface StateMachine : UniqueIDModel

-(instancetype)initWithTitle:(NSString*)title stateViews:(NSArray<StateView>*)stateViews;

@property(nonatomic)NSArray <State>*states;
@property(nonatomic)NSString *title;

@end
