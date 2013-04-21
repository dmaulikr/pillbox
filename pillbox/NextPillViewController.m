//
//  NextPillViewController.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "NextPillViewController.h"
#import "PillCrudController.h"
#import "PillListViewController.h"
#import "AppDelegate.h"
#import "Pill.h"

@interface NextPillViewController ()
{
    NSArray *pills;
}
@end

@implementation NextPillViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [self.actionButton setActionSheetButtonWithColor: [UIColor blackColor]];
    self.trackedViewName = @"Next pill";

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInfoLabel:nil];
    [self setActionButton:nil];
    [super viewDidUnload];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    NSError *error;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Pill" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    pills= [context executeFetchRequest:fetchRequest error:&error];
    
    if([pills count] == 0)
    {
        [self.actionButton
            setTitle:NSLocalizedString(@"Create pill schedule",@"")
            forState:UIControlStateNormal];
        self.infoLabel.text = NSLocalizedString(@"No pill scheduled, create one!", @"");
    }else{
        [self.actionButton
            setTitle:NSLocalizedString(@"Configure pill schedule", @"")
            forState:UIControlStateNormal];
        Pill* next_pill = [Pill firstTimeRemaining: pills ];
        self.infoLabel.text = [self nextPillText:next_pill];
    }
    
    for (Pill  *pill in pills) {
        [pill timeRemaining ];
    }
    
    [app createLocalNotifications: pills];
}

-(NSString*) nextPillText: (Pill*) pill
{
    NSDate *date = [pill timeRemaining];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    dateFormat.doesRelativeDateFormatting = YES;
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit ) fromDate:date];

    NSString *format = NSLocalizedString(@"Next pill is %@ %@ at %i", @"");
    return [NSString stringWithFormat: format, pill.name , dateString, [components hour] ] ;
}

- (IBAction)onAction:(id)sender {
    bool create = [pills count] == 0;
    UIViewController *controller;
    if(create)
        controller= [[PillCrudController alloc] initWithNibName:@"PillCrudController" bundle:nil];
    else
        controller = [[PillListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
