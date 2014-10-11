Twitter-Swift
=============
# Twitter Demo

This is an iOS Swift demo application for displaying the Twitter home line and new tweet composition using the [Twitter API](https://dev.twitter.com/overview/documentation).

Time spent: 8 hours spent in total

Completed user stories:

 * [x] Required: User can sign in using OAuth login flow
 * [x] Required: User can view last 20 tweets from their home timeline
 * [x] Required: The current signed in user will be persisted across restarts
 * [x] Required: In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 * [x] Required: The filters table should be organized into sections as in the mock.
 * [x] Required: User can compose a new tweet by tapping on a compose button.
 * [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.


Stories not implemented:
 * Required: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 * Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * Optional: Retweeting and favoriting should increment the retweet and favorite count.
 * Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 * Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet.
 * Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

![Video Walkthrough](twitter.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
