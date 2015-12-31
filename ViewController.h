//
//  ViewController.h
//  subtitle player
//
//  Created by Guo, Josh on 12/25/15.
//  Copyright © 2015 Apollo Millennium LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OverlyWindow.h"
#import "SubtitleView.h"
@interface ViewController : NSViewController


@property(atomic, assign) NSPoint lastDragLocation;
@property(atomic, strong) NSMutableArray* subtitleTexts;
@property(atomic, assign) OverlyWindow* window;
@property(atomic, assign) NSTextField* textField;
@property(atomic, assign) NSTimeInterval startTimeStamp;
@property(atomic, assign) NSTimeInterval currentTimeStamp;
@property(atomic, strong) NSTimer* timer;
@property(atomic, strong) NSTimer* ffTimer;
@property(atomic, strong) NSMutableArray* fromTimeElapse;
@property(atomic, strong) NSMutableArray* toTimeElapse;
@property(atomic, assign) int timerCount;
@property(atomic, assign) float movedTimeLocation;
@property(atomic, assign) float timeLapse;
@property(atomic, assign) BOOL paused;
@property(atomic, strong) NSSlider *slider;
@property(atomic, assign) int speed;
@property(atomic, strong) NSButton *ffBtn;
@property(atomic, assign) float timerInterval;
@property(atomic, strong) NSTextField *sliderIndicator;
@property(atomic, strong) NSMutableArray *fromHours;
@property(atomic, strong) NSMutableArray *fromMinutes;
@property(atomic, strong) NSMutableArray *fromSeconds;

@end

