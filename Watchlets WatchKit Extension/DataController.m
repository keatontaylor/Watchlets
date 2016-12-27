//
//  DataController.m
//  Watchlets WatchKit Extension
//
//  Created by Keaton Taylor on 4/27/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import "DataController.h"

@implementation DataController

#pragma mark Singleton Methods



+ (id)dataController {
    static DataController *sharedDataController = nil;
    @synchronized(self) {
        if (sharedDataController == nil)
            sharedDataController = [[self alloc] init];
    }
    return sharedDataController;
}


- (void)updateWatchlets {
        [self fetchWatchlets];
        [self buildPages];
}

- (void)buildPages {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.content count]; i++) {
        [controllers addObject:[NSString stringWithFormat:@"%i",i]];
        DataStructure *structure = [self.content objectAtIndex:i];
        if(structure.Image != nil && structure.Title !=nil)
            [array addObject:@"PageImageTitleController"];
        else if (structure.Title != nil && structure.Image == nil)
            [array addObject:@"PageTitleController"];
        else if (structure.Image != nil && structure.Title == nil)
            [array addObject:@"ImageController"];
        else
            [array addObject:@"PageController"];
    }
    
    // Reload the controllers with the pages. Can also be called to reload new pages.
    [WKInterfaceController reloadRootControllersWithNames:array contexts:controllers];
}

- (NSArray*)fetchWatchlets {
    
    // We are fetching all the data again, so we need to clear the content NSMutableArray and grab any newly added URLs from the iOS companion app.
    self.content = [[NSMutableArray alloc] init];
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.sharedWatchlets"];
    
    if ( [[mySharedDefaults objectForKey:@"savedURLs"] objectAtIndex:0] == nil ) {
         [self.content addObject:[[DataStructure alloc] initWithID:nil Title:@"No URLs" Body:@"Please go into the Watchlets iPhone app and add a URL pointing to your JSON resource" Image:[UIImage imageNamed:@"stop"]]];
    }
    else {
        for (int i = 0; i < [[mySharedDefaults objectForKey:@"savedURLs"] count]; i++) {
            [self download:[[mySharedDefaults objectForKey:@"savedURLs"] objectAtIndex:i]];
        }
    }
    
    self.lastUpdate = [NSDate date];
    
    return self.content;
}

- (void)download:(NSString*)URL {
    
    // Create a a data structure for storing the data for each watchlet. (See DataStructure class)
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    // Something went wrong with the download, show the error to the user.
    if (!data) {
        [self.content addObject:[[DataStructure alloc] initWithID:nil Title:@"Error" Body:[NSString stringWithFormat:@"URL:%@\n%@",URL, [error localizedDescription]] Image:[UIImage imageNamed:@"stop"]]];
        return;
    }
    
    // Begin JSON decode.
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    // Something went wrong with decode, show the error to the user.
    if (!JSON) {
        [self.content addObject:[[DataStructure alloc] initWithID:nil Title:@"Parse Error" Body:[NSString stringWithFormat:@"URL:%@\n%@",URL, [error debugDescription]] Image:[UIImage imageNamed:@"stop"]]];
        return;
    }

    // Alright everything looks good, lets add the watchlets to the app.
    NSArray *content = [JSON valueForKeyPath:@"content"];
    for (int i = 0; i < [content count]; i++) {
        
        
        NSData *imageData = nil;
        if ([[content objectAtIndex:i] valueForKey:@"image"] !=nil) {
            [NSURL URLWithString:[[content objectAtIndex:i] valueForKey:@"image"]];
             NSURL *url = [NSURL URLWithString:[[content objectAtIndex:i] valueForKey:@"image"]];
            imageData = [NSData dataWithContentsOfURL:url];
           
        }
        
       [self.content addObject:[[DataStructure alloc] initWithID:[[content objectAtIndex:i] valueForKey:@"id"] Title:[[content objectAtIndex:i] valueForKey:@"title"] Body:[[content objectAtIndex:i] valueForKey:@"text"] Image:[UIImage imageWithData:imageData]]];
    
    }
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end

@implementation DataStructure

- (id)initWithID:(NSString*)ID Title:(NSString*)title Body:(NSString*)body Image:(UIImage*)image
{
    self = [self init];
    if(self) {
        self.ID = ID;
        self.Title = title;
        self.Body = body;
        self.Image = image;
    }
    return self;
}

@end




