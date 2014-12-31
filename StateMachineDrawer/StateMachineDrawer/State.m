//
//  State.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "State.h"
#import "StateManager.h"
#import "Transition.h"

#define BOUNDARY_INSET 30

@interface State ()

@property(nonatomic, readwrite) NSString *id;
@property(nonatomic, readwrite) CGRect frame;
@property(nonatomic) NSMutableDictionary <Transition>*transitions;

@end

@implementation State

//create a new state around a center location
-(instancetype)initWithCenter:(CGPoint)center {
    self = [super init];
    if(self) {
        
        _center = center;
        _id = [[StateManager sharedInstance] safeStateID];
        _title = _id;
        _color = [UIColor blackColor];
        [self updateFrame];
        
    }
    return self;
}

//delete the state and all it's transitions
-(void)deleteState {
    
    self.markedForDeletion = YES;
    
    [[StateManager sharedInstance] removeState:self];
    
    for (Transition *transition in self.transitions.allValues) {
        
        //[transition deleteTransition];
        
    }
    
    //Send notification so all states with transitions heading to this state will be deleted
    [[NSNotificationCenter defaultCenter] postNotificationName:STATE_DELETED_NOTIFICATION_KEY object:self.id];
    
}

//recalculate the frame to surround the state's text with proper inset and distance away from all other states
-(void)updateFrame {
    
    self.frame = [self frameForTitle:self.title andCenter:self.center];
    
}

//add a transition to another state
-(void)addTransitionToState:(State*)state {
    
    Transition *transition = [[Transition alloc] initWithFromState:self toState:state];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievedStateDeletionNotification:) name:STATE_DELETED_NOTIFICATION_KEY object:state];
    [self.transitions setObject:transition forKey:state.id];
    
}

//rename a state, will also call updateFrame
-(void)setTitle:(NSString*)title {
    
    _title = title;
    [self updateFrame];
    
}

//recolor a state
-(void)setColor:(UIColor*)color {
    
    _color = color;
    
}

//move a state
-(void)setCenter:(CGPoint)center {
    
    _center = center;
    [self updateFrame];
    
}

#pragma mark - private methods

#pragma mark - frame calculation

//return a frame given a title and center
-(CGRect)frameForTitle:(NSString*)title andCenter:(CGPoint)center {
    
    CGSize minSize = [self minSizeForTitle:title];
    
    CGRect frame;
    frame.size = minSize;
    frame.origin = CGPointMake(center.x - minSize.width / 2, center.y - minSize.height / 2);
    
    return frame;
    
}

//calculate and return the minimum frame to surround a given title
-(CGSize)minSizeForTitle:(NSString*)title {
    
    return CGRectInset([title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:nil context:0], -BOUNDARY_INSET, -BOUNDARY_INSET).size;
   
}

#pragma mark - notificaiton response

//Respond to state deletion notification
-(void)recievedStateDeletionNotification:(NSNotification*)notification {
    
    Transition *transition = [self.transitions objectForKey:notification.object];
    if(transition) {
        
        //[transition deleteTransition];
        [self.transitions removeObjectForKey:notification.object];
        
    }
    
}

//Clean up observer stuff
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
