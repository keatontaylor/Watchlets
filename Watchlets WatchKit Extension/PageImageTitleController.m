//
//  InterfaceController.m
//  Watchlets WatchKit Extension
//
//  Created by Keaton Taylor on 4/27/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import "PageImageTitleController.h"
#import "DataController.h"

@interface PageImageTitleController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *TitleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *Image;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *BodyLabel;
@property (nonatomic) NSString *ID;
@property (nonatomic, retain) DataController *dataStorage;

@end

@implementation PageImageTitleController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    // Get our data structure value
    self.dataStorage = [DataController dataController];
    DataStructure *structure = [self.dataStorage.content objectAtIndex:[context integerValue]];
    [self setData:structure];
    
    // Add menu items for supported update functions
    [self addMenuItemWithItemIcon:WKMenuItemIconResume title:@"Refresh All" action:@selector(RefreshAll)];
    if (structure.ID != nil) {
        [self addMenuItemWithItemIcon:WKMenuItemIconResume title:@"Refresh Current" action:@selector(RefreshCurrent)];
        self.ID = structure.ID;
    }    
}

- (void)RefreshCurrent {
    NSArray *newData = [self.dataStorage fetchWatchlets];
    for (int i = 0; i < [newData count]; i++) {
        DataStructure *structure = [newData objectAtIndex:i];
        if ([structure.ID isEqualToString:self.ID]) {
            [self setData:structure];
        }
    }
}

- (void)RefreshAll {
    [self.dataStorage updateWatchlets];
}

- (void)setData:(DataStructure*)structure {
    self.TitleLabel.text = structure.Title;
    self.BodyLabel.text = structure.Body;
    [self.Image setImage:structure.Image];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    // Save either the
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end


