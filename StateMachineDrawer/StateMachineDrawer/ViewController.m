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
#import "StateToolDrawer.h"
#import "SavedStateMachinesTableViewController.h"

#define UNSELECTED_STATE_COLOR [UIColor blackColor]
#define SELECTED_STATE_COLOR [UIColor blueColor]
#define STATE_MACHINE_PICKER_SEGUE_ID @"ToStateMachinePicker"

typedef enum {
    
    StateEditOptionMove,
    StateEditOptionRename,
    StateEditOptionRecolor,
    StateEditOptionDelete
    
} StateEditOption;

@interface ViewController () <UIGestureRecognizerDelegate, UIAlertViewDelegate, SMBubbleMenuButtonDelegate, SDCAlertViewDelegate, SavedStateMachinesTableViewControllerDelegate, StateToolDrawerDelegate>

@property(nonatomic)StateView *selectedStateView;
@property(nonatomic)StateMachine *stateMachine;
@property(nonatomic)NSMutableArray *stateViews;
@property BOOL panSelected;
@property BOOL pressedInsideState;
@property int createdStatesCount;
@property(nonatomic) StateEditOption currentStateEditOption;
@property(nonatomic) SMBubbleMenuButton *bubbleMenuButton;
@property(nonatomic) TextInputAlertView *saveStateMachineAlertView;
@property(nonatomic) TextInputAlertView *pdfExportAlertView;
@property(nonatomic) UIAlertView *deleteStateMachineAlertView;
@property(nonatomic)StateToolDrawer *toolBox;
@property(nonatomic)NSMutableArray *trasitionViews;
//Trying to add a StateManager to recall the States

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
    
    _toolBox = [[StateToolDrawer alloc] init];
    _toolBox.delegate = self;
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        if(self.pressedInsideState)
            return NO;
        
        [self deselectSelectedStateView];
        self.selectedStateView = [self addStateViewFromState:[self defaultStateWithCenter:[gestureRecognizer locationInView:self.view] stateNumber:self.createdStatesCount+1]];
        
    }
    return YES;
    
}

-(State*)defaultStateWithCenter:(CGPoint)center stateNumber:(int)stateNumber {
    
    State *state = [[State alloc] initWithCenter:center];
    state.color = SELECTED_STATE_COLOR;
    state.title = [NSString stringWithFormat:@"state #%i", stateNumber];
    return state;
    
}

-(StateView*)addStateViewFromState:(State*)state {
    
    StateView *sv = [StateView new];
    [sv addTarget:self action:@selector(pressedDownOnStateView:) forControlEvents:UIControlEventTouchDown];
    [sv addTarget:self action:@selector(pressedUpOnViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [sv setSMstate:state];
    self.createdStatesCount++;
    [self.view addSubview:sv];
    [self.stateViews addObject:sv];
    
    if ([_toolBox isActive]) {
        //Update the toolbox SMState
        [_toolBox setSMState:state];
    }
    else {
        
        [_toolBox toggleActive];
        [_toolBox setSMState:self.selectedStateView.SMstate];
        [_toolBox.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 45)];
        
        [self.view addSubview:_toolBox.view];
        
        [UIView animateWithDuration:1.0 animations:^{
            [_toolBox.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 45, [[UIScreen mainScreen] bounds].size.width, 45)];
        } completion:^(BOOL finished) {
            NSLog(@"toolbox animation completed");
        }];
    }
    
    return sv;
    
}

-(void)pressedDownOnStateView:(StateView*)stateView {
    
    self.pressedInsideState = YES;
    
    if ([_toolBox isActive]) {
        //Update the selected state
        if ([_toolBox isAddingTransition]) {
            //Don't reset the toolbox's SMState
        }
        else
            [_toolBox setSMState:stateView.SMstate];
    }
    else {
        
        [_toolBox toggleActive];
        
        if ([_toolBox isAddingTransition]) {
            //Don't reset the toolbox's SMState
        }
        else
            [_toolBox setSMState:self.selectedStateView.SMstate];
        
        [_toolBox.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 45)];
        
        [self.view addSubview:_toolBox.view];
        
        [UIView animateWithDuration:1.0 animations:^{
            [_toolBox.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 45, [[UIScreen mainScreen] bounds].size.width, 45)];
            } completion:^(BOOL finished) {
                NSLog(@"toolbox animation completed");
            }];
    }
    
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
    
    //[_toolBox setSMState:self.selectedStateView.SMstate];
    //[_toolBox.view setFrame:CGRectMake(0, -40, [[UIScreen mainScreen] bounds].size.width, 45)];
    //[self.view addSubview:_toolBox.view];
    if ([_toolBox isActive]) {
        [_toolBox toggleActive];
        
        [UIView animateWithDuration:1.0 animations:^{
            [_toolBox.view setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, 45)];
            } completion:^(BOOL finished) {
                NSLog(@"toolbox animation completed");
                [_toolBox.view removeFromSuperview];
            }];
    }
    
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
            if(self.stateMachine) {
                [[StateMachineManager sharedInstance] addModel:self.stateMachine];
            } else {
                [self.saveStateMachineAlertView show];
            }
            break;
        }
            case SABubbleMenuButtonTypeLoad:
        {
            //Show prompt to select state machine from saved states
            [self performSegueWithIdentifier:STATE_MACHINE_PICKER_SEGUE_ID sender:nil];
            break;
        }
            case SABubbleMenuButtonTypeExportAsPDF:
        {
            //Show prompt to name PDF export
            [self.pdfExportAlertView show];
            break;
        }
        case SABubbleMenuButtonTypeDeleteMachine:
        {
            //Delete the state machine from the archiver and start a blank project
            [self.deleteStateMachineAlertView show];
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

-(TextInputAlertView *)pdfExportAlertView {
    
    if(!_pdfExportAlertView) {
        _pdfExportAlertView = [[TextInputAlertView alloc] initWithTitle:@"Export State Machine" message:@"Name your pdf:" placeholderText:@"My awesome state machine" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    }
    return _pdfExportAlertView;
    
}

-(UIAlertView *)deleteStateMachineAlertView {
    
    if(!_deleteStateMachineAlertView)
        _deleteStateMachineAlertView = [[UIAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this state machine?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    return _deleteStateMachineAlertView;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:STATE_MACHINE_PICKER_SEGUE_ID]) {
        
        [(SavedStateMachinesTableViewController*)[[segue.destinationViewController viewControllers] firstObject] setDelegate:self];
        
    }
    
}

-(void)stateMachinesTableViewControllerSelectedStateMachine:(StateMachine *)stateMachine {
    
    [self resetToStateMachine:stateMachine];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)resetToStateMachine:(StateMachine*)stateMachine {
    
    self.selectedStateView = nil;
    for (UIView *subview in self.view.subviews) {
        if(![subview isEqual:self.bubbleMenuButton])
            [subview removeFromSuperview];
    }
    [self.stateViews removeAllObjects];
    
    self.stateMachine = stateMachine;
    if(stateMachine) {
        for (State *state in stateMachine.states) {
            
            [self.stateViews addObject:[self addStateViewFromState:state]];
            
        }
    }
    
}

-(void)alertView:(SDCAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([alertView isEqual:self.saveStateMachineAlertView]) {
        
        if(buttonIndex != alertView.cancelButtonIndex) {
            
            //Save a new state machine
            StateMachine *stateMachine = [[StateMachine alloc] initWithTitle:[[self.saveStateMachineAlertView textField] text] stateViews:(NSArray<StateView>*)self.stateViews];
            [[StateMachineManager sharedInstance] addModel:stateMachine];
            self.stateMachine = stateMachine;
            
        }
        
    } else if([alertView isEqual:self.deleteStateMachineAlertView]) {
      
        if(self.stateMachine) {
            
            [[StateMachineManager sharedInstance] removeModelWithID:self.stateMachine.id];
            
        }
        [self resetToStateMachine:nil];
        
    } else {
        
        if(buttonIndex != alertView.cancelButtonIndex) {
            
            NSString *pdfTitle = [[self.saveStateMachineAlertView textField] text];
            
        }
        
    }
    
}

#pragma mark - ToolBox Delegate Methods
-(BOOL)isWaitingForTransitionToState {
    if ([_selectedStateView.SMstate.id isEqualToString:_toolBox.SMState.id]) {
        //Keep the while loop running
        return true;
    }
    else {
        _toolBox.transitionToState = _selectedStateView.SMstate;
        //return false to break the loop
        return false;
    }
}

-(void)drawTransitionToView {
    //Transition *newTransition = [[Transition alloc] initWithFromStateID:_toolBox.SMState.title toStateID:_toolBox.transitionToState.title];
    Transition *newTransition = [_toolBox.SMState returnTransitionToState:_toolBox.transitionToState];
    TransitionView *newTV = [[TransitionView alloc] init];
    [newTV setTransition:newTransition];
    [self.view addSubview:newTV];
    [newTV updateView];
}

@end
