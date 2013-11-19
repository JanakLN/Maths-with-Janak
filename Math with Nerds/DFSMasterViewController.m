//
//  DFSMasterViewController.m
//  Math with Nerds
//
//  Created by Chris Bougher on 9/30/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSMasterViewController.h"
#import "DFSDetailViewController.h"
#import "DFSGame.h"
#import "DFSPlayer.h"
#import "DFSLoadingViewController.h"

@interface DFSMasterViewController ()

@property (strong, nonatomic) DFSLoadingViewController *loadingViewController;
@property (strong, nonatomic) DFSDetailViewController *detailViewController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation DFSMasterViewController

- (DFSLoadingViewController *)loadingViewController
{
    if (!_loadingViewController) _loadingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadingVC"];
    
    return _loadingViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// set up the navigation bar
    self.title = [NSString stringWithFormat:@"%@'s Games", [[GKLocalPlayer localPlayer] alias]];
    
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	self.navigationItem.rightBarButtonItem = addButton;
    
    self.gameCenterManager.delegate = self;
    
//    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    loading.backgroundColor = [UIColor blackColor];
//    
//    [self.view addSubview:loading];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.loadingViewController.view];
    
    [self.gameCenterManager loadMatches];
}

#pragma mark - turn based match maker delegate methods
- (void)turnBasedMatchmakerViewControllerWasCancelled:(GKTurnBasedMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *participants = match.participants;
    
	DFSPlayer *player1 = [[DFSPlayer alloc] initWithGameCenterID:match.currentParticipant.playerID andScore:0 andTileSet:nil];
    DFSPlayer *player2;
    if (participants.count > 1) {
        NSString *player2ID = ((GKTurnBasedParticipant *)participants[0]).playerID == match.currentParticipant.playerID ? ((GKTurnBasedParticipant *)participants[1]).playerID : ((GKTurnBasedParticipant *)participants[0]).playerID;
        
        player2 = [[DFSPlayer alloc] initWithGameCenterID:player2ID andScore:0 andTileSet:nil];
    } else {
        player2 = [[DFSPlayer alloc] initWithGameCenterID:nil andScore:0 andTileSet:nil];
    }

	DFSGame *newGame = [[DFSGame alloc] initNewGameWithPayer1:player1 andPlayer2:player2];
    
    [GKPlayer loadPlayersForIdentifiers:@[[GKLocalPlayer localPlayer].playerID] withCompletionHandler:^(NSArray *players, NSError *error){
        if (players != nil && players.count > 0) {
            newGame.player1.name = [[players firstObject] alias];
        } else {
            newGame.player1.name = @"You";
        }
        
        NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:newGame];
        [match saveCurrentTurnWithMatchData:gameData completionHandler:^(NSError *error) {
            [self performSegueWithIdentifier:@"showDetail" sender:match];
        }];
    }];

}
- (void)turnBasedMatchmakerViewController:(GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match
{
    
}

#pragma mark - Game center manager delegate methods
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didAuthenticatePlayer:(GKLocalPlayer *)player
{
    
}
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager failedAuthenticatePlayer:(GKLocalPlayer *)player
{
    
}
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didLoadMatches:(NSArray *)matches
{
    self.matches = matches;
    [self.tableView reloadData];
    [self.loadingViewController.view removeFromSuperview];
}

- (IBAction)refreshGames:(id)sender
{
    [self.view addSubview:self.loadingViewController.view];
    
    [self.gameCenterManager loadMatches];
}

- (void)insertNewObject:(id)sender
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = 2;
    request.maxPlayers = 2;
    
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    
    [self presentViewController:mmvc animated:YES completion:nil];
}

#pragma mark - Table View
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Your turn";
    }
    
    if (section == 1) {
        return @"Their turn";
    }
    
    if (section == 2) {
        return @"Past games";
    }
    
    return @"???";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//return [[self.fetchedResultsController sections] count];
    return self.matches.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.matches objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GKTurnBasedMatch *match = [[self.matches objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipants:match.participants turnTimeout:0 matchData:match.matchData completionHandler:^(NSError *error){
            [[self.matches objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DFSDetailViewController *dest = (DFSDetailViewController *)segue.destinationViewController;

        if ([sender isKindOfClass:[GKTurnBasedMatch class]]) {
            dest.match = sender;
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            dest.match = (GKTurnBasedMatch *)[[self.matches objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    GKTurnBasedMatch *match = [[self.matches objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	DFSGame *game = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)match.matchData];
	NSString *currentPlayer = game.currentPlayer.gameCenterID ? game.currentPlayer.gameCenterID : @"";
    
    [GKPlayer loadPlayersForIdentifiers:@[currentPlayer] withCompletionHandler:^(NSArray *players, NSError *error){
        if (players != nil && players.count > 0) {
            cell.textLabel.text = [[players firstObject] alias];
        } else {
            cell.textLabel.text = game.currentPlayer.description;
        }
        
    }];
    cell.textLabel.text = @"Loading...                          ";
    cell.detailTextLabel.text = game.description;
}

@end
