//
//  DataController.h
//  Watchlets WatchKit Extension
//
//  Created by Keaton Taylor on 4/27/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//


#import <WatchKit/WatchKit.h>
#import <foundation/Foundation.h>

@interface DataController : NSObject

@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSDate *lastUpdate;

+ (id)dataController;
- (void)updateWatchlets;
- (NSArray*)fetchWatchlets;

@end

@interface DataStructure : NSObject

@property (copy) NSString *ID;
@property (copy) NSString *Title;
@property (copy) UIImage *Image;
@property (copy) NSString *Body;

- (id)initWithID:(NSString*)ID Title:(NSString*)title Body:(NSString*)body Image:(UIImage*)image;

@end
