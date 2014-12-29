//
//  Transition.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "Transition.h"

@interface Transition ()

@property(nonatomic,readwrite)State *fromState;
@property(nonatomic,readwrite)State *toState;

@end

@implementation Transition

-(instancetype)initWithFromState:(State *)fState toState:(State *)tState {
    
    self = [super init];
    if(self) {
        
        _fromState = fState;
        _toState = tState;
        
    }
    return self;
    
}

@end
