# CarbonIT Images Search

CarbonIT technical test application

## Roadmap

:white_check_mark: Page to display search results  
:white_check_mark: Page to display favorites images  
:white_check_mark: Bonus : No result for search  
:white_check_mark: Bonus : In favorites page, redirect user to search page if no favorites  

### More bonus
:white_check_mark: Pagination (load more items when scrolling to bottom)  
:white_check_mark: Styling app  
:white_check_mark: Displaying error / loading / empty / success states  
...

## Usage

Update `lib/injection.dart` line 38, replace `final apiKey = Secrets.apiKey;` with `final apiKey = "<your key here>";` or create a `lib/secrets.dart` file as this :
```
class Secrets {
  static final apiKey = '<your key here>';
}
```

## Demo

https://github.com/user-attachments/assets/85855211-638a-4a28-abe9-5e227eb29a5c
