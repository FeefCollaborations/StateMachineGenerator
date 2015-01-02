//
//  SABubbleMenuButton.h
//  StateMachineDrawer
//
//  Created by sharif ahmed on 12/31/14.
//  Copyright (c) 2014 Feef. All rights reserved.
//

#import "DWBubbleMenuButton.h"

typedef enum {
    
    SABubbleMenuButtonTypeToggle,
    SABubbleMenuButtonTypeSave,
    SABubbleMenuButtonTypeLoad,
    SABubbleMenuButtonTypeExportAsPDF,
    SABubbleMenuButtonTypeDeleteMachine,
    SABubbleMenuButtonTypeManageAccount
    
} SABubbleMenuButtonType;

@protocol SMBubbleMenuButtonDelegate <NSObject>

-(void)bubbleMenuSelectedButtonWithType:(SABubbleMenuButtonType)buttonType;

@end

@interface SMBubbleMenuButton : DWBubbleMenuButton

-(instancetype)initWithDelegate:(id<SMBubbleMenuButtonDelegate>)SADelegate;

@property(nonatomic,weak)id<SMBubbleMenuButtonDelegate> SADelegate;

@end
