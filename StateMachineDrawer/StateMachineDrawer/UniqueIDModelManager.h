//
//  StateIDManager.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniqueIDModel.h"
#import "UniqueIDModelManagerProtocol.h"

@interface UniqueIDModelManager : NSObject <UniqueIDModelManagerProtocol>

+(instancetype)sharedInstance; //A singleton UniqueModelIDManager
-(NSString*)safeModelID; //A new modelID that can be used by a newly created model
-(void)setupWithModelArray:(NSArray<UniqueIDModel>*)modelArray; //Remove all current models from model dictionary and add given models
-(void)addModel:(UniqueIDModel*)model; //Add a model to the current model dictionary
-(void)removeModel:(UniqueIDModel*)model; //Remove a model to the current model dictionary
-(UniqueIDModel*)modelForID:(NSString*)id; //Return the model with the provided id
-(NSArray*)allModels; //Array of all models currently in the manager

@property(nonatomic) NSMutableDictionary *models;

@end
