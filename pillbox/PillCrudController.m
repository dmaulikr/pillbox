//
//  PillCrud.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "PillCrudController.h"
#import "PillCrudCrontrollerModelDataSource.h"
#import "AppDelegate.h"

@interface PillCrudController ()
{
    UIBarButtonItem *addButton;
    bool inserted, new;
}
@end

@implementation PillCrudController
@synthesize  pill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    new = pill == nil;
    inserted = NO;
    
    if(new)
    {
        NSManagedObjectContext* ctx = [[self app] managedObjectContext];
        NSEntityDescription *desc= [NSEntityDescription entityForName:@"Pill" inManagedObjectContext:ctx];
        pill = [[Pill alloc] initWithEntity:desc insertIntoManagedObjectContext:ctx];
        pill.freq_value = [NSNumber numberWithInt:8];
        pill.next_time = [NSDate date];
    }
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItems = @[addButton];
    self.tableView = self.table;
    PillCrudCrontrollerModelDataSource *model = [[PillCrudCrontrollerModelDataSource alloc] initWithModel: pill];
    self.formDataSource = model;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) didMoveToParentViewController:(UIViewController *)parent
{
    if(new && !inserted && parent == nil)
    {
        NSManagedObjectContext* ctx = [[self app] managedObjectContext];
        [ctx deleteObject: pill];
        [[self app] saveContext];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}

-(void) addItem: (id) sender
{
    inserted = YES;
    NSLog(@"%@!", [pill description]);
    [[self app] saveContext];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(AppDelegate*) app
{
    return [UIApplication sharedApplication].delegate;
}

@end
