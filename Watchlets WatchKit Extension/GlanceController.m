//
//  GlanceController.m
//  Watchlets WatchKit Extension
//
//  Created by Keaton Taylor on 4/27/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import "GlanceController.h"
#import "DataController.h"


@interface GlanceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *TitleLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *BodyLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *Image;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *TitleImage;

@end


@implementation GlanceController


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [self buildGlance];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.BodyLabel.text = @"Updating...";
    [self.Image setHidden:YES];
    [self buildGlance];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)buildGlance {
    DataController *dataController = [DataController dataController];
    [dataController fetchWatchlets];
    
    DataStructure *structure = [dataController.content objectAtIndex:0];
    
    if(structure.Image != nil && structure.Title !=nil) {
        [self.TitleImage setImage:structure.Image];
        self.TitleLabel.text = structure.Title;
        self.BodyLabel.text = structure.Body;
        [self.Image setHidden:YES];
        [self.TitleImage setHidden:NO];
    }
    else if (structure.Title != nil && structure.Image == nil) {
        self.TitleLabel.text = structure.Title;
        self.BodyLabel.text = structure.Body;
        [self.Image setHidden:YES];
        [self.TitleImage setHidden:YES];
    }
    else if (structure.Image != nil && structure.Title == nil) {
        self.TitleLabel.text = @"Watchlets";
        [self.Image setImage:structure.Image];
        [self.TitleImage setHidden:YES];
        [self.Image setHidden:NO];
    }
    else {
        self.TitleLabel.text = @"Watchlets";
        self.BodyLabel.text = structure.Body;
        [self.Image setHidden:YES];
        [self.TitleImage setHidden:YES];
    }
}

@end



