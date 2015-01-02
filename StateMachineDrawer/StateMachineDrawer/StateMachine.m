//
//  StateMachine.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateMachine.h"
#import "StateMachineManager.h"

@implementation StateMachine

-(instancetype)initWithTitle:(NSString*)title stateViews:(NSArray<StateView>*)stateViews {

    self = [super initWithUniqueModelIDManager:[StateMachineManager sharedInstance]];
    if(self) {
        
        _title = title;
        NSMutableArray *states = [[NSMutableArray alloc] init];
        for (StateView *stateView in stateViews) {
            [states addObject:stateView.SMstate];
        }
        _states = [states copy];
        
    }
    return self;
    
}

@end
