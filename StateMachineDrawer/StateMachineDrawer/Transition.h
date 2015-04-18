//
//  Transition.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Transition <NSObject>
@end

@interface Transition : NSObject <NSCoding>

-(instancetype)initWithFromStateID:(NSString*)fStateID toStateID:(NSString*)tStateID;
-(void)updateTransitionFrame;
-(void)deleteTransition;
-(void)toggleMarkForUpdate;

@property(nonatomic,readonly)NSString *fromStateID;
@property(nonatomic,readonly)NSString *toStateID;
@property(nonatomic,readonly)CGRect frame;
@property(nonatomic,readonly)CGPoint fromPoint;
@property(nonatomic,readonly)CGPoint toPoint;
@property(nonatomic)NSString *title;
@property(nonatomic)UIColor *color;

-(BOOL)isRightArrow;
-(int)arrowDirection;
-(BOOL)isMarkedForUpdate;

@end
