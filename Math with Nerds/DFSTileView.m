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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // don't draw if not tile
    if (self.tile) {
        // get the context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Drawing code
        UIFont *font2 = [UIFont boldSystemFontOfSize:20.0];
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle2.alignment = NSTextAlignmentCenter;
        NSDictionary *textStyle2 = @{NSFontAttributeName: font2,
                                    NSParagraphStyleAttributeName: paragraphStyle2,
                                    NSForegroundColorAttributeName: [UIColor blueColor]};

        UIFont *font3 = [UIFont boldSystemFontOfSize:10.0];
        NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle3.alignment = NSTextAlignmentRight;
        NSDictionary *textStyle3 = @{NSFontAttributeName: font3,
                                     NSParagraphStyleAttributeName: paragraphStyle3,
                                     NSForegroundColorAttributeName: [UIColor blueColor]};

        CGImageRef img = [UIImage imageNamed:@"Tile"].CGImage;
        CGContextDrawImage(context, rect, img);
        
        // face value
        NSString *text = self.tile.faceValue;
        CGSize size = [text sizeWithAttributes:textStyle2];
        CGRect tr2 = CGRectMake(rect.origin.x, rect.origin.y + ((rect.size.height - size.height)/2), rect.size.width, size.height);
        [text drawInRect:tr2 withAttributes:textStyle2];

        // point value
        NSString *text2 = [NSString stringWithFormat:@"%d", self.tile.pointValue];
        CGRect tr3 = CGRectMake(rect.origin.x + rect.size.width - 17, rect.origin.y + rect.size.height - 14, 15, 15);
        [text2 drawInRect:tr3 withAttributes:textStyle3];
    }
}


@end
