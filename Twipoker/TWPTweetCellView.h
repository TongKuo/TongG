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

@import Cocoa;

@class OTCTweet;
@class OTCTwitterUser;
@class TWPUserAvatarWell;
@class TWPTimelineUserNameButton;
@class TWPTextView;
@class TWPTweetOperationsPanelView;

// Notification Names
NSString extern* const TWPTweetCellViewShouldDisplayDetailOfTweet;

// User Info Keys
NSString extern* const TWPTweetCellViewTweetUserInfoKey;

// TWPTweetCellView class
@interface TWPTweetCellView : NSTableCellView
    {
@private
    OTCTweet __strong* _tweet;
    CGFloat _refHeight;
    }

#pragma mark Outlets
@property ( weak ) IBOutlet TWPUserAvatarWell* authorAvatarWell;
@property ( weak ) IBOutlet TWPTimelineUserNameButton* userNameLabel;
@property ( weak ) IBOutlet TWPTextView* tweetTextView;

@property ( weak ) IBOutlet TWPTweetOperationsPanelView* tweetOperationsPanel;

@property ( strong, readwrite ) OTCTweet* tweet;
@property ( strong, readonly ) OTCTwitterUser* author;

@property ( weak ) IBOutlet NSLayoutConstraint* topSpaceConstraint;
@property ( weak ) IBOutlet NSLayoutConstraint* spaceBetweenUserNameLabelAndTextView;
@property ( weak ) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

#pragma mark Properties
@property ( assign, readonly ) CGFloat refHeight; 

#pragma mark Initialization
+ ( instancetype ) tweetCellViewWithTweet: ( OTCTweet* )_Tweet;
- ( instancetype ) initWithTweet: ( OTCTweet* )_Tweet;

#pragma mark IBAction
- ( IBAction ) userNameLabelClickedAction: ( id )_Sender;
- ( IBAction ) userAvatarClickedAction: ( id )_Sender;

@end // TWPTweetCellView class

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