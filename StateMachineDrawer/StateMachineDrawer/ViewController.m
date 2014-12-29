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
@property(nonatomic)UIButton *backgroundButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.backgroundButton = [[UIButton alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.backgroundButton];
    [self.backgroundButton addTarget:self action:@selector(backgroundButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    lpgr.delegate = self;
    [self.view addGestureRecognizer:lpgr];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    [self deselectSelectedStateView];
    self.selectedStateView = [[StateView alloc] initWithTarget:self selector:@selector(pressedStateViewButton:)];
    [self.selectedStateView setSMstate:[[State alloc] initWithCenter:[gestureRecognizer locationInView:self.view]]];
    [self.view addSubview:self.selectedStateView];
    [self.stateViews addObject:self.selectedStateView];
    return YES;
    
}

-(void)pressedStateViewButton:(StateView*)stateView {
    
    [self deselectSelectedStateView];
    self.selectedStateView = stateView;
    stateView.strokeColor = [UIColor blueColor];
    
}

-(void)backgroundButtonPressed {
    
    [self deselectSelectedStateView];
    
}

-(void)deselectSelectedStateView {
    
    if(self.selectedStateView) {
        [self.selectedStateView setStrokeColor:[UIColor blackColor]];
        self.selectedStateView = nil;
    }
    
}

-(void)longPressRecognized:(UILongPressGestureRecognizer*)lpgr {
    
    self.selectedStateView.SMstate.center = [lpgr locationInView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
