//
//  Transition.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@protocol Transition <NSObject>
@end

@interface Transition : NSObject

-(instancetype)initWithFromState:(State*)fState toState:(State*)tState;

@property(nonatomic,readonly)State *fromState;
@property(nonatomic,readonly)State *toState;
@property(nonatomic,readonly)CGRect frame;
@property(nonatomic)NSString *title;
@property(nonatomic)UIColor *color;

@end
