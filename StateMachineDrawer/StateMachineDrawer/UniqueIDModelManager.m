//
//  StateIDManager.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "UniqueIDModelManager.h"

@implementation UniqueIDModelManager

//A singleton UniqueModelIDManager
+(instancetype)sharedInstance {
    [NSException raise:@"Subclassing error" format:@"Subclasses must override the %s method", __FUNCTION__];
    return nil;
}

//A new modelID that can be used by a newly created model
-(NSString*)safeModelID {
    
    //Generate a new stateID by generating a random number and checking that the string value of that number isn't present in the current state dictionary
    u_int32_t rand = arc4random();
    while([self.models objectForKey:[self keyFromUInt32:rand]]) {
        rand++;
    }
    return [self keyFromUInt32:rand];
    
}

//Remove all current models from models dictionary and add given models
-(void)setupWithModelArray:(NSArray<UniqueIDModel>*)modelArray{
    
    [self.models removeAllObjects];
    for (UniqueIDModel *model in modelArray) {
        [self addModel:model];
    }
    
}

//Add a model to the current model dictionary
-(void)addModel:(UniqueIDModel*)model {

    [self.models setObject:model forKey:model.id];

}

//Remove a model from the current model dictionary
-(void)removeModel:(UniqueIDModel*)model {

    [self removeModelWithID:model.id];

}

//Remove a model with the given ID from the current model dictionary
-(void)removeModelWithID:(NSString*)modelID {
    
    [self.models removeObjectForKey:modelID];
    
}

//Return the model with the provided id
-(UniqueIDModel*)modelForID:(NSString*)id {

    return [self.models objectForKey:id];

}

//Array of all models currently in the manager
-(NSArray*)allModels {
    
    return [self.models allValues];
    
}


#pragma private methods

//create a key from the given u_int32_t
-(NSString*)keyFromUInt32:(u_int32_t)number {
    
    return [NSString stringWithFormat:@"%u",number];
    
}

//Lazy load states
-(NSMutableDictionary *)models
{
    if(!_models) {
        _models = [[NSMutableDictionary alloc] init];
    }
    return _models;
}

@end
