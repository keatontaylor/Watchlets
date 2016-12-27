//
//  MainViewController.h
//  Watchlets
//
//  Created by Keaton Taylor on 4/29/15.
//  Copyright (c) 2015 iverted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController <UIWebViewDelegate>

@property (nonatomic) NSMutableArray *URL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSUserDefaults *sharedDefaults;

@end