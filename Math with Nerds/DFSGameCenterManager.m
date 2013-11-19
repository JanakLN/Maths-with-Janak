//
//  DFSGameCenterManager.m
//  Math with Nerds
//
//  Created by Chris Bougher on 11/6/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSGameCenterManager.h"

static DFSGameCenterManager *singleton = nil;

@implementation DFSGameCenterManager

+ (instancetype)defaultManager
{
    if (!singleton) singleton = [[DFSGameCenterManager alloc] init];
    
    return singleton;
}

- (void)authenticateLocalPlayerFromViewController:(UIViewController *)presentingViewController
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            [presentingViewController presentViewController:viewController animated:YES completion:^{

            }];
        }
        else if (blockLocalPlayer.isAuthenticated)
        {
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            [self.delegate gameCenterManager:self didAuthenticatePlayer:blockLocalPlayer];
        }
        else
        {
            [self.delegate gameCenterManager:self failedAuthenticatePlayer:blockLocalPlayer];
        }
    };
    
}

//- (IBAction)joinNewMatch: (id) sender
//{
//    GKMatchRequest *request = [[GKMatchRequest alloc] init];
//    request.minPlayers = 2;
//    request.maxPlayers = 2;
//    
//    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
//    mmvc.turnBasedMatchmakerDelegate = self;
//    
//    [sender presentViewController:mmvc animated:YES completion:nil];
//}

- (void) loadMatches
{
    NSMutableArray *matchesArray = [[NSMutableArray alloc] init];
    NSMutableArray *mineArray = [[NSMutableArray alloc] init];
    NSMutableArray *theirsArray = [[NSMutableArray alloc] init];
    NSMutableArray *endedArray = [[NSMutableArray alloc] init];

    [matchesArray addObject:mineArray];
    [matchesArray addObject:theirsArray];
    [matchesArray addObject:endedArray];
    
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:^(NSArray *matches, NSError *error) {
        if (matches)
        {
            // Use the match data to populate your user interface.
            for (GKTurnBasedMatch *match in matches) {
                //NSLog(@"%d", match.status);
                
                if (match.status == GKTurnBasedMatchStatusEnded) {
                    // ended games
                    [endedArray addObject:match];
                    
                } else if ([match.currentParticipant.playerID isEqualToString:[[GKLocalPlayer localPlayer] playerID]]) {
                    
                    // my turn
                    [mineArray addObject:match];
                    
                } else {
                    // their turn
                    [theirsArray addObject:match];
                }
            }
            [self.delegate gameCenterManager:self didLoadMatches:[matchesArray copy]];
            
        } else {
            [self.delegate gameCenterManager:self didLoadMatches:nil];
        }
    }];
}

@end
