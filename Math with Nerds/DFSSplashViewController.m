//
//  DFSSplashViewController.m
//  Math with Nerds
//
//  Created by Chris Bougher on 11/9/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSSplashViewController.h"
#import "DFSMasterViewController.h"
#import "DFSGame.h"

@interface DFSSplashViewController ()

@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) DFSGameCenterManager *manager;
@property (strong, nonatomic) NSArray *matches;

@end

@implementation DFSSplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get the game center manager
    self.manager = [DFSGameCenterManager defaultManager];
    self.manager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set initial activity
    self.activityLabel.text = @"Signing in to Game Center";
    
    // authenticate local user
    [self.manager authenticateLocalPlayerFromViewController:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GamesList"]) {
        DFSMasterViewController *table = (DFSMasterViewController *)[segue destinationViewController];
        table.gameCenterManager = self.manager;
        table.matches = self.matches;
    }
}

#pragma mark - game center manager delegate methods
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didAuthenticatePlayer:(GKLocalPlayer *)player
{
    [self.spinner stopAnimating];
    self.activityLabel.text = @"Refreshing games";
    [self.manager loadMatches];
}

- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager failedAuthenticatePlayer:(GKLocalPlayer *)player
{
    [self.spinner stopAnimating];
    self.activityLabel.text = @"This game requires Game Center!";
}

- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didLoadMatches:(NSArray *)matches
{

    self.matches = matches;
    [self performSegueWithIdentifier:@"GamesList" sender:self];
}

@end
