//
//  TransitionView.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/29/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "TransitionView.h"
#import "StateObserver.h"

@interface TransitionView ()

@property(nonatomic)StateObserver *stateObserver;

@end

@implementation TransitionView

//Update the transitionView by changing it's transition
-(void)setTransition:(Transition*)transition {

    [self.stateObserver add:NO observersForTransition:self.transition];
    _transition = transition;
    [self.stateObserver add:YES observersForTransition:self.transition];
    
}

#pragma mark - private methods

//Lazy load the stateObserver
-(StateObserver *)stateObserver
{
    
    if(!_stateObserver) {
        _stateObserver = [[StateObserver alloc] initWithTarget:self];
    }
    return _stateObserver;
    
}

//Cleanup observation stuff
-(void)dealloc
{
    
    [self.stateObserver add:NO observersForTransition:self.transition];
    
}

@end
