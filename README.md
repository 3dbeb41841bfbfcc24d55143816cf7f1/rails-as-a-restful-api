---
title: Rails API
type: Lesson
duration: '"1:25"'
creator:
    name: Marc Wright
    city: ATL
competencies: Databases
---

# rails-as-a-restful-api
In unit 3 we're gonna learn how to create and consume an API. As an intro, we're gonna see what this looks like using Rails since you should be intimately familar with the framework by now. This Rails app will have no views, however, we'll test our API using [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel). Later, we'll use jQuery to access it and render info to a page.

> The original idea behind Rails API was to serve as a starting point for a version of Rails better suited for JS-heavy apps. As of today, Rails API provides: trimmed down controllers and middleware stack together with a matching set of generators, all specifically tailored for API type applications.

Objectives

- Create a Rails API to serve JSON data only (no views)
- Test our REST-ful endpoints using [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel)
- **BONUS** - comsume our API using jQuery


## Let's get started...

Check out the [Rails API Gem](https://github.com/rails-api/rails-api) documentation.

1. Let's run `gem install rails-api` to install the gem on our system. You'll need to re-open your Terminal window for the commands to work.

2. Run `rails-api new my_api --database=postgresql -T` to create a new API only Rails app.

3. Add this to the `Gemfile` then `bundle`:

	```ruby
	gem 'rack-cors'
	gem 'active_model_serializers'
	```
[rack-cors](https://github.com/cyu/rack-cors) will help us with CORS request errors. Serialize will help us serve our data as JSON.

4. Let's include our serialization gem by adding the following to 	`application_controller.rb` inside the `class` declaration:

	```ruby
	include ActionController::Serialization
	```
> By the way, what's going on with our inheritance here?

5. Add to `application.rb` inside the `class` declaration:

```ruby
class Application < Rails::Application
	config.api_only = true
end

# This keeps Rails lightweight by only inculding those middlewares needed for an API.
```
## Let's scaffold a todo resource

1) To scaffold our Todo resource...

```ruby
rails g scaffold todo title completed:boolean order:integer
```

2) Run `rake db:create && rake db:migrate`

3) Take a look at our `Todos Controller`

- What do you notice that's different from a regular scaffolded controller?
- Which actions are we missing? Why?
- Why do the actions only respond with JSON?

4) Next, check out `routes.rb`

- What is different? Why?
- run `rake routes`

> Serializers will determine what info is sent to the requesters. We now have a working backend!

## Create a todo using the API

1) Fire up our `rails s`

2) Add the Chrome extension [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel) and open it. ***There will be a little bit of set-up involved the first time you open it. We will walk through it.***

3) Let's make a `GET` request for all the todos. It's essentially the same URL to grab an index view, only we add `.json` to the end of it.

```ruby
http://localhost:3000/todos.json
```

4) This should return an empty array because we have no todos in our database. How could we `POST` a new `Todo` to our database?

```ruby
# send a POST request to this route
http://localhost:3000/todos.json

# Our Todo object, just like what we'd see in our params hash.

{
    "todo": {
        "title": "Adding our First Todo!",
        "completed": false,
        "order": 20
    }
}
```

5) Try the `GET` request from step 3 again. You should have 1 `Todo` in your array.

**YOU DO**

- Add 2 more todos to the database
- `UPDATE` one of the todos
- `DELETE` one of the todos
- Add a `location` field to our Todo model and make it accessible to our API for all CRUD actions.

##Part 2 - using AJAX to access our DB

- Create a new, separate directory called `rails_api_frontend_sample`. Create an `index.html` file and add the code below.
 
```html
<!DOCTYPE html>
<html>
<head>
	<title>AJAX!</title>
</head>
<body>
	<div id="stuff"></div>
	<div id="weather"></div>

	<script type="text/javascript" src='https://code.jquery.com/jquery-2.2.0.min.js'></script>
	<script type="text/javascript">


      var data = $.getJSON('http://localhost:3000/todos.json', function(d){
                        $('#stuff').text("Todo title: " + d.todos[0].title);
                        console.log(d.todos[0]);
                    });

      var weather = $.getJSON('http://api.openweathermap.org/data/2.5/weather?q=Atlanta&appid=3f09349479850459fbb04e503859d422', function(d){
            $('#weather').text("Weather conditions:  " + d.weather[0].main);
            console.log(d.weather[0]);
         });

    </script>
</body>
</html>
```

- Start Python Simple Server by running `python -m SimpleHTTPServer 8080`. This  is a basic HTTP server that you have installed on your Mac. It's a simple, lightweight option to serve static assets (HTML, CSS, JS). We need a server in order to make AJAX requests.

- If you encounter any [CORS](http://leopard.in.ua/2012/07/08/using-cors-with-rails/) errors or issues, add this Chrome extension called [Allow-Control-Request-Origin](https://chrome.google.com/webstore/detail/allow-control-allow-origi/nlfbmbojpeacfghkpbjhddihlkkiljbi) and turn it on. Check out the link above to dig deeper into CORS.

- Add this code to `application_controller.rb` and `developement.rb` if you STILL encounter any CORS errors or issues: 

```ruby
# application_controller.rb
before_filter :add_allow_credentials_headers

  def add_allow_credentials_headers                                                                                                                                                                                                                                                        
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5                                                                                                                                                                                                      
    #                                                                                                                                                                                                                                                                                       
    # Because we want our front-end to send cookies to allow the API to be authenticated                                                                                                                                                                                                   
    # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so                                                                                                                                                                                                      
    # the browser will not reject the response                                                                                                                                                                                                                                             
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'                                                                                                                                                                                                     
    response.headers['Access-Control-Allow-Credentials'] = 'true'                                                                                                                                                                                                                          
  end 

  def options                                                                                                                                                                                                                                                                              
    head :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type'                                                                                                                                                                                                         
  end
  
# development.rb
config.debug_exception_response_format = :api
```

don't forget about :null_session

### BONUS

Using the lesson above, see if you can access any movies from the [Open Movie Database](http://omdbapi.com/)
### Helpful Tutorials
[Rails API Docs](https://github.com/rails-api/rails-api)

[Rails API Tutorial](https://wyeworks.com/blog/2015/6/11/how-to-build-a-rails-5-api-only-and-backbone-application)

[CORS + Rails](http://leopard.in.ua/2012/07/08/using-cors-with-rails/)