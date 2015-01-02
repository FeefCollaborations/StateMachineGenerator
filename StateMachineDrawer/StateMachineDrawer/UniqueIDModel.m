//
//  UniqueIDModel.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "UniqueIDModel.h"

@implementation UniqueIDModel

-(instancetype)initWithUniqueModelIDManager:(id<UniqueIDModelManagerProtocol>)manager {
    
    self = [super init];
    if(self) {
        
        _id = [manager safeModelID];
        
    }
    return self;
    
}

#pragma mark - NSCoding compliance

#define ID_KEY @"id"

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if(self) {
        
        _id = [aDecoder decodeObjectForKey:ID_KEY];
        
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_id forKey:ID_KEY];
    
}

@end
