//
//  SABubbleMenuButton.m
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "SMBubbleMenuButton.h"
#import "SMGlobals.h"

#define MENU_INSET_AMOUNT 20

@interface SMBubbleMenuButton ()

@property(nonatomic)CGRect buttonFrame;

@end

@implementation SMBubbleMenuButton

-(instancetype)initWithDelegate:(id<SMBubbleMenuButtonDelegate>)SADelegate {
    
    CGRect buttonFrame = [self buttonFrame];
    buttonFrame.origin = CGPointMake(MENU_INSET_AMOUNT, MENU_INSET_AMOUNT + 20);
    self = [super initWithFrame:buttonFrame expansionDirection:DirectionDown];
    if(self) {
        
        buttonFrame.origin = CGPointZero;
        
        _SADelegate = SADelegate;
        
        UIButton *homeButton = [self menuButtonWithImageName:@"menu" tag:0];
        self.homeButtonView = homeButton;
        
        NSArray *imageTitles = @[@"saveAs",@"import",@"pdf",@"changeUser",@"deleteSign"];
        for (int i = 0; i<imageTitles.count; i++) {
            
            [self addButton:[self menuButtonWithImageName:[imageTitles objectAtIndex:i] tag:i+1]];
            
        }
        
    }
    
    return self;
}

-(UIButton*)menuButtonWithImageName:(NSString*)imageName tag:(int)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setFrame:[self buttonFrame]];
    [button setClipsToBounds:YES];
    [button.layer setCornerRadius:button.frame.size.width / 2];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    return button;
    
}

-(CGRect)buttonFrame {
    if(CGRectEqualToRect(_buttonFrame, CGRectZero))
        _buttonFrame = CGRectMake(0, 0, SM_MENU_ITEM_SIDE, SM_MENU_ITEM_SIDE);
    return _buttonFrame;
}

-(void)pressedButton:(UIButton*)button {
    
    if(_SADelegate && [_SADelegate respondsToSelector:@selector(bubbleMenuSelectedButtonWithType:)]) {
        [_SADelegate bubbleMenuSelectedButtonWithType:(SABubbleMenuButtonType)button.tag];
    }
    
}



@end
