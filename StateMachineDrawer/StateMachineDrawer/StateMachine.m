//
//  StateMachine.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "StateMachine.h"
#import "StateMachineManager.h"
#import "SMHelperFunctions.h"

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
    [aCoder encodeObject:[SMHelperFunctions archiveDatasOfObjects:self.states] forKey:STATES_KEY];
    [aCoder encodeObject:self.title forKey:TITLE_KEY];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if(self) {
        
        _states = (NSArray<State>*)[SMHelperFunctions unarchiveArrayOfObjectsFromDataArray:[aDecoder decodeObjectForKey:STATES_KEY]];
        _title = [aDecoder decodeObjectForKey:TITLE_KEY];
        
    }
    return self;
    
}

@end
