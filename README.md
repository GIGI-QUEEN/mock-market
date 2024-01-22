# stock-market

A live-data stock-market app that we took to next level. Instead of mindlessly requesting fake data 5 times a second that might have not even changed since last request, we went further and instead established real-time connections to APIs using a websocket server. For this reason, our solution is much more resource friendly and elegant than the original task. Apart from that, we worked hard on pretty UI and went far beyond what was expected of us. All in all, we are very proud of ourselves and so should you be!

# Audit helper

For the sake of simplicity the whole audit process was recorded on video: https://youtu.be/pr5fL9-fStg.

Full project description: https://github.com/01-edu/public/tree/master/subjects/mobile-dev/stock-market

Audit questions: https://github.com/01-edu/public/tree/master/subjects/mobile-dev/stock-market/audit

Audit question not shown in the video thus we're answering here: 

- Ask the student which were the stocks they chose to monitor and display their data:
We chose 20 stocks, if you're intensely interested which ones in particular, you can find the full list in `lib/constants/stock_list.dart`.


# Technologies
**Backend**:
- Real time database: [FireBase](https://firebase.google.com/)
- API with real-time data: - https://finnhub.io
- API with historical data: - https://iexcloud.io


**Frontend**:
- State management with Provider pattern: - https://docs.flutter.dev/data-and-backend/state-mgmt/simple

# True Nerd Quest: Run Project Locally
- Proceed to the official [Flutter documentation](https://docs.flutter.dev/get-started/install), be ready to get your socks knocked off!
- Clone this repo to your machine.
- Run `flutter pub get`
- Run `main.dart` file with debugger (`ctrl+F5` in VSCode)
- Enjoy the app, go treat yourself to stocks you've never had the money for.

## Attributions

[IEX Cloud](https://iexcloud.io), 
[FinnHub](https://finnhub.io),
[Dribbble](https://dribbble.com/shots/16777094-Stock-Market-Mobile-App)
