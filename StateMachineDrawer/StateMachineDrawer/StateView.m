//
//  StateView.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateView.h"
#import "StateObserver.h"

@interface StateView () <StateObserverDelegate>

@property(nonatomic)StateObserver *stateObserver;
@property(nonatomic)UIColor *priorDrawColor;

@end

@implementation StateView

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

//redraws the bezier path encircling the text, updates the text and stroke color
-(void)updateView {
    
    CGRect frame = self.frame;
    if(!CGSizeEqualToSize(self.SMstate.frame.size,frame.size) || self.SMstate.color != self.priorDrawColor) {

        UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
        
        frame.origin = CGPointZero;
        self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:frame];
        [self.SMstate.color setStroke];
        [self.bezierPath stroke];
        
        [self setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
        
        UIGraphicsEndImageContext();
        
        [self setTitleColor:self.SMstate.color forState:UIControlStateNormal];
        
        self.priorDrawColor = self.SMstate.color;
        
    }
    
    if(![[self titleForState:UIControlStateNormal] isEqualToString:self.SMstate.title]) {
        
        [self setTitle:self.SMstate.title forState:UIControlStateNormal];
        
    }
}

#pragma mark - private methods

//Lazy load the stateObserver
-(StateObserver *)stateObserver
{
    
    if(!_stateObserver) {
        _stateObserver = [[StateObserver alloc] initWithDelegate:self fieldsToObserve:@[@"frame",@"color"]];
    }
    return _stateObserver;
    
}

-(void)stateDidChange:(State *)state {
    
    self.frame = [state frame];
    [self setNeedsDisplay];
    
}

//Cleanup observation stuff
-(void)dealloc
{
    
    [self.stateObserver add:NO observersForState:self.SMstate];
    
}

@end
