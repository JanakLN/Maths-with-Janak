//
//  DFSGameCenterManager.h
//  Math with Nerds
//
//  Created by Chris Bougher on 11/6/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//
@import GameKit;

@class DFSGameCenterManager;

/**
 * Game Center Manager protocol
 */
@protocol DFSGameCenterManagerDelegate <NSObject>

- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didAuthenticatePlayer:(GKLocalPlayer *)player;
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager failedAuthenticatePlayer:(GKLocalPlayer *)player;
- (void)gameCenterManager:(DFSGameCenterManager *)gameCenterManager didLoadMatches:(NSArray *)matches;

@end

@interface DFSGameCenterManager : NSObject

- (void)authenticateLocalPlayerFromViewController:(UIViewController *)presentingViewController;
- (void)loadMatches;

+ (instancetype)defaultManager;

@property (weak, nonatomic) id<DFSGameCenterManagerDelegate> delegate;

@end
