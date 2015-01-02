//
//  UniqueIDModel.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniqueIDModelManagerProtocol.h"

@protocol UniqueIDModel <NSObject>
@end

@interface UniqueIDModel : NSObject <NSCoding>

-(instancetype)initWithUniqueModelIDManager:(id<UniqueIDModelManagerProtocol>)manager;

@property(nonatomic)NSString *id;

@end