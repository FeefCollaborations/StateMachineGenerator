//
//  ColorPalletteCollectionViewController.h
//  StateMachineDrawer
//
//  Created by Robert Miller on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPalleteCollectionViewControllerDelegate <NSObject>
@required
-(void)indexSelected:(NSIndexPath*)indexPath;
@end

@interface ColorPalletteCollectionViewController : UICollectionViewController

@property(nonatomic,strong)id delegate;

@end
