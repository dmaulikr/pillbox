//
//  PillCrud.h
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IBAForms/IBAForms.h>
#import "Pill.h"

@interface PillCrudController :IBAFormViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) Pill *pill;
@end
