//
//  TextInputAlertView.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "SDCAlertView.h"

@interface TextInputAlertView : SDCAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message placeholderText:(NSString*)placeholderText delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@property(nonatomic)UITextField *textField;

@end
