//
//  SMHelperFunctions.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/2/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMHelperFunctions : NSObject

+(NSArray*)archiveDatasOfObjects:(NSArray*)objects;
+(NSArray*)unarchiveArrayOfObjectsFromDataArray:(NSArray*)objectDatas;

@end
