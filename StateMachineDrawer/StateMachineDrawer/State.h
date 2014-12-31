//
//  State.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#define STATE_DELETED_NOTIFICATION_KEY @"stateDeletedNotificaitonKey"

#import <UIKit/UIKit.h>

@protocol State <NSObject>
@end

@interface State : NSObject

-(instancetype)initWithCenter:(CGPoint)center; //create a new state around a center location
-(void)deleteState; //delete the state and all it's transitions
-(void)updateFrame; //recalculate the frame to surround the state's text with proper inset and distance away from all other states
-(void)addTransitionToState:(State*)state;
-(void)setTitle:(NSString*)title; //rename a state, will also call updateFrame
-(void)setColor:(UIColor*)color; //recolor a state
-(void)setCenter:(CGPoint)center; //move a state

@property(nonatomic, readonly) NSString *id;
@property(nonatomic, readonly) CGRect frame;
@property(nonatomic) CGPoint center;
@property(nonatomic) UIColor *color;
@property(nonatomic) NSString *title;
@property BOOL markedForDeletion;

@end