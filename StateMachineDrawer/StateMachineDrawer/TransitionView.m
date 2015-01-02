//
//  TransitionView.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/29/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "TransitionView.h"
#import "StateObserver.h"

@interface TransitionView ()

//@property(nonatomic)StateObserver *stateObserver;

@end

@implementation TransitionView

//Update the transitionView by changing it's transition
-(void)setTransition:(Transition*)transition {
    
    //[self.stateObserver add:NO observersForTransition:self.transition];
    _transition = transition;
    //[self.stateObserver add:YES observersForTransition:self.transition];
    self.frame = _transition.frame;
    
}

#pragma mark - private methods
/*
 //Lazy load the stateObserver
 -(StateObserver *)stateObserver
 {
 
 if(!_stateObserver) {
 _stateObserver = [[StateObserver alloc] initWithTarget:self];
 }
 return _stateObserver;
 
 }
 */

-(void)updateView {
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    
    NSLog(@"transition view draw rect");
    
    //  CGRect frame = self.frame;
    //frame.origin = CGPointZero;
    self.bezierPath = [UIBezierPath bezierPath];
    [self.bezierPath moveToPoint:CGPointZero];
    NSLog(@"bezier frame is %@, transition frame is %@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.transition.frame));
    [self.bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)
                            controlPoint:CGPointMake(self.frame.size.width, 0)];
    //[self.strokeColor setStroke];
    [self.bezierPath stroke];
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

//Cleanup observation stuff
-(void)dealloc
{
    
    //[self.stateObserver add:NO observersForTransition:self.transition];
    
}

@end
