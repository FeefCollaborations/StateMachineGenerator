//
//  SavedStateMachinesTableViewController.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "SavedStateMachinesTableViewController.h"
#import "StateMachineManager.h"

#define CELL_IDENTIFIER @"Cell"

@implementation SavedStateMachinesTableViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    UILabel *noContentsLabel = nil;
    if([self tableView:self.tableView numberOfRowsInSection:0] == 0) {
        
        noContentsLabel = [[UILabel alloc] init];
        [noContentsLabel setTextAlignment:NSTextAlignmentCenter];
        [noContentsLabel setText:@"No saved state machines"];
        
    }
    [self.tableView setBackgroundView:noContentsLabel];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[cell textLabel] setText:[[[[StateMachineManager sharedInstance] allModels] objectAtIndex:indexPath.row] title]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[StateMachineManager sharedInstance] allModels].count;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_delegate && [_delegate respondsToSelector:@selector(stateMachinesTableViewControllerSelectedStateMachine:)]) {
        [_delegate stateMachinesTableViewControllerSelectedStateMachine:[[[StateMachineManager sharedInstance] allModels] objectAtIndex:indexPath.row]];
    }
    
}

-(void)setDelegate:(id<SavedStateMachinesTableViewControllerDelegate>)delegate {
    
    _delegate = delegate;
    
}

-(IBAction)pressedBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
