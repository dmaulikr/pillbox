//
//  PillCrudModel.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "PillCrudCrontrollerModelDataSource.h"
#import "StringToNumberTransformer.h"
#import "Pill.h"

#import "AppDelegate.h"

@implementation PillCrudCrontrollerModelDataSource

-(id) initWithModel:(id)model
{
    self = [super initWithModel:model];
    
    IBAFormSection *section = [self addSectionWithHeaderTitle: NSLocalizedString(@"Pill Information",@"") footerTitle:@""];
    
    
    IBAFormField *formName = [[IBATextFormField alloc] initWithKeyPath:@"name" title:NSLocalizedString(@"Name",@"")];
    [section addFormField: formName];
    
    NSArray *options =[IBAPickListFormOption pickListOptionsForStrings: @[
                         NSLocalizedString(@"Hour",@"")
                       , NSLocalizedString(@"Day",@"")
                       , NSLocalizedString(@"Week", @"")]];
    IBASingleIndexTransformer *trans = [[IBASingleIndexTransformer alloc] initWithPickListOptions:options];

    IBAPickListFormField *list = [[IBAPickListFormField alloc] initWithKeyPath:@"freq_type"
                                                                         title:NSLocalizedString(@"Frequency",@"")
                                                              valueTransformer: trans];
    list.pickListOptions = options;
    [list setSelectionMode: IBAPickListSelectionModeSingle];
    [section addFormField: list];
    
    IBATextFormField *freq = [[IBATextFormField alloc] initWithKeyPath:@"freq_value"
                                                                 title:NSLocalizedString(@"Each", @"")
                                                      valueTransformer: [StringToNumberTransformer instance] ];
    [section addFormField: freq];
    freq.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    IBAFormField *date = [[IBADateFormField alloc] initWithKeyPath:@"next_time"
                                                             title:NSLocalizedString(@"Next time",@"")
                                                      defaultValue:[NSDate date] type:IBADateFormFieldTypeDateTime];
    [section addFormField:date];
    
    
    
    return self;
}

-(NSManagedObjectContext*) getCoreDataContext
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    return [app managedObjectContext];
}
@end
