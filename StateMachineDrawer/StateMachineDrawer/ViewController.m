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

#define UNSELECTED_STATE_COLOR [UIColor blackColor]
#define SELECTED_STATE_COLOR [UIColor blueColor]

typedef enum {
    
    StateEditOptionMove,
    StateEditOptionRename,
    StateEditOptionRecolor,
    StateEditOptionDelete
    
} StateEditOption;

@interface ViewController () <UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property(nonatomic)StateView *selectedStateView;
@property(nonatomic)NSMutableArray *stateViews;
@property BOOL panSelected;
@property BOOL pressedInsideState;
@property int createdStatesCount;
@property(nonatomic) StateEditOption currentStateEditOption;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.createdStatesCount = 0;
    
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
        if(self.pressedInsideState)
            return NO;
        
        [self deselectSelectedStateView];
        self.selectedStateView = [StateView new];
        [self.selectedStateView addTarget:self action:@selector(pressedDownOnStateView:) forControlEvents:UIControlEventTouchDown];
        [self.selectedStateView addTarget:self action:@selector(pressedUpOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedStateView setSMstate:[[State alloc] initWithCenter:[gestureRecognizer locationInView:self.view]]];
        self.createdStatesCount++;
        self.selectedStateView.SMstate.color = SELECTED_STATE_COLOR;
        self.selectedStateView.SMstate.title = [NSString stringWithFormat:@"state #%i", self.createdStatesCount];
        [self.view addSubview:self.selectedStateView];
        [self.stateViews addObject:self.selectedStateView];
    }
    return YES;
    
}

-(void)pressedDownOnStateView:(StateView*)stateView {
    
    self.pressedInsideState = YES;
    if([stateView isEqual:self.selectedStateView]) {
        
        self.panSelected = YES;
        
    }
    
}

-(void)pressedUpOnViewButton:(StateView*)stateView {
    
    [self deselectSelectedStateView];
    self.selectedStateView = stateView;
    stateView.SMstate.color = SELECTED_STATE_COLOR;
    self.pressedInsideState = NO;
    
}

-(void)deselectSelectedStateView {
    
    if(self.selectedStateView) {
        
        self.selectedStateView.SMstate.color = UNSELECTED_STATE_COLOR;
        self.selectedStateView = nil;
        
    }
    
}

-(void)longPressRecognized:(UILongPressGestureRecognizer*)lpgr {
    
    [self updateSelectedStateViewLocationFromGestureRecognizer:lpgr];
 
    [self updateForStateCompletion:lpgr];

}

-(void)tapPressRecognized:(UITapGestureRecognizer*)tgr {
    
    [self deselectSelectedStateView];
    
    [self updateForStateCompletion:tgr];
    
}

-(void)panRecognized:(UIPanGestureRecognizer*)pgr {
    
    if(self.panSelected) {
        
        [self updateSelectedStateViewLocationFromGestureRecognizer:pgr];
        
    }
    
    [self updateForStateCompletion:pgr];
    
}

-(void)updateSelectedStateViewLocationFromGestureRecognizer:(UIGestureRecognizer*)gr {
    
    self.selectedStateView.SMstate.center = [gr locationInView:self.view];
    
}

-(void)updateForStateCompletion:(UIGestureRecognizer*)gr {
    
    if(gr.state == UIGestureRecognizerStateCancelled ||
       gr.state == UIGestureRecognizerStateEnded ||
       gr.state == UIGestureRecognizerStateFailed) {
        
        //A new state was dropped into the view
        self.pressedInsideState = NO;
        self.panSelected = NO;
        
    }
    
}

-(void)selectedStateEditOptionChanged:(UISegmentedControl*)segmentedControl {
    
    self.currentStateEditOption = (StateEditOption)segmentedControl.selectedSegmentIndex;
    
    if(self.currentStateEditOption == StateEditOptionDelete) {
        
        [[[UIAlertView alloc] initWithTitle:@"Sure?" message:[NSString stringWithFormat:@"You sure you want to delete \"%@\"?", self.selectedStateView.SMstate.title] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil] show];
        
    }
    
}

-(NSMutableArray *)stateViews
{
    if(!_stateViews)
        _stateViews = [[NSMutableArray alloc] init];
    return _stateViews;
}

@end
