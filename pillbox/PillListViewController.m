//
//  PillListViewController.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "PillListViewController.h"
#import "PillCrudController.h"
#import "AppDelegate.h"
#import "Pill.h"
#import <UIGlossyButton.h>

@interface PillListViewController ()
{
    UIBarButtonItem* addButton;
    NSArray* pills;
}
@end

@implementation PillListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Your Pills";
    UIGlossyButton *_addButton = [[UIGlossyButton alloc] initWithFrame:CGRectMake(0, 0, 48, 28)];
    [_addButton addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [_addButton setNavigationButtonWithColor:[UIColor navigationBarButtonColor]];
    [_addButton setTitle:@"Add" forState:UIControlStateNormal];
    addButton = [[UIBarButtonItem alloc] initWithCustomView:_addButton];
    self.navigationItem.rightBarButtonItems = @[addButton, self.editButtonItem];
    
    [[[GAI sharedInstance] defaultTracker] sendView: @"Pill list"];
}

-(void) viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pills count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if(!cell)
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
    Pill *pill = [pills objectAtIndex:indexPath.row];
    cell.textLabel.text  = pill.name;
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *ctx = [app managedObjectContext];
        Pill *pill = [pills objectAtIndex: indexPath.row];
        [ctx deleteObject: pill];
        [app saveContext];
        [self loadData];
        self.editing = NO;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PillCrudController *crud = [[PillCrudController alloc] initWithNibName:@"PillCrudController" bundle:nil];
    Pill *pill = [pills objectAtIndex: indexPath.row];
    crud.pill = pill;
    [self.navigationController pushViewController:crud animated:YES];
}

- (void) addItem:(id) sender
{
    PillCrudController *crud = [[PillCrudController alloc] initWithNibName:@"PillCrudController" bundle:nil];
    [self.navigationController pushViewController:crud animated:YES];
}


- (void)loadData
{
    NSError *error;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [app managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Pill" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    pills= [context executeFetchRequest:fetchRequest error:&error];
    [app createLocalNotifications: pills];
    
    [self.tableView reloadData];
}

@end
