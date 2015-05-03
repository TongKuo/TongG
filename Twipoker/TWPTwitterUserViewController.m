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

#import "TWPTwitterUserViewController.h"
#import "TWPTwitterUserView.h"
#import "TWPLoginUsersManager.h"

@implementation TWPTwitterUserViewController

@dynamic twitterUserView;

- ( void ) setTwitterUserView: ( TWPTwitterUserView* )_TwitterUserView
    {
    [ self setView: _TwitterUserView ];
    }

- ( TWPTwitterUserView* ) twitterUserView
    {
    return ( TWPTwitterUserView* )self.view;
    }

#pragma mark Initialization
+ ( instancetype ) twitterUserViewControllerWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    return [ [ [ self class ] alloc ] initWithTwitterUser: _TwitterUser ];
    }

- ( instancetype ) initWithTwitterUser: ( OTCTwitterUser* )_TwitterUser
    {
    if ( self = [ super initWithNibName: @"TWPTwitterUserView" bundle: [ NSBundle mainBundle ] ] )
        {
        [ self.twitterUserView setTwitterUser: _TwitterUser ];

        [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
            getUserTimelineWithScreenName: self.twitterUserView.twitterUser.screenName
                                    count: self.numberOfTweetsWillBeLoadedOnce
                             successBlock:
                ^( NSArray* _TweetObjects )
                    {
                    for ( NSDictionary* _TweetObject in _TweetObjects )
                        [ self->_tweets addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                    self->_sinceID = [ ( OTCTweet* )self->_tweets.firstObject tweetID ];
                    self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                    [ self.timelineTableView reloadData ];
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    [ self presentError: _Error ];
                                    } ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do view setup here.
    }

#pragma mark Conforms to <TWPTimelineScrollViewDelegate>
- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchOlderTweets: ( NSClipView* )_ClipView
    {
    if ( !self.isLoadingOlderTweets )
        {
        self.isLoadingOlderTweets = YES;
        NSLog( @"%s", __PRETTY_FUNCTION__ );

        [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
            getStatusesUserTimelineForUserID: self.twitterUserView.twitterUser.IDString
                                    screenName: nil
                                  sinceID: nil
                                    count: @( self.numberOfTweetsWillBeLoadedOnce ).stringValue
                                    maxID: @( self->_maxID - 1 ).stringValue
                                 trimUser: @NO
                           excludeReplies: @0
                       contributorDetails: @YES
                          includeRetweets: @YES
                                successBlock:
            ^( NSArray* _TweetObjects )
                {
                for ( NSDictionary* _TweetObject in _TweetObjects )
                    {
                    // Data source did finish loading older tweets
                    self.isLoadingOlderTweets = NO;

                    OTCTweet* tweet = [ OTCTweet tweetWithJSON: _TweetObject ];

                    // Duplicate tweet? Get out of here!
                    if ( ![ self->_tweets containsObject: tweet ] )
                        [ self->_tweets addObject: tweet ];
                    }

                self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                [ self.timelineTableView reloadData ];
                } errorBlock: ^( NSError* _Error )
                                {
                                // Data source did finish loading older tweets due to the error occured
                                self.isLoadingOlderTweets = NO;
                                [ self presentError: _Error ];
                                } ];
        }
    }

- ( void ) timelineScrollView: ( TWPTimelineScrollView* )_TimelineScrollView
       shouldFetchLaterTweets: ( NSClipView* )_ClipView
    {
    NSLog( @"%s", __PRETTY_FUNCTION__ );
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