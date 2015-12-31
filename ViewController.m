//
//  ViewController.m
//  subtitle player
//
//  Created by Guo, Josh on 12/25/15.
//  Copyright © 2015 Apollo Millennium LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

@property(atomic, assign) float tmpTimeLapse;
@property(atomic, assign) BOOL sliderMoved;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    NSTextField *t = (NSTextField*)[self.view viewWithTag:1];
    [t setStringValue:@"Merry Christmas!"];
    [t setAlphaValue:5];
    self.textField = t;
    self.startTimeStamp = 0;
    self.currentTimeStamp = 0;
    self.subtitleTexts = nil;
    self.timerCount = 0;
    self.movedTimeLocation = 0;
    self.timeLapse = 0;
    self.slider = (NSSlider *)[self.view viewWithTag:3];
    [self.slider setIntValue:0];
    self.speed = 1;
    self.ffBtn = [self.view viewWithTag:7];
    self.timerInterval = 0.001;
    self.sliderIndicator = [self.view viewWithTag:10];
    
//    self.textField.bezeled         = NO;
//    self.textField.editable        = NO;
//    self.textField.drawsBackground = NO;

}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

}


- (BOOL) acceptsFirstMouse:(NSEvent *)e {
    return YES;
}

- (IBAction)playSubtitle:(id)sender {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: self.timerInterval
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    self.timer = t;
    self.speed = 1;
    self.ffBtn.title = @"FF";
    if (self.sliderMoved) {
        self.sliderMoved = false;
    }
    else {
        self.timeLapse = self.tmpTimeLapse;
    }


}


- (IBAction)sliderMoved:(id)sender {
    [self stopSubtitle:nil];
    NSLog(@"current progress: %d", [sender intValue]);
    int currentPlayLocation = 0;
    if (self.fromTimeElapse && self.toTimeElapse) {
        currentPlayLocation = floor((self.fromTimeElapse.count - 1) * [sender intValue]/100);
    }
    NSLog(@"current location: %d", currentPlayLocation);
    
    self.startTimeStamp = 0;
    self.timeLapse = [self.fromTimeElapse[currentPlayLocation] intValue];
    self.timerCount = currentPlayLocation;
    NSLog(@"self.timerCount set to: %d", self.timerCount);
    self.sliderMoved = true;
    self.sliderIndicator.stringValue = [NSString stringWithFormat:@"%02@:%02@:%2@",self.fromHours[currentPlayLocation],self.fromMinutes[currentPlayLocation],self.fromSeconds[currentPlayLocation]];
}

- (void) onTick:(NSTimer*) timer {
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
    if (!self.startTimeStamp) {
        self.startTimeStamp = timeInMiliseconds;
    }
    self.currentTimeStamp = timeInMiliseconds;
    float timeLapse = (self.currentTimeStamp - self.startTimeStamp) * self.speed + self.timeLapse;
    

    if (!self.fromTimeElapse || !self.toTimeElapse) {
        @throw [NSException	exceptionWithName:@"Srt file not loaded"
                                       reason:@"Srt file not loaded"
                                     userInfo:nil];
    }
    if (timeLapse >= [self.fromTimeElapse[self.timerCount] intValue] && timeLapse < [self.toTimeElapse[self.timerCount] intValue]) {
        self.textField.stringValue = [self.subtitleTexts objectAtIndex:self.timerCount];
    }
    else if (timeLapse > [self.toTimeElapse[self.timerCount] intValue]) {
        self.timerCount += 1;
        NSLog(@"self.timerCount increased to: %f", (float)self.timerCount);
        NSLog(@"self.fromTimeElapse.count set to %f", (float)self.fromTimeElapse.count);

        NSLog(@"floor(self.timerCount/self.fromTimeElapse.count): %f", floor((float)self.timerCount / (float)self.fromTimeElapse.count * 100));
        self.textField.stringValue = @"";
        
    }
    
    self.tmpTimeLapse = timeLapse;
    
    
    [self.slider setIntValue:(int)(floor((float)self.timerCount / (float)self.fromTimeElapse.count * 100))];
}

- (IBAction)openBtnClicked:(id)sender {
    [[[NSApplication sharedApplication] delegate] openFile:@""];
}

- (IBAction)stopSubtitle:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    [self.ffTimer invalidate];
    self.ffTimer = nil;
    self.timeLapse = self.tmpTimeLapse;
    self.startTimeStamp = 0;
}

- (IBAction)fastForwardClicked:(id)sender {
    self.speed = (self.speed * 2) % 32;
    if (!self.speed) {
        self.speed = 1;
    }
    if (self.speed > 1)
        self.ffBtn.title = [NSString stringWithFormat:@"x%d", self.speed];
    else
        self.ffBtn.title = @"FF";
    
    if (self.ffTimer) {
        [self.ffTimer invalidate];
        self.ffTimer = nil;
    }
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: self.timerInterval
                                                  target: self
                                                selector:@selector(onTick:)
                                                userInfo: nil repeats:YES];
    self.ffTimer = t;
    if (self.sliderMoved) {
        self.sliderMoved = false;
    }
    else {
        self.timeLapse = self.tmpTimeLapse;
    }


}

@end
