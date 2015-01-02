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

#pragma mark - NSCoding compliance

#define STATES_KEY @"states"
#define TITLE_KEY @"title"

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    NSMutableArray *stateDatas = [[NSMutableArray alloc] init];
    for (State *state in self.states) {
        
        [stateDatas addObject:[NSKeyedArchiver archivedDataWithRootObject:state]];
        
    }
    [aCoder encodeObject:stateDatas forKey:STATES_KEY];
    [aCoder encodeObject:self.title forKey:TITLE_KEY];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        NSMutableArray *states = [[NSMutableArray alloc] init];
        NSArray *array = [aDecoder decodeObjectForKey:STATES_KEY];
        for (NSData *data in array) {
            
            [states addObject:data];
            
        }
        
        _states = (NSArray<State>*)states;
        _title = [aDecoder decodeObjectForKey:TITLE_KEY];
        
    }
    return self;
    
}

@end
