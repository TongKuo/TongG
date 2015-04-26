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

#import "TWPHomeTimelineScrollViewController.h"
#import "TWPLoginUsersManager.h"

@implementation TWPHomeTimelineScrollViewController

#pragma mark Initialization
- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->_tweets = [ NSMutableArray array ];
        self.isLoadingOlderTweets = NO;
        self.numberOfTweetsWillBeLoadedOnce = 20;

        [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
            getHomeTimelineSinceID: nil count: self.numberOfTweetsWillBeLoadedOnce successBlock:
                ^( NSArray* _TweetObjects )
                    {
                    for ( NSDictionary* _TweetObject in _TweetObjects )
                        [ self->_tweets addObject: [ OTCTweet tweetWithJSON: _TweetObject ] ];

                    self->_sinceID = [ ( OTCTweet* )self->_tweets.firstObject tweetID ];
                    self->_maxID = [ ( OTCTweet* )self->_tweets.lastObject tweetID ];

                    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                                selector: @selector( tableViewDataSourceShoulLoadOlderTweets: )
                                                                    name: TWPTimelineTableViewDataSourceShouldLoadOlderTweets
                                                                  object: nil ];

                    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                                selector: @selector( tableViewDataSourceShoulLoadLaterTweets: )
                                                                    name: TWPTimelineTableViewDataSourceShouldLoadLaterTweets
                                                                  object: nil ];
                    [ self.timelineTableView reloadData ];
                    } errorBlock: ^( NSError* _Error )
                                    {
                                    [ self presentError: _Error ];
                                    } ];
        }

    return self;
    }

- ( void ) tableViewDataSourceShoulLoadOlderTweets: ( NSNotification* )_Notif
    {
    [ [ [ TWPLoginUsersManager sharedManager ] currentLoginUser ].twitterAPI
        getStatusesHomeTimelineWithCount: @( self.numberOfTweetsWillBeLoadedOnce).stringValue
                                 sinceID: nil
                                   maxID: @( self->_maxID - 1 ).stringValue
                                trimUser: @NO
                          excludeReplies: @0
                      contributorDetails: @YES
                         includeEntities: @YES
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

- ( void ) tableViewDataSourceShoulLoadLaterTweets: ( NSNotification* )_Notif
    {
    NSLog( @"Later!" );
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