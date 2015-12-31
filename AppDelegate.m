//
//  AppDelegate.m
//  subtitle player
//
//  Created by Guo, Josh on 12/25/15.
//  Copyright © 2015 Apollo Millennium LLC. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    Insert code here to initialize your application
//    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController* mainVC = nil;
//    if (storyboard) {
//        mainVC = [storyboard instantiateControllerWithIdentifier:@"mainVC"];
//    }
//    another way to do it
//    self.vc = (ViewController *)[[[NSApplication sharedApplication] keyWindow] contentViewController];

}

- (void) applicationWillResignActive:(NSNotification *)notification {
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)openFile:(id)sender {
    self.vc = (ViewController *)[[[NSApplication sharedApplication] keyWindow] contentViewController];
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    [openDlg setPrompt:@"Select"];

    [openDlg beginWithCompletionHandler:^(NSInteger result){
        NSArray* urls = [openDlg URLs];
        for(NSURL* url in urls)
        {
            NSString *originalTxtFileContents              = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
            NSString *txtFileContents = [originalTxtFileContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSArray *brokenByParagraph             = [txtFileContents componentsSeparatedByString:@"\r\n\r\n"];

            NSMutableArray* fromHours = [[NSMutableArray alloc] init];
            NSMutableArray* fromMinutes = [[NSMutableArray alloc] init];
            NSMutableArray* fromSeconds = [[NSMutableArray alloc] init];

            NSMutableArray* toHours = [[NSMutableArray alloc] init];
            NSMutableArray* toMinutes = [[NSMutableArray alloc] init];
            NSMutableArray* toSeconds = [[NSMutableArray alloc] init];

            NSMutableArray* fromTimeElapse = [[NSMutableArray alloc] init];
            NSMutableArray* toTimeElapse = [[NSMutableArray alloc] init];

            NSMutableArray *subtitleParagraphTexts = [[NSMutableArray alloc] init];
            for (NSString* paragraph in brokenByParagraph) {

                NSArray* paragraphComponents = [paragraph componentsSeparatedByString:@"\r\n"];
                //            NSString *index = paragraphComponents[0];
                NSString* subtitleParagraphText = @"";
                NSString *timerange = paragraphComponents[1];
                for (int i=2; i<paragraphComponents.count; i++) {
                    subtitleParagraphText = [subtitleParagraphText stringByAppendingString:paragraphComponents[i]];
                    subtitleParagraphText = [subtitleParagraphText stringByAppendingString:@"\n"];
                }

                [subtitleParagraphTexts addObject:subtitleParagraphText];

                NSError *regexError        = nil;
                NSString *regexPattern     = @"(.*)\\s*-->\\s*(.*)";
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                                       options:0 error:&regexError];
                if (regexError) {
                    NSLog(@"Couldn't create regex with given string and options");
                }
                NSString *visibleText = timerange;
                NSRange visibleTextRange   = NSMakeRange(0, visibleText.length);
                NSArray *matches           = [regex matchesInString:visibleText options:NSMatchingReportProgress range:visibleTextRange];
                NSString* fromText = [[NSString alloc] init];
                NSString* toText = [[NSString alloc] init];

                for (NSTextCheckingResult *match in matches)
                {

                    NSRange from = [match rangeAtIndex:1];
                    NSRange to   = [match rangeAtIndex:2];

                    fromText = [visibleText substringWithRange:from];
                    toText = [visibleText substringWithRange:to];


                }
                NSString *regexPatternTime     = @"(([0-9]{2}):([0-9]{2}):([0-9]{2})),(.*)";
                NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:regexPatternTime
                                                                                        options:0
                                                                                          error:&regexError];
                if (regexError) {
                    NSLog(@"Couldn't create regex with given string and options");
                }
                NSRange fromTextRange   = NSMakeRange(0, fromText.length);
                NSArray *matches2           = [regex2 matchesInString:fromText options:NSMatchingReportProgress range:fromTextRange];
                for (NSTextCheckingResult *match in matches2)
                {
                    //                NSString* matchText = [fromText substringWithRange:[match range]];
                    NSRange secondRange = [match rangeAtIndex:4];
                    NSRange milisecondRanage   = [match rangeAtIndex:5];
                    NSString* secondText = [fromText substringWithRange:secondRange];
                    NSString* milisecondText = [fromText substringWithRange:milisecondRanage];
                    NSRange hourRange = [match rangeAtIndex:2];
                    NSString* hourText = [fromText substringWithRange:hourRange];
                    NSRange minuteRange = [match rangeAtIndex:3];
                    NSString* minuteText = [fromText substringWithRange:minuteRange];

                    NSNumber* fromHour = [NSNumber numberWithInt:[hourText intValue]];
                    NSNumber* fromMinute = [NSNumber numberWithInt:[minuteText intValue]];
                    NSNumber* fromSecond = [NSNumber numberWithFloat:(float)[secondText intValue] + (float)[milisecondText intValue]/1000];

                    [fromHours addObject:fromHour];
                    [fromMinutes addObject:fromMinute];
                    [fromSeconds addObject:fromSecond];
                    [fromTimeElapse addObject:[NSNumber numberWithFloat:([fromHour intValue] * 3600 + [fromMinute intValue] * 60 + [fromSecond floatValue])]];
                }

                NSRange toTextRange   = NSMakeRange(0, toText.length);
                NSArray *matches3           = [regex2 matchesInString:toText options:NSMatchingReportProgress range:toTextRange];
                for (NSTextCheckingResult *match in matches3)
                {
                    //                NSString* matchText = [toText substringWithRange:[match range]];
                    NSRange secondRange = [match rangeAtIndex:4];
                    NSRange milisecondRanage   = [match rangeAtIndex:5];
                    NSString* secondText = [toText substringWithRange:secondRange];
                    NSString* milisecondText = [toText substringWithRange:milisecondRanage];
                    NSRange hourRange = [match rangeAtIndex:2];
                    NSString* hourText = [toText substringWithRange:hourRange];
                    NSRange minuteRange = [match rangeAtIndex:3];
                    NSString* minuteText = [toText substringWithRange:minuteRange];

                    NSNumber* toHour = [NSNumber numberWithInt:[hourText intValue]];
                    NSNumber* toMinute = [NSNumber numberWithInt:[minuteText intValue]];
                    NSNumber* toSecond = [NSNumber numberWithFloat:(float)[secondText intValue] + (float)[milisecondText intValue]/1000];

                    [toHours addObject:toHour];
                    [toMinutes addObject:toMinute];
                    [toSeconds addObject:toSecond];
                    [toTimeElapse addObject:[NSNumber numberWithFloat:([toHour intValue] * 3600 + [toMinute intValue] * 60 + [toSecond floatValue])]];
                }

            }

            NSLog(@"index 0 fromHour: %@", fromHours[0]);
            NSLog(@"index 0 fromMinutes: %@", fromMinutes[0]);
            NSLog(@"index 0 fromSeconds: %@", fromSeconds[0]);
            NSLog(@"index 0 toHours: %@", toHours[0]);
            NSLog(@"index 0 toMinutes: %@", toMinutes[0]);
            NSLog(@"index 0 toSeconds: %@", toSeconds[0]);
            NSLog(@"index 0 subtitleParagraphTexts: %@", subtitleParagraphTexts[0]);
            NSLog(@"index 0 from elapsed time: %@", fromTimeElapse[0]);
            NSLog(@"index 0 to elapsed time: %@", toTimeElapse[0]);

            NSLog(@"index 1000 fromHour: %@", fromHours[1000]);
            NSLog(@"index 1000 fromMinutes: %@", fromMinutes[1000]);
            NSLog(@"index 1000 fromSeconds: %@", fromSeconds[1000]);
            NSLog(@"index 1000 toHours: %@", toHours[1000]);
            NSLog(@"index 1000 toMinutes: %@", toMinutes[1000]);
            NSLog(@"index 1000 toSeconds: %@", toSeconds[1000]);
            NSLog(@"index 1000 subtitleParagraphTexts: %@", subtitleParagraphTexts[1000]);
            NSLog(@"index 1000 from elapsed time: %@", fromTimeElapse[1000]);
            NSLog(@"index 1000 to elapsed time: %@", toTimeElapse[1000]);
            self.vc.fromHours = fromHours;
            self.vc.fromMinutes = fromMinutes;
            self.vc.fromSeconds = fromSeconds;
            self.vc.fromTimeElapse = fromTimeElapse;
            self.vc.toTimeElapse = toTimeElapse;
            self.vc.subtitleTexts = subtitleParagraphTexts;


        }
    }
    ];
}



@end
