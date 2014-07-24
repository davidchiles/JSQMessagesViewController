//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQTableViewController.h"

@interface JSQTableViewController ()

@property (nonatomic, strong) JSQDemoViewController *reuseDemoViewController;
@property (nonatomic, strong) NSArray *conversation1Array;
@property (nonatomic, strong) NSArray *conversation2Array;

@end

@implementation JSQTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"JSQMessagesViewController";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Push via storyboard";
                break;
            case 1:
                cell.textLabel.text = @"Push programmatically";
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Modal via storyboard";
                break;
            case 1:
                cell.textLabel.text = @"Modal programmatically";
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Programmatically reuse 6 messages";
                break;
            case 1:
                cell.textLabel.text = @"Programmatically reuse 1 message";
                break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return (section == [tableView numberOfSections] - 1) ? @"Copyright © 2014\nJesse Squires\nMIT License" : nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"seguePushDemoVC" sender:self];
                break;
            case 1:
            {
                JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"segueModalDemoVC" sender:self];
                break;
            case 1:
            {
                JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
                vc.delegateModal = self;
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nc animated:YES completion:nil];
            }
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                self.reuseDemoViewController.messages = [self.conversation1Array mutableCopy];
                break;
            case 1:
                self.reuseDemoViewController.messages = [self.conversation2Array mutableCopy];
                break;
        }
        [self.navigationController pushViewController:self.reuseDemoViewController animated:YES];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueModalDemoVC"]) {
        UINavigationController *nc = segue.destinationViewController;
        JSQDemoViewController *vc = (JSQDemoViewController *)nc.topViewController;
        vc.delegateModal = self;
    }
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender { }

#pragma mark - Demo delegate

- (void)didDismissJSQDemoViewController:(JSQDemoViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Properties

- (JSQDemoViewController *)reuseDemoViewController
{
    if (!_reuseDemoViewController) {
        _reuseDemoViewController = [JSQDemoViewController messagesViewController];
    }
    return _reuseDemoViewController;
}

- (NSArray *)conversation1Array
{
    if (![_conversation1Array count]) {
        _conversation1Array = [[NSArray alloc] initWithObjects:
                               [[JSQMessage alloc] initWithText:@"There are 6 messages in this conversation" sender:@"Jesse Squires" date:[NSDate distantPast]],
                               [[JSQMessage alloc] initWithText:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy." sender:@"Steve Wozniak" date:[NSDate distantPast]],
                               [[JSQMessage alloc] initWithText:@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com." sender:@"Jesse Squires" date:[NSDate distantPast]],
                               [[JSQMessage alloc] initWithText:@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better." sender:@"Jobs" date:[NSDate date]],
                               [[JSQMessage alloc] initWithText:@"It is unit-tested, free, and open-source." sender:@"Tim Cook" date:[NSDate date]],
                               [[JSQMessage alloc] initWithText:@"Oh, and there's sweet documentation." sender:@"Jesse Squires" date:[NSDate date]],
                               nil];
    }
    return _conversation1Array;
}

- (NSArray *)conversation2Array
{
    if (![_conversation2Array count]) {
        _conversation2Array = [[NSArray alloc] initWithObjects:
                               [[JSQMessage alloc] initWithText:@"This is the only message" sender:@"Jesse Squires" date:[NSDate distantPast]],nil];
    }
    return _conversation2Array;
}

@end
