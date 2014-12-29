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
