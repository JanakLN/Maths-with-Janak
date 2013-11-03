//
//  DFSTileView.m
//  Math with Nerds
//
//  Created by Chris Bougher on 10/27/13.
//  Copyright (c) 2013 Chris Bougher. All rights reserved.
//

#import "DFSTileView.h"

@implementation DFSTileView {
	CGFloat motionOffsetX;
	CGFloat motionOffsetY;
}

@synthesize tile = _tile;
@synthesize originalFrame = _originalFrame;

- (void)moveBackToTray
{
	[UIView animateWithDuration:0.5 animations:^{
		self.frame = self.originalFrame;
	}];
}

- (void)setTile:(DFSTile *)tile
{
	if(_tile != tile) {
		_tile = tile;
		[self setNeedsDisplay];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	// get the context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Drawing code
	UIFont *font2 = [UIFont boldSystemFontOfSize:20.0];
	NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle2.alignment = NSTextAlignmentCenter;
	NSDictionary *textStyle2 = @{NSFontAttributeName: font2,
								NSParagraphStyleAttributeName: paragraphStyle2,
								NSForegroundColorAttributeName: [UIColor blackColor]};

	UIFont *font3 = [UIFont boldSystemFontOfSize:10.0];
	NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle3.alignment = NSTextAlignmentRight;
	NSDictionary *textStyle3 = @{NSFontAttributeName: font3,
								 NSParagraphStyleAttributeName: paragraphStyle3,
								 NSForegroundColorAttributeName: [UIColor blackColor]};



    // save point
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:3.0];
	CGContextSetLineWidth(context, 3.0);
    CGContextAddPath(context, path.CGPath);
    [[UIColor colorWithRed:1.0 green:0.79 blue:0.0 alpha:0.75] setFill];
	[[UIColor grayColor] setStroke];
	CGContextDrawPath(context, kCGPathFillStroke);
    NSString *text = self.tile.faceValue;
    CGSize size = [text sizeWithAttributes:textStyle2];
    CGRect tr2 = CGRectMake(rect.origin.x, rect.origin.y + ((rect.size.height - size.height)/2), rect.size.width, size.height);
    [text drawInRect:tr2 withAttributes:textStyle2];

    NSString *text2 = [NSString stringWithFormat:@"%d", self.tile.pointValue];
    CGRect tr3 = CGRectMake(rect.origin.x + rect.size.width - 17, rect.origin.y + rect.size.height - 14, 15, 15);
    [text2 drawInRect:tr3 withAttributes:textStyle3];
}


@end
