//
//  SavedStateMachinesTableViewController.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateMachine.h"

@protocol SavedStateMachinesTableViewControllerDelegate <NSObject>

-(void)stateMachinesTableViewControllerSelectedStateMachine:(StateMachine*)stateMachine;

@end

@interface SavedStateMachinesTableViewController : UITableViewController

-(IBAction)pressedBackButton:(id)sender;

@property(nonatomic,weak)id<SavedStateMachinesTableViewControllerDelegate> delegate;

@end
