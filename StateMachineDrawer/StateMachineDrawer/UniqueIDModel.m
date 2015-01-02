//
//  UniqueIDModel.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "UniqueIDModel.h"

@implementation UniqueIDModel

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if(self) {
        
        _id = [aDecoder decodeObjectForKey:@"id"];
        
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_id forKey:@"id"];
    
}

-(instancetype)initWithUniqueModelIDManager:(id<UniqueIDModelManagerProtocol>)manager {
    
    self = [super init];
    if(self) {
        
        _id = [manager safeModelID];
        
    }
    return self;
    
}



@end
