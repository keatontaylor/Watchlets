//
//  InterfaceController.m
//  Watchlets WatchKit Extension
//
//  Created by Keaton Taylor on 4/27/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import "InterfaceController.h"
#import "PageImageTitleController.h"
#import "DataController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    
    // Needs to be rebuilt to understand first launch.
    DataController *dataStorage = [DataController dataController];
    
    [dataStorage updateWatchlets];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



