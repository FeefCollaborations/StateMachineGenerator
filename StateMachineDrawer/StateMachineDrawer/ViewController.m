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
#import "SMBubbleMenuButton.h"
#import "StateMachineManager.h"
#import "TextInputAlertView.h"
#import "StateMachine.h"

#define UNSELECTED_STATE_COLOR [UIColor blackColor]
#define SELECTED_STATE_COLOR [UIColor blueColor]

typedef enum {
    
    StateEditOptionMove,
    StateEditOptionRename,
    StateEditOptionRecolor,
    StateEditOptionDelete
    
} StateEditOption;

@interface ViewController () <UIGestureRecognizerDelegate, UIAlertViewDelegate, SMBubbleMenuButtonDelegate, SDCAlertViewDelegate>

@property(nonatomic)StateView *selectedStateView;
@property(nonatomic)NSMutableArray *stateViews;
@property BOOL panSelected;
@property BOOL pressedInsideState;
@property int createdStatesCount;
@property(nonatomic) StateEditOption currentStateEditOption;
@property(nonatomic) SMBubbleMenuButton *bubbleMenuButton;
@property(nonatomic) TextInputAlertView *saveStateMachineAlertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.createdStatesCount = 0;
    
    SMBubbleMenuButton *menuButton = self.bubbleMenuButton;
    NSLog(@"frame is %@", NSStringFromCGRect(menuButton.frame));
    [self.view addSubview:menuButton];
    
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

-(NSMutableArray *)stateViews
{
    if(!_stateViews)
        _stateViews = [[NSMutableArray alloc] init];
    return _stateViews;
}

-(SMBubbleMenuButton *)bubbleMenuButton
{
    if(!_bubbleMenuButton) {
        _bubbleMenuButton = [[SMBubbleMenuButton alloc] initWithDelegate:self];
    }
    return _bubbleMenuButton;
}

-(void)bubbleMenuSelectedButtonWithType:(SABubbleMenuButtonType)buttonType {
    
    switch (buttonType) {
            
        case SABubbleMenuButtonTypeToggle:
        {
            if(self.bubbleMenuButton.isCollapsed)
                [self.bubbleMenuButton showButtons];
            else
                [self.bubbleMenuButton dismissButtons];
            break;
        }
            
            case SABubbleMenuButtonTypeSave:
        {
            //Save state machine locally
            [self.saveStateMachineAlertView show];
            break;
        }
            case SABubbleMenuButtonTypeLoad:
        {
            //Show prompt to select state machine from saved states
            [self performSegueWithIdentifier:@"ToStateMachinePicker" sender:nil];
            break;
        }
            case SABubbleMenuButtonTypeExportAsPDF:
        {
            //Show prompt to name PDF export
            break;
        }
        case SABubbleMenuButtonTypeDeleteMachine:
        {
            //Delete the state machine from the archiver and start a blank project
            break;
        }
            case SABubbleMenuButtonTypeManageAccount:
        {
            //Show view controller to manage account currently being used
            break;
        }
            
        default:
            break;
    }
    
}

-(TextInputAlertView *)saveStateMachineAlertView {
    
    if(!_saveStateMachineAlertView) {
        _saveStateMachineAlertView = [[TextInputAlertView alloc] initWithTitle:@"Save State Machine" message:@"Name your state machine:" placeholderText:@"My awesome state machine" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    }
    return _saveStateMachineAlertView;
    
}

-(void)alertView:(SDCAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView isEqual:self.saveStateMachineAlertView]) {
        
        if(buttonIndex != alertView.cancelButtonIndex) {
            
            StateMachine *stateMachine = [[StateMachine alloc] initWithTitle:[[self.saveStateMachineAlertView textField] text] stateViews:(NSArray<StateView>*)self.stateViews];
            [[StateMachineManager sharedInstance] addModel:stateMachine];
            
        }
        
    }
    else {
        
        if(buttonIndex != alertView.cancelButtonIndex) {
            
            NSString *pdfTitle = [[self.saveStateMachineAlertView textField] text];
            
        }
        
    }
    
}

@end
