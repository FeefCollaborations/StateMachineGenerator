//
//  ViewController.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/28/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "ViewController.h"
#import "StateView.h"
#import "TransitionView.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property(nonatomic)StateView *selectedStateView;
@property(nonatomic)NSMutableArray *stateViews;
@property BOOL panSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressRecognized:)];
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];

    lpgr.delegate = self;
    
    [self.view addGestureRecognizer:lpgr];
    [self.view addGestureRecognizer:tgr];
    [self.view addGestureRecognizer:pgr];
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        [self deselectSelectedStateView];
        self.selectedStateView = [StateView new];
        [self.selectedStateView addTarget:self action:@selector(pressedDownOnStateView:) forControlEvents:UIControlEventTouchDown];
        [self.selectedStateView addTarget:self action:@selector(pressedUpOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedStateView setSMstate:[[State alloc] initWithCenter:[gestureRecognizer locationInView:self.view]]];
        [self.view addSubview:self.selectedStateView];
        [self.stateViews addObject:self.selectedStateView];
    }
    return YES;
    
}

-(void)pressedDownOnStateView:(StateView*)stateView {
    
    if([stateView isEqual:self.selectedStateView]) {
        
        self.panSelected = YES;
        
    }
    
}

-(void)pressedUpOnViewButton:(StateView*)stateView {
    
    [self deselectSelectedStateView];
    self.selectedStateView = stateView;
    stateView.strokeColor = [UIColor blueColor];
    
}

-(void)deselectSelectedStateView {
    
    if(self.selectedStateView) {
        
        [self.selectedStateView setStrokeColor:[UIColor blackColor]];
        self.selectedStateView = nil;
        self.panSelected = NO;
        
    }
    
}

-(void)longPressRecognized:(UILongPressGestureRecognizer*)lpgr {
    
    self.selectedStateView.SMstate.center = [lpgr locationInView:self.view];
    
}

-(void)tapPressRecognized:(UITapGestureRecognizer*)tgr {
    
    [self deselectSelectedStateView];
    
}

-(void)panRecognized:(UIPanGestureRecognizer*)pgr {
    
    if(self.panSelected) {
        
        self.selectedStateView.SMstate.center = [pgr locationInView:self.view];
        
    }
    
}

@end
