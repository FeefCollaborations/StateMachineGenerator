//
//  StateToolDrawer.h
//  StateMachineDrawer
//
//  Created by Robert Miller on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "State.h"
#import "ColorPalletteCollectionViewController.h"

@class StateToolDrawer;

@protocol StateToolDrawerDelegate <NSObject>

-(BOOL)isWaitingForTransitionToState;
-(void)drawTransitionToView;

@end

@interface StateToolDrawer : UIViewController <ColorPalleteCollectionViewControllerDelegate, UIAlertViewDelegate>

@property(nonatomic)State *SMState;
@property(nonatomic)State *transitionToState;

@property(nonatomic,weak)id<StateToolDrawerDelegate> delegate;

-(void)toggleActive;
-(BOOL)isActive;
-(BOOL)isAddingTransition;

@end
