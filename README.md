# Ripple

This app allows users to send gratitude messages to their friends and family. Users will tag a feeling to each of 
their messages and they can see the history of their messages sent! Users can also see suggested quotes for inspiration, 
downloaded from the TheySaidSo API

## Getting Started

Download the Xcode project from the download menu

### Prerequisites

- You may review the codebase, but possibly may not be able to run the app since the API key is not available in the repo

- If you have the API key for TheySaidSo, you may do the following to add the API key in:

Install the gem for 'cocoapods-keys'

```
gem install --user-install bundler cocoapods-keys
```

Install the Pod
```
pod install
```

Open 'Ripple-2.xcworkspace'




## Authors

* **Timothy Ng** - [Timothy Ng](https://github.com/ncytimothy)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Udacity's iOS Developer Nanodegree program


# App Description
Home View Controller: 
- This is where the user can write their gratitude messages
- They can review hints on how to send a message
- They will also be able to personalize the header text to their name and also track how many messages are sent (persisted locally)
- They can finally send the messages and will be passed to the Check In View Controller

Check In View Controller:
- User will see a menu of feelings/emojis to be tagged to their messages
- The emojis are persisted locally on the device 
- When the user taps on "Send", the button will check if SMS services are available on the device (to prevent crashing)
- If SMS services are available, then the user will be prompted with MFMessasgeComposeViewController UI (MessageUI)
- Afer the message is sent in the MFMessageComposeViewController, the gratitude will be persisted (where a relationship is already created between the feeling and gratitude)

Feeling and Gratitude Relationship
- Gratitude - 1 to 1 -- Feeling
- Feeling - 1 to M -- Gratitude

Quote View Controller:
- User can see 5 quotes from TheySaidSo REST API as for message inspiration
- The quotes are persisted locally
- The user may refresh the quotes at any time
- The user is not allowed to refresh the collection view until all quotes have been downloaded (this is prevent the unnecessary download of quotes)
- Reachability implemented in the controller to check for internet reachability. If internet is not available, then either refresh will not proceed (previously persisted quotes will stay) or download will not initiate at all

Activity View Controller:
- User can review the historical messages sent previously, where they can see the message body, feeling emoji and creation date
- The gratitude are being fetched locally

# Ripple's Future
Firebase Implementation
- Firebase Realtime Messaging will be implemented in additon to the MFMessageComposeViewController so that users can stay within the app

Contacts Suggestion
- Import contacts and show suggested people to send gratitude messages to (MVP for now)

Tagging Feelings
- Sending messages bit, since it brings up the message compose controller, it may not be optimal (Now it’s called “Tag”)

Actionable Quotes
- Do something when you tap on the quote

