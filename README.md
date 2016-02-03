# Slack Notification for Braintree

This is an example of a notification service for pushing Braintree transactions into Slack channels.

## Dependencies

It was written against ruby 2.1.2, so uses Psych instead of the YAML module for the configuration.

Uses the [`slack-notify`](https://github.com/sosedoff/slack-notify) gem to wrap the [Slack API](api.slack.com). 

## Usage

Once you've inscluded this is your app, and configured it with your [Slack webhook enpoint](https://api.slack.com/incoming-webhooks), you'd call simply pass a Braintree transaction object into it when it suits your needs:

`SlackNotificationSevice.new.transaction_notification(braintree_transaction)`