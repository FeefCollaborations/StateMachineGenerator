//
//  Transition.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "Transition.h"
#import "StateManager.h"
#import "State.h"

@interface Transition ()

@end

@implementation Transition

bool isRightArrow;
int arrowDirection;
bool markForUpdate;

typedef enum {
    kTopOfRect,
    kBottomOfRect,
    kLeftOfRect,
    kRightOfRect
}RectSide;

typedef enum {
    kLeftToRightUp = 1,
    kLeftToRightDown,
    kRightToLeftUp,
    kRightToLeftDown
}ArrowDirection;

-(instancetype)initWithFromStateID:(NSString*)fStateID toStateID:(NSString*)tStateID {

    self = [super init];
    if(self) {
        
        _fromStateID = fStateID;
        _toStateID = tStateID;
        isRightArrow = true;
        arrowDirection = 0;
        markForUpdate = true;
        [self findEndPoints];
        [[[StateManager sharedInstance] stateForID:tStateID] addTransitionFromState:self toState:[[StateManager sharedInstance] stateForID:fStateID]];
        
    }
    return self;
    
}

-(void)updateTransitionFrame {
    [self findEndPoints];
    markForUpdate = true;
}

-(void)deleteTransition {
    _frame = CGRectZero;
    _fromPoint = CGPointZero;
    _toPoint = CGPointZero;
    _fromStateID = nil;
    _toStateID = nil;
    _title = nil;
    _color = nil;
}

-(float)distanceFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    
    float a = from.x - to.x;
    float b = from.y - to.y;
    
    float distance = sqrtf(a*a + b*b);
    
    return distance;
    
}

-(CGPoint)pointFromRectSide:(RectSide)rectSide ofStateWithID:(NSString*)stateID {
    
    CGPoint fromPoint = CGPointMake(0, 0);
    
    State *state = [[StateManager sharedInstance] stateForID:stateID];
    
    switch (rectSide) {
        case kTopOfRect:
            //Top of the rect
            fromPoint.x = state.center.x;
            fromPoint.y = state.center.y - (state.frame.size.height / 2);
            break;
        case kBottomOfRect:
            //Bottom of the rect
            fromPoint.x = state.center.x;
            fromPoint.y = state.center.y + (state.frame.size.height / 2);
            break;
        case kLeftOfRect:
            //Left of the rect
            fromPoint.x = state.center.x - (state.frame.size.width / 2);
            fromPoint.y = state.center.y;
            break;
        case kRightOfRect:
            fromPoint.x = state.center.x + (state.frame.size.width / 2);
            fromPoint.y = state.center.y;
            break;
            
        default:
            break;
    }
    
    return fromPoint;
    
}


-(float)distanceFromSide:(int)from toSide:(int)to {
    
    CGPoint fromPoint = [self pointFromRectSide:from ofStateWithID:self.fromStateID];
    CGPoint toPoint = [self pointFromRectSide:to ofStateWithID:self.toStateID];
    
    return [self distanceFromPoint:fromPoint toPoint:toPoint];
}

-(BOOL)distanceShorterFromPoint:(int)a toPoint:(int)b thanPrevious:(float)prev {
    
    float currDistance = [self distanceFromSide:a toSide:b];
    
    if (currDistance < prev) {
        return true;
    }
    return false;
}

-(void)findEndPoints {
    
    float maxDistance = MAXFLOAT;
    int fromSide = 0;
    int toSide = 0;
    
    State *upState = [[StateManager sharedInstance] stateForID:self.fromStateID];
    
    if ([[StateManager sharedInstance] stateForID:self.fromStateID].center.x <= [[StateManager sharedInstance] stateForID:self.toStateID].center.x) {
        
        isRightArrow = true;
        
        if (([[StateManager sharedInstance] stateForID:self.fromStateID].center.y <= [[StateManager sharedInstance] stateForID:self.toStateID].center.y)) {
            arrowDirection = kLeftToRightUp;
        }
        else {
            arrowDirection = kRightToLeftUp;
        }
    }
    else {
        
        isRightArrow = false;
        
        if (([[StateManager sharedInstance] stateForID:self.fromStateID].center.y <= [[StateManager sharedInstance] stateForID:self.toStateID].center.y)) {
            arrowDirection = kRightToLeftDown;
        }
        else {
            arrowDirection = kRightToLeftUp;
        }
    }
    
    
    //Check each side of the rect from each state
    // in no particular order for no particular reason other than
    // the way the enum was written
    for (int i = kTopOfRect; i <= kRightOfRect; i++) {
        for (int j = kTopOfRect; j <= kRightOfRect; j++) {
            if ([self distanceShorterFromPoint:i toPoint:j thanPrevious:maxDistance]) {
                maxDistance = [self distanceFromSide:i toSide:j];
                fromSide = i;
                toSide = j;
            }
        }
    }
    _fromPoint = [self pointFromRectSide:fromSide ofStateWithID:self.fromStateID];
    _toPoint = [self pointFromRectSide:toSide ofStateWithID:self.toStateID];
    [self updateFrame];
    
}

-(void)updateFrame {
    
    float width = abs(_fromPoint.x - _toPoint.x);
    float height = abs(_fromPoint.y - _toPoint.y);
    
    if (isRightArrow) {
        _frame = CGRectMake(_fromPoint.x, _fromPoint.y, width, height);
    }
    else {
        _frame = CGRectMake(_toPoint.x, _toPoint.y, width, height);
    }
    switch (arrowDirection) {
        case kLeftToRightUp:
            _frame = CGRectMake(_fromPoint.x, _fromPoint.y, width, height);
            break;
        case kLeftToRightDown:
            _frame = CGRectMake(_toPoint.x, _toPoint.y, width, height);
            break;
        case kRightToLeftUp:
            _frame = CGRectMake(_fromPoint.x, _toPoint.y, width, height);
            break;
        case kRightToLeftDown:
            _frame = CGRectMake(_toPoint.x, _fromPoint.y, width, height);
            break;
            
        default:
            break;
    }
}

-(BOOL)isRightArrow {
    return isRightArrow;
}

#pragma mark - NSCoding compliance

#define FROM_STATE_ID_KEY @"fromStateID"
#define TO_STATE_ID_KEY @"toStateID"
#define FRAME_KEY @"frame"
#define FROM_POINT_KEY @"fromPoint"
#define TO_POINT_KEY @"toPoint"
#define TITLE_KEY @"title"
#define COLOR_KEY @"color"


-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if(self) {
        
        _fromStateID = [aDecoder decodeObjectForKey:FROM_STATE_ID_KEY];
        _toStateID = [aDecoder decodeObjectForKey:TO_STATE_ID_KEY];
        _frame = [aDecoder decodeCGRectForKey:FRAME_KEY];
        _fromPoint = [aDecoder decodeCGPointForKey:FROM_POINT_KEY];
        _toPoint = [aDecoder decodeCGPointForKey:TO_POINT_KEY];
        _title = [aDecoder decodeObjectForKey:TITLE_KEY];
        _color = [aDecoder decodeObjectForKey:COLOR_KEY];
        
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_fromStateID forKey:FROM_STATE_ID_KEY];
    [aCoder encodeObject:_toStateID forKey:TO_STATE_ID_KEY];
    [aCoder encodeCGRect:_frame forKey:FRAME_KEY];
    [aCoder encodeCGPoint:_fromPoint forKey:FROM_POINT_KEY];
    [aCoder encodeCGPoint:_toPoint forKey:TO_POINT_KEY];
    [aCoder encodeObject:_title forKey:TITLE_KEY];
    [aCoder encodeObject:_color forKey:COLOR_KEY];

    
}

-(int)arrowDirection {
    return arrowDirection;
}

-(void)toggleMarkForUpdate {
    markForUpdate = !markForUpdate;
}

-(BOOL)isMarkedForUpdate {
    return markForUpdate;
}

@end
