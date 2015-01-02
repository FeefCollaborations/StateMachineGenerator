//
//  StateToolDrawer.m
//  StateMachineDrawer
//
//  Created by Robert Miller on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "StateToolDrawer.h"
#import <WYPopoverController.h>

@interface StateToolDrawer () <WYPopoverControllerDelegate>

@property(nonatomic,retain)WYPopoverController *wyPopoverController;
@property(nonatomic,retain)ColorPalletteCollectionViewController *popoverControllerView;
@property(nonatomic,retain)UIBarButtonItem *recolorButton;
@property(nonatomic,retain)UIToolbar *toolBar;

@end

@implementation StateToolDrawer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 45);
    //self.view.backgroundColor = [UIColor lightGrayColor];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 30)];
    _toolBar.barTintColor = [UIColor whiteColor];
    _toolBar.tintColor = [UIColor blackColor];
    
    _recolorButton = [[UIBarButtonItem alloc] initWithTitle:@"Recolor" style:UIBarButtonItemStylePlain target:self action:@selector(recolorState)];
    UIBarButtonItem *changeTitleButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Title" style:UIBarButtonItemStylePlain target:self action:@selector(changeTitle)];
    UIBarButtonItem *addTransitionButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Transition" style:UIBarButtonItemStylePlain target:self action:@selector(addTransition)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Transition" style:UIBarButtonItemStylePlain target:self action:@selector(deleteState)];
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
}

-(void)addTransition {
    NSLog(@"add transition");
}

-(void)deleteState {
    NSLog(@"delete state");
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
            [_SMState setColor:[UIColor blackColor]];
            break;
        case 1:
            [_SMState setColor:[UIColor blueColor]];
            break;
        case 2:
            [_SMState setColor:[UIColor greenColor]];
            break;
        case 3:
            [_SMState setColor:[UIColor yellowColor]];
            break;
        case 4:
            [_SMState setColor:[UIColor redColor]];
            break;
        case 5:
            [_SMState setColor:[UIColor purpleColor]];
            break;
            
        default:
            break;
    }
    [_wyPopoverController dismissPopoverAnimated:YES];
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
