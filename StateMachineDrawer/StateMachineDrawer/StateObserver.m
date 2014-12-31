//
//  StateObserver.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/29/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateObserver.h"

#define OBSERVANCE_KEYS @[@"frame",@"color",@"markedForDeletion"]

@implementation StateObserver

-(instancetype)initWithDelegate:(id<StateObserverDelegate>)delegate {

    self = [super init];
    if(self) {
        _delegate = delegate;
    }
    return self;
    
}

//Add or remove relevant observance keys for given state
-(void)add:(BOOL)add observersForState:(State*)state {
    
    if(!state)
        return;
    
    for (NSString *observanceKey in OBSERVANCE_KEYS) {
        
        if(add) {
            
            [state addObserver:self forKeyPath:observanceKey options:0 context:NULL];
            
        } else {
            
            [state removeObserver:self forKeyPath:observanceKey];
            
        }
        
    }
    
}

-(void)add:(BOOL)add observersForTransition:(Transition*)transition {
    
    if(!transition)
        return;
    
    [self add:add observersForState:transition.fromState];
    [self add:add observersForState:transition.toState];
    
}

#pragma mark - private methods

//Respond to change in frame or color of state
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if(_delegate && [_delegate respondsToSelector:@selector(stateDidChange:)]) {
        [_delegate stateDidChange:object];
    }
    
}

@end
