//
//  DFSGameBoard.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/27/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSGameBoard.h"
#import "DFSBoardSpace.h"
#import "DFSMatrix.h"
#import "DFSTile.h"
#import "DFSTileView.h"

/* private interface */
@interface DFSGameBoard () {
	CGFloat motionOffsetX;
	CGFloat motionOffsetY;
	int movingTileIndex;
	CGFloat motionDiameter;
	NSMutableArray *points;
	NSMutableArray *spaceRects;
	NSMutableArray *spaces;
}

@end

@implementation DFSGameBoard

- (void)setGame:(DFSGame *)game
{
	if (_game != game) {
		_game = game;
		[self setNeedsDisplay];
	}
}

- (void)setup
{
	motionOffsetX = 0;
	motionOffsetY = 0;
	movingTileIndex = -1;
	motionDiameter = 0;
	points = [[NSMutableArray alloc] init];
	spaces = [[NSMutableArray alloc] init];
	spaceRects = [[NSMutableArray alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)awakeFromNib
{
	[self setup];
}

- (void)recallTiles
{
	NSString *error;
	NSMutableArray *tileViews = [[NSMutableArray alloc] init];
	
	if([self.game recallTilesForPlayer:self.game.currentPlayer returnError:&error]){
		for (UIView *view in self.subviews) {
			if ([view isKindOfClass:[DFSTileView class]]) {
				[tileViews addObject:view];
			}
		}
	}
	
	[UIView animateWithDuration:0.5 animations:^{
		for (DFSTileView *tv in tileViews) {
			tv.frame = tv.originalFrame;
		}
	}];
	
}

- (BOOL)placeTileView:(DFSTileView *)view atPoint:(CGPoint)point
{
	// get the rect
	CGRect spaceRect = CGRectNull;
	DFSBoardSpace *space = nil;
		
	for (NSValue *value in spaceRects) {
		CGRect test = [value CGRectValue];
		if (CGRectContainsPoint(test, point)) {
			spaceRect = test;
			space = [spaces objectAtIndex:[spaceRects indexOfObject:value]];
            if (space.tile) {
                return NO;
            }
			break;
		}
	}
	
	if (!CGRectIsNull(spaceRect)) {
		// if found then animate the tile placement
		[UIView animateWithDuration:0.25 animations:^{
			view.frame = spaceRect;
		}];
		
		// also place the tile from the users set into the game
		[self.game player:self.game.currentPlayer placeTile:view.tile onSpace:space];
		
		return YES;
	}
	
	return NO;
}

- (void)removeTileView:(DFSTileView *)view
{
	NSString *error;
	[self.game recallTile:view.tile forPlayer:self.game.currentPlayer returnError:&error];
}

- (void)drawRect:(CGRect)rect
{
	// get the context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Drawing code
	CGFloat boardSide = rect.size.width > rect.size.height ? rect.size.height : rect.size.width;
	CGFloat spaceSide = boardSide / 15.0;
	
	CGFloat offsetX = 0;
	CGFloat offsetY = 0;
	
	// font
	UIFont *font = [UIFont boldSystemFontOfSize:14.0];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	NSDictionary *textStyle = @{NSFontAttributeName: font,
								NSParagraphStyleAttributeName: paragraphStyle,
								NSForegroundColorAttributeName: [UIColor whiteColor]};
	
	// draw the spaces
	for (int i=0; i<15; i++) {
		for (int j=0; j<15; j++) {
			
			// get the space
			DFSBoardSpace *space = [self.game.gameBoard objectAtRow:i andColumn:j];
			CGRect r = CGRectMake(offsetX + 1, offsetY + 1, spaceSide - 2, spaceSide - 2);
			
            if (space.multiplier > 1) {
                
                if (space.appliesToWord) {
                    // set the color
                    if (space.multiplier == 2) {
                        [[UIColor redColor] setFill];
                    } else {
                        [[UIColor blueColor] setFill];
                    }
                    CGContextAddRect(context, r);
                    CGContextFillPath(context);
                    // draw the text
                    NSString *text;
                    if (space.multiplier == 2) {
                        text = [NSString stringWithFormat:@"X%@", @"\u00B2"];
                    } else {
                        text = [NSString stringWithFormat:@"X%@", @"\u00B3"];
                    }
                    CGSize size = [text sizeWithAttributes:textStyle];
                    CGRect tr = CGRectMake(r.origin.x, r.origin.y + ((r.size.height - size.height)/2), r.size.width, size.height);
                    [text drawInRect:tr withAttributes:textStyle];
                } else {
                    if (space.multiplier == 2) {
                        [[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] setFill];
                    } else {
                        [[UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0] setFill];
                    }
                    CGContextAddRect(context, r);
                    CGContextFillPath(context);
                    // draw the text
                    NSString *text;
                    if (space.multiplier == 2) {
                        text = @"2X";
                    } else {
                        text = @"3X";
                    }
                    CGSize size = [text sizeWithAttributes:textStyle];
                    CGRect tr = CGRectMake(r.origin.x, r.origin.y + ((r.size.height - size.height)/2), r.size.width, size.height);
                    [text drawInRect:tr withAttributes:textStyle];
                }
            }

            // draw the center
            if (i==7 && j==7) {
                [[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] setFill];
                CGContextAddRect(context, r);
                CGContextFillPath(context);
                
                NSString *text = @"\u273B";
                CGSize size = [text sizeWithAttributes:textStyle];
                CGRect tr = CGRectMake(r.origin.x, r.origin.y + ((r.size.height - size.height)/2), r.size.width, size.height);
                [text drawInRect:tr withAttributes:textStyle];
            }
            
            [spaceRects addObject:[NSValue valueWithCGRect:r]];
            [spaces addObject:space];
            
            // draw the already placed tiles
            if (space.tile) {
                // draw the tile
                CGImageRef img = [UIImage imageNamed:@"Tile"].CGImage;
                CGContextDrawImage(context, r, img);
                
                UIFont *font2 = [UIFont boldSystemFontOfSize:16.0];
                NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle2.alignment = NSTextAlignmentCenter;
                NSDictionary *textStyle2 = @{NSFontAttributeName: font2,
                                             NSParagraphStyleAttributeName: paragraphStyle2,
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
                
                UIFont *font3 = [UIFont boldSystemFontOfSize:8.0];
                NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle3.alignment = NSTextAlignmentRight;
                NSDictionary *textStyle3 = @{NSFontAttributeName: font3,
                                             NSParagraphStyleAttributeName: paragraphStyle3,
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
                
                NSString *text = space.tile.faceValue;
                CGSize size = [text sizeWithAttributes:textStyle2];
                CGRect tr2 = CGRectMake(r.origin.x, r.origin.y + ((r.size.height - size.height)/2), r.size.width, size.height);
                [text drawInRect:tr2 withAttributes:textStyle2];
                
                NSString *text2 = [NSString stringWithFormat:@"%d", space.tile.pointValue];
                CGRect tr3 = CGRectMake(r.origin.x + r.size.width - 16, r.origin.y + r.size.height - 11, 15, 15);
                [text2 drawInRect:tr3 withAttributes:textStyle3];
                
            }
			
			offsetX += spaceSide;
		}
		offsetY += spaceSide;
		offsetX = 0;
	}
	
	// draw the vertical lines
	offsetX = 0;
	offsetY = 0;
	[[UIColor whiteColor] setStroke];
	for (int i=0; i<16; i++) {
		CGContextMoveToPoint(context, offsetX, offsetY);
		CGContextAddLineToPoint(context, offsetX, boardSide);
		offsetX += spaceSide;
	}

	// draw the horizontal lines
	offsetX = 0;
	for (int i=0; i<16; i++) {
		CGContextMoveToPoint(context, offsetX, offsetY);
		CGContextAddLineToPoint(context, boardSide, offsetY);
		offsetY += spaceSide;
	}
	CGContextStrokePath(context);
	
}



@end
