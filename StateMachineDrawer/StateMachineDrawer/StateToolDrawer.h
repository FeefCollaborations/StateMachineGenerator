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

@interface StateToolDrawer : UIViewController <ColorPalleteCollectionViewControllerDelegate>

@property(nonatomic)State *SMState;

@end
