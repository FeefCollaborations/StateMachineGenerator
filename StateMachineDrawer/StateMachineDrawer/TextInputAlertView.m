//
//  TextInputAlertView.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 1/1/15.
//  Copyright (c) 2015 Feef. All rights reserved.
//

#import "TextInputAlertView.h"

#define TEXT_FIELD_INSET 20
#define TEXT_FIELD_SIZE CGSizeMake(220, 60)

@implementation TextInputAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message placeholderText:(NSString*)placeholderText delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if(self) {
        
        CGRect textFieldFrame = CGRectZero;
        textFieldFrame.size = TEXT_FIELD_SIZE;
        CGRect containerFrame = textFieldFrame;
        containerFrame.size.width += TEXT_FIELD_INSET * 2;
        UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
        
        textFieldFrame.origin.x += TEXT_FIELD_INSET;
        _textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        [_textField setTextAlignment:NSTextAlignmentCenter];
        [_textField setPlaceholder:placeholderText];
        
        [containerView addSubview:_textField];
        [self.contentView addSubview:containerView];
        
    }
    return self;
    
}

@end
