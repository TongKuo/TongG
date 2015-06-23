/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Guo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "TWPMainWindowContentViewController.h"

#import "TWPDashboardViewController.h"
#import "TWPTimelineScrollView.h"
#import "TWPNavigationBarController.h"
#import "TWPStackContentView.h"
#import "TWPStackContentViewController.h"

#import "TWPTweetingBoxNotificationNames.h"
#import "TWPCuttingLineView.h"
#import "TWPTweetingCompleteBox.h"
#import "TWPTimelineUserNameButton.h"

@interface TWPMainWindowContentViewController ()

@end

@implementation TWPMainWindowContentViewController

@synthesize dashboardViewController;
@synthesize navigationBarController;
@synthesize stackContentViewController;

@synthesize cuttingLineBetweenNavBarAndViewsStack;

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view removeConstraints: self.view.constraints ];

    NSView* navBar = self.navigationBarController.view;
    NSView* horizontalCuttingLine = self.cuttingLineBetweenNavBarAndViewsStack;
    NSView* stackContentView = self.stackContentViewController.view;
    NSView* dashboardView = self.dashboardViewController.view;

    [ navBar setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ horizontalCuttingLine setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ stackContentView setTranslatesAutoresizingMaskIntoConstraints: NO ];
    [ dashboardView setTranslatesAutoresizingMaskIntoConstraints: NO ];

    [ self.view addSubview: navBar ];
    [ self.view addSubview: horizontalCuttingLine ];
    [ self.view addSubview: stackContentView ];

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( navBar, horizontalCuttingLine, stackContentView, dashboardView );

    NSArray* horizontalConstraints0 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][navBar(>=navBarWidth)]|"
                            options: 0
                            metrics: @{ @"dashboardViewWidth" : @( NSWidth( dashboardView.frame ) )
                                      , @"navBarWidth" : @( NSWidth( navBar.frame ) )
                                      , @"cuttingLineWidth" : @( NSHeight( horizontalCuttingLine.frame ) )
                                      , @"stackContentViewWidth" : @( NSWidth( stackContentView.frame ) )
                                      , @"dashboardViewWidth" : @( NSWidth( dashboardView.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* verticalConstraints0 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|[dashboardView(>=dashboardViewHeight)]|"
                            options: 0
                            metrics: @{ @"dashboardViewHeight" : @( NSHeight( dashboardView.frame ) )
                                      , @"navBarHeight" : @( NSHeight( navBar.frame ) )
                                      , @"cuttingLineWidth" : @( NSHeight( horizontalCuttingLine.frame ) )
                                      , @"stackContentViewHeight" : @( NSHeight( stackContentView.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* verticalConstraints1 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"V:|[navBar(==navBarHeight)][horizontalCuttingLine(==cuttingLineHeight)][stackContentView(>=stackContentViewHeight)]|"
                            options: 0
                            metrics: @{ @"navBarHeight" : @( NSHeight( navBar.frame ) )
                                      , @"cuttingLineHeight" : @( NSHeight( horizontalCuttingLine.frame ) )
                                      , @"stackContentViewHeight" : @( NSHeight( stackContentView.frame ) )
                                      }
                              views: viewsDict ];

    NSArray* horizontalConstraints1 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][horizontalCuttingLine(==navBar)]|"
                            options: 0
                            metrics: @{ @"dashboardViewWidth" : @( NSWidth( dashboardView.frame ) ) }
                              views: viewsDict ];

    NSArray* horizontalConstraints2 = [ NSLayoutConstraint
        constraintsWithVisualFormat: @"H:|[dashboardView(==dashboardViewWidth)][stackContentView(==navBar)]"
                            options: 0
                            metrics: @{ @"dashboardViewWidth" : @( NSWidth( dashboardView.frame ) ) }
                              views: viewsDict ];

    [ self.view addConstraints: horizontalConstraints0 ];
    [ self.view addConstraints: verticalConstraints0 ];
    [ self.view addConstraints: verticalConstraints1 ];
    [ self.view addConstraints: horizontalConstraints1 ];
    [ self.view addConstraints: horizontalConstraints2 ];
    }

@end

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/