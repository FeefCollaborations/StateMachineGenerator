//
//  StateView.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateView.h"
#import "StateObserver.h"

@interface StateView ()

@property(nonatomic)StateObserver *stateObserver;

@end

@implementation StateView

-(instancetype)initWithTarget:(id)target selector:(SEL)selector {
    
    self = [super init];
    if(self) {
        
        [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
    
}

//Update the stateView by changing it's state
-(void)setSMstate:(State *)SMstate {
    
    [self.stateObserver add:NO observersForState:self.SMstate];
    _SMstate = SMstate;
    self.frame = self.SMstate.frame;
    [self.stateObserver add:YES observersForState:self.SMstate];
    
}

//update the frame of the stateView and call "updateView" to draw the bezier path the first time
-(void)setFrame:(CGRect)frame
{
    
    [super setFrame:frame];
    if(!CGRectEqualToRect(self.frame, CGRectZero)) {
        [self updateView];
    }
    
}

//
-(void)updateView {
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    
    CGRect frame = self.frame;
    frame.origin = CGPointZero;
    self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    [self.strokeColor setStroke];
    [self.bezierPath stroke];
    
    [self setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    
    UIGraphicsEndImageContext();
    
    [self setTitleColor:self.strokeColor forState:UIControlStateNormal];
    [self setTitle:self.SMstate.title forState:UIControlStateNormal];
    
}

#pragma mark - private methods

//Lazy load the stateObserver
-(StateObserver *)stateObserver
{
    
    if(!_stateObserver) {
        _stateObserver = [[StateObserver alloc] initWithTarget:self];
    }
    return _stateObserver;
    
}

//Cleanup observation stuff
-(void)dealloc
{
    
    [self.stateObserver add:NO observersForState:self.SMstate];
    
}

@end
