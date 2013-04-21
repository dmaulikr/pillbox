//
//  NextPillViewController.h
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIGlossyButton.h>
#import <GAI.h>

@interface NextPillViewController : GAITrackedViewController
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIGlossyButton *actionButton;
- (IBAction)onAction:(id)sender;

@end
