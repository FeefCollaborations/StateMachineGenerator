//
//  UniqueIDModelManagerProtocol.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UniqueIDModelManagerProtocol <NSObject>

-(NSString*)safeModelID; //A new modelID that can be used by a newly created model

@end
