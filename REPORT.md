# MP Report

## Team

- Name(s): Aditya Niture
- AID(s): A12345678

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] Decks can be created, edited, and deleted
- [X] Cards can be created, edited, sorted, and deleted
- [X] Quizzes work correctly
- [X] Decks and Cards can be loaded from the JSON file
- [X] Decks and Cards are saved/loaded correctly from/to a SQLite database
- [X] The UI is responsive to changes in screen size

## Summary and Reflection

we made some key choices to make sure everything worked smoothly and was easy to use. One big decision was using the Provider pattern for managing the app's state. This helped keep things organized and made it simple to handle data across different screens and widgets. We also focused on building custom widgets and modular components, which made the code more reusable and easier to maintain.
During development, one of the main challenges we faced was getting Firebase Firestore to work seamlessly. Wanting real-time data updates and offline support, but syncing local and remote data turned out to be trickier than expected. Because of time limits and compatibility issues with APIs, I couldn't fully achieve the level of reliability I wanted.

I really liked diving into this peoject and figuring out how to build an app that work on Android without a ton of extra work. It was neat to see how easy it was to put together a good-looking user interface using Flutter's widgets, and I liked how we could tweak things to look just right.

But there were definitely some tough parts too. Getting Firebase Firestore to play nicely was trickier than I expected. I spent a lot of time trying to make sure the app could handle updates in real-time and work offline, and sometimes it felt like I was fighting with Firebase instead of it helping me out. Looking back, I wish I had dug deeper into Firebase before I started coding so I could have avoided some of those headaches.

Overall, this project was a great learning experience. I got a good handle on managing the data in the app and connecting it to the cloud, even if it was a bit bumpy at times. Moving forward, I'm excited to keep building on what I've learned here and try out new things to make even cooler apps in the future.