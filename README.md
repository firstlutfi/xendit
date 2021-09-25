### How to run this project  
- install chromedriver according to your current chrome version  
- install ruby (I use version 2.7.3)  
- run ```gem install bundler``` if you've never done this previously  
- run ```bundle install```  
- rename or copy ```.env.sample``` to ```.env```
- run ```cucumber```   

### Report  
After cucumber has finished, the report is automatically generated at ```report``` directory. Open the ```test_result.html``` file using your favorite browser.  If the scenario is failed, the report will also attach a screenshot of last opened browser page.
  
### Code Convention  
I use [rubocop](https://github.com/rubocop/rubocop) gem for static code analyzer. You can simply run ```rubocop``` in terminal to check whether there is code style violation.