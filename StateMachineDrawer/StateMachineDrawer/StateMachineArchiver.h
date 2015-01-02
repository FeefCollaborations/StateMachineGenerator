//
//  StateMachineArchiver.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface StateMachineArchiver : NSObject

+ (StateMachineArchiver*)sharedInstance;

-(NSArray*)archivedStateMachines;
-(void)archiveStateMachineWithStates:(NSArray<State>*)states title:(NSString*)title;

@end
