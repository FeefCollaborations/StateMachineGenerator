//
//  StateToolDrawer.m
//  StateMachineDrawer
//
//  Created by Robert Miller on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateToolDrawer.h"
#import <WYPopoverController.h>
#import "TextInputAlertView.h"
#import "TransitionView.h"

@interface StateToolDrawer () <WYPopoverControllerDelegate>

@property(nonatomic,retain)WYPopoverController *wyPopoverController;
@property(nonatomic,retain)ColorPalletteCollectionViewController *popoverControllerView;
@property(nonatomic,retain)UIBarButtonItem *recolorButton;
@property(nonatomic,retain)UIToolbar *toolBar;

@end

@implementation StateToolDrawer

bool isActive = false;
bool isAddingTransition = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 45, [[UIScreen mainScreen] bounds].size.width, 45);
    //self.view.backgroundColor = [UIColor lightGrayColor];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 30)];
    _toolBar.barTintColor = [UIColor whiteColor];
    _toolBar.tintColor = [UIColor blackColor];
    
    _recolorButton = [[UIBarButtonItem alloc] initWithTitle:@"Recolor" style:UIBarButtonItemStylePlain target:self action:@selector(recolorState)];
    UIBarButtonItem *changeTitleButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Title" style:UIBarButtonItemStylePlain target:self action:@selector(changeTitle)];
    UIBarButtonItem *addTransitionButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Transition" style:UIBarButtonItemStylePlain target:self action:@selector(addTransition)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete State" style:UIBarButtonItemStylePlain target:self action:@selector(deleteState)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    _toolBar.items = @[flex, _recolorButton, flex, changeTitleButton, flex, addTransitionButton, flex, deleteButton, flex];
    [self.view addSubview:_toolBar];
    
}

-(void)recolorState {
    NSLog(@"recolor state");
    
    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake(60, 60)];
    [aFlowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _popoverControllerView = [[ColorPalletteCollectionViewController alloc] initWithCollectionViewLayout:aFlowLayout];
    _popoverControllerView.delegate = self;
    _wyPopoverController = [[WYPopoverController alloc] initWithContentViewController:_popoverControllerView];
    _wyPopoverController.delegate = self;
    [_wyPopoverController setPopoverContentSize:CGSizeMake(220, 160)];
    [_wyPopoverController presentPopoverFromBarButtonItem:_recolorButton permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

-(void)changeTitle {
    NSLog(@"change title");
    TextInputAlertView *alertView = [[TextInputAlertView alloc] initWithTitle:@"Change Title of Current State.." message:nil placeholderText:_SMState.title delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK"];
    [alertView showWithDismissHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                //Do Nothing
                break;
            case 1:
                [_SMState setTitle:[alertView textField].text];
                break;
                
            default:
                break;
        }
    }];
}

-(void)waitForStateSelection {
    while ([self.delegate isWaitingForTransitionToState]) {
        //Do nothing until state is changed
    }
    [_SMState addTransitionToState:_transitionToState];
    [self.delegate drawTransitionToView];
    isAddingTransition = false;
}

-(void)addTransition {
    NSLog(@"add transition");
    isAddingTransition = true;
    [self performSelectorInBackground:@selector(waitForStateSelection) withObject:nil];
}

-(void)deleteState {
    NSLog(@"delete state");

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Deleting the state will delete all associated transitions as well..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alertView.tag = 0xff;
    alertView.delegate = self;
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Check that the alert is for the delete.... JIC...
    if (alertView.tag == 0xff) {
        switch (buttonIndex) {
            case 0:
                //Do Nothing
                break;
            case 1:
                [_SMState deleteState];
                break;
                
            default:
                break;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSMState:(State *)SMState {
    _SMState = SMState;
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    _wyPopoverController.delegate = nil;
    _wyPopoverController = nil;
}

-(void)indexSelected:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [_SMState setDeselectColor:[UIColor blackColor]];
            break;
        case 1:
            [_SMState setDeselectColor:[UIColor blueColor]];
            break;
        case 2:
            [_SMState setDeselectColor:[UIColor greenColor]];
            break;
        case 3:
            [_SMState setDeselectColor:[UIColor yellowColor]];
            break;
        case 4:
            [_SMState setDeselectColor:[UIColor redColor]];
            break;
        case 5:
            [_SMState setDeselectColor:[UIColor purpleColor]];
            break;
            
        default:
            break;
    }
    [_wyPopoverController dismissPopoverAnimated:YES];
}


-(void)toggleActive
{
    isActive = !isActive;
}

-(BOOL)isActive
{
    return isActive;
}

-(BOOL)isAddingTransition
{
    return isAddingTransition;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
