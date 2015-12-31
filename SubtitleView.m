//
//  SubtitleView.m
//  subtitle player
//
//  Created by Guo, Josh on 12/29/15.
//  Copyright © 2015 Apollo Millennium LLC. All rights reserved.
//

#import "SubtitleView.h"

@implementation SubtitleView

- (void)drawRect:(CGRect)dirtyRect {
    [[NSColor clearColor] set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
    CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext]
                                          graphicsPort];
    CGColorSpaceRef cmykSpace = CGColorSpaceCreateDeviceCMYK();
    CGFloat cmykValue[] = {0, 0, 0, 0, 1};      // blue
    CGColorRef colorCMYK = CGColorCreate(cmykSpace, cmykValue);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetStrokeColorWithColor(context, colorCMYK);
    CGContextSetFillColorWithColor(context, colorCMYK);
    
    CGContextSelectFont(context, "Helvetica", 2.0f, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextPosition(context, 0.0f, 260.0f);
    NSString *text = @"hello world";
    CGContextShowText(context, [text UTF8String], strlen([text UTF8String]));

}



@end
