//
//  TransitionView.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/29/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateMachineComponentView.h"
#import "Transition.h"

@interface TransitionView : StateMachineComponentView

-(void)setTransition:(Transition*)transition; //Update the transitionView by changing it's transition

@property(nonatomic)Transition *transition;

@end
