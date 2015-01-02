//
//  Transition.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "Transition.h"
#import "StateManager.h"

@interface Transition ()

@property(nonatomic,weak,readwrite)State *fromState;
@property(nonatomic,weak,readwrite)State *toState;

@end

@implementation Transition

bool isRightArrow;

enum {
    kTopOfRect,
    kBottomOfRect,
    kLeftOfRect,
    kRightOfRect
};

-(instancetype)initWithFromState:(State *)fState toState:(State *)tState {
    
    self = [super init];
    if(self) {
        
        _fromState = fState;
        _toState = tState;
        isRightArrow = true;
        [self findEndPoints];
        
    }
    return self;
    
}

-(float)distanceFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    
    float a = from.x - to.x;
    float b = from.y - to.y;
    
    float distance = sqrtf(a*a + b*b);
    
    return distance;
    
}

-(CGPoint)setFromPointFromInt:(int)rectSide {
    
    CGPoint fromPoint = CGPointMake(0, 0);
    
    switch (rectSide) {
        case kTopOfRect:
            //Top of the rect
            fromPoint.x = _fromState.center.x;
            fromPoint.y = _fromState.center.y - (_fromState.frame.size.height / 2);
            break;
        case kBottomOfRect:
            //Bottom of the rect
            fromPoint.x = _fromState.center.x;
            fromPoint.y = _fromState.center.y + (_fromState.frame.size.height / 2);
            break;
        case kLeftOfRect:
            //Left of the rect
            fromPoint.x = _fromState.center.x - (_fromState.frame.size.width / 2);
            fromPoint.y = _fromState.center.y;
            break;
        case kRightOfRect:
            fromPoint.x = _fromState.center.x + (_fromState.frame.size.width / 2);
            fromPoint.y = _fromState.center.y;
            break;
            
        default:
            break;
    }
    
    return fromPoint;
}

-(CGPoint)setToPointFromInt:(int)rectSide {
    
    CGPoint toPoint = CGPointMake(0, 0);
    
    switch (rectSide) {
        case kTopOfRect:
            //Top of the rect
            toPoint.x = _toState.center.x;
            toPoint.y = _toState.center.y - (_toState.frame.size.height / 2);
            break;
        case kBottomOfRect:
            //Bottom of the rect
            toPoint.x = _toState.center.x;
            toPoint.y = _toState.center.y + (_toState.frame.size.height / 2);
            break;
        case kLeftOfRect:
            //Left of the rect
            toPoint.x = _toState.center.x - (_toState.frame.size.width / 2);
            toPoint.y = _toState.center.y;
            break;
        case kRightOfRect:
            toPoint.x = _toState.center.x + (_toState.frame.size.width / 2);
            toPoint.y = _toState.center.y;
            break;
            
        default:
            break;
    }
    
    return toPoint;
}



-(float)distanceFromSide:(int)from toSide:(int)to {
    
    CGPoint fromPoint = [self setFromPointFromInt:from];
    CGPoint toPoint = [self setToPointFromInt:to];
    
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
    
    if (_fromState.center.x > _toState.center.x) {
        isRightArrow = false;
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
    _fromPoint = [self setFromPointFromInt:fromSide];
    _toPoint = [self setToPointFromInt:toSide];
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
        
        _fromState = (State*)[[StateManager sharedInstance] modelForID:[aDecoder decodeObjectForKey:FROM_STATE_ID_KEY]];
        _toState = (State*)[[StateManager sharedInstance] modelForID:[aDecoder decodeObjectForKey:TO_STATE_ID_KEY]];
        _frame = [aDecoder decodeCGRectForKey:FRAME_KEY];
        _fromPoint = [aDecoder decodeCGPointForKey:FROM_POINT_KEY];
        _toPoint = [aDecoder decodeCGPointForKey:TO_POINT_KEY];
        _title = [aDecoder decodeObjectForKey:TITLE_KEY];
        _color = [aDecoder decodeObjectForKey:COLOR_KEY];
        
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_fromState.id forKey:FROM_STATE_ID_KEY];
    [aCoder encodeObject:_toState.id forKey:TO_STATE_ID_KEY];
    [aCoder encodeCGRect:_frame forKey:FRAME_KEY];
    [aCoder encodeCGPoint:_fromPoint forKey:FROM_POINT_KEY];
    [aCoder encodeCGPoint:_toPoint forKey:TO_POINT_KEY];
    [aCoder encodeObject:_title forKey:TITLE_KEY];
    [aCoder encodeObject:_color forKey:COLOR_KEY];

    
}

@end
