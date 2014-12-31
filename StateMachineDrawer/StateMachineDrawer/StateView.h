//
//  StateView.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateMachineComponentView.h"
#import "State.h"

@interface StateView : StateMachineComponentView

-(void)setSMstate:(State*)SMstate; //Update the stateView by changing it's state

@property(nonatomic) State *SMstate;

@end

#warning PUT THIS INSIDE THE TRANSITION VIEW IMPLEMENTATION FILE

/*
 //Lazy load the stateObserver
 -(StateObserver *)stateObserver
 {
 
 if(!_stateObserver) {
 _stateObserver = [[StateObserver alloc] initWithDelegate:self fieldsToObserve:@[@"frame",@"color"]];
 }
 return _stateObserver;
 
 }
 
 -(void)stateDidChange:(State *)state {
 
 if([state isEqual:self.fromState]) {
 //From state has changed
 self.fromState = state;
 }
 else {
 //To state has changed
 self.toState = state;
 }
 [self setNeedsDisplay];
 
 }
 */
