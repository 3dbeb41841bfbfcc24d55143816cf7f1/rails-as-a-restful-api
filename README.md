---
title: Rails API
type: Lesson
duration: '"1:25"'
creator:
    name: Marc Wright
    city: ATL
competencies: Databases
---

# Rails as a REST-ful API
In Unit 3 we're gonna learn how to create and consume an API. As an intro, we're gonna see what this looks like using Rails since you should be intimately familar with the framework by now. This Rails app will have no views, however, we'll test our API using [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel). Later, we'll use jQuery to access it and render data onto a page.

> The original idea behind Rails API was to serve as a starting point for a version of Rails better suited for JS-heavy apps. As of today, Rails API provides: trimmed down controllers and middleware stack together with a matching set of generators, all specifically tailored for API type applications.

You can actually check this out by going to an index view of your Project 2 and typing `.json` to the end of the URL. Note- this *should* work if you scaffolded your resources.

**Objectives**

- Create a Rails API to serve JSON data only (no views)
- Test our REST-ful endpoints using [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel)
- Consume our API using jQuery


## Let's get started with the Rails API...

Check out the [Rails API Gem](https://github.com/rails-api/rails-api) documentation.

1. Let's run `gem install rails-api` to install the gem. You may need to re-open your Terminal window for the commands to work.

2. Run `rails-api new my_api --database=postgresql -T` to create a new API only Rails app.

3. Add this to the `Gemfile` then `bundle install`:

	```ruby
	gem 'rack-cors'
	gem 'active_model_serializers'
	```
[rack-cors](https://github.com/cyu/rack-cors) will help us with CORS request errors. Serialize will help us serve our data as a serialized JSON object.

4. Let's include our serialization gem by adding the following to 	`application_controller.rb` inside the `class` declaration:

	```ruby
	class ApplicationController < ActionController::API
		include ActionController::Serialization
	end
	```
> By the way, what's going on with our inheritance here?

5. Add to the following to `application.rb` inside the `class` declaration:

```ruby
module MyApiAgain
	class Application < Rails::Application
		config.api_only = true		
		...		
	end
end

# This keeps Rails lightweight by only inculding those middlewares needed for an API.
```
## Let's scaffold a Todo resource

1. To scaffold our Todo resource:

	```ruby
	rails g scaffold todo title completed:boolean order:integer
	```

2. Run `rake db:create && rake db:migrate`

3. Take a look at `controllers/todos_controller.rb`

	- What do you notice that's different from a regular scaffolded controller?
	- Which actions are we missing? Why?
	- Why do the actions only respond with JSON?

4.	 Next, check out `config/routes.rb` then run `rake routes`. What is different and why?

> Serializers will determine what info is sent to the requesters. We now have a working backend!

## Create a todo using the API

1. Fire up our `rails s` and goto `http://localhost:3000/todos`. What is returned?

2. Add the Chrome extension [Insominia](https://chrome.google.com/webstore/detail/insomnia-rest-client/gmodihnfibbjdecbanmpmbmeffnmloel) and open it. We're gonna use Insomnia to make HTTP requests and interact with our Rails server via the API we created. ***There will be a little bit of set-up involved the first time you open it. We will walk through it.***

3. Let's make a `GET` request for all the todos. It's essentially the same URL to grab an index view, only we add `.json` to the end of it.

	```ruby
	http://localhost:3000/todos.json
	```
![screenshot](insomnia_get_request.png)

4. This should return an empty array because we have no todos in our database. How could we `POST` a new `Todo` to our database?

	```ruby
	# send a POST request to this route
	http://localhost:3000/todos.json

	# Our Todo object, just like what 	we'd see in our params hash.

	{
 	   "todo": {
    	    "title": "Adding our First Todo!",
    	    "completed": false,
    	    "order": 20
    	}
	}
	```
![screenshot](insomnia_post_request.png)

5. After step 4 we should see a `Success 201` message! Try the `GET` request from step 3 again. You should now have one `Todo` in your array.

	![screenshot](insomnia_get_request_one_todo.png)

**YOU DO**

- Using Insomnia, add two more todos to the database
- Using Insomnia, `UPDATE` one of the todos
- Using Insomnia, `DELETE` one of the todos
- Add a `location` field to our Todo model and make it accessible to our API for all CRUD actions. **HINT:** check out the `app/serializers/todo_serializers.rb` file. What is it doing?

##Part 2 - Using AJAX to access our DB

The beauty of hosting our database separately is that it is decoupled from the client. This gives us flexibility and options. We could create an Angular front-end, an Ionic mobile app, or a static html page and they can all access our API. 

We're gonna dive into AngularJS in unit 4. However, we can accomplish some of the same behavior using jQuery. Let's see what that looks like by building a basic `index.html` page that will consume our API.

1. In your `ga` folder, create a new folder called `rails_api_frontend_sample`. Create an `index.html` file and add the code below.
 
	```html
<!DOCTYPE html>
<html>
<head>
	<title>AJAX!</title>
</head>
<body>
	<div id="todo"></div>

	<script type="text/javascript" src='https://code.jquery.com/jquery-2.2.0.min.js'></script>
	<script type="text/javascript">


      $.getJSON('http://localhost:3000/todos.json', function(data){
         $('#todo').text("Todo title: " + data.todos[0].title);
         console.log(data.todos[0]);
      });

    </script>
</body>
</html>
	```

2. Let's break down what `$.getJSON()` is doing:
	- `$.getJSON()` is a jQuery method that takes a URL and a callback as arguments.
	- The `data` object that is returned can be passed in to the callback itself as an argument.
	- We insert the title of our Todo into the `#todo` element using the jQuery method `.text()`.


2. Start Python Simple Server by running `python -m SimpleHTTPServer 8080`. This  is a basic HTTP server that you have installed on your Mac. It's a simple, lightweight option to serve static assets (HTML, CSS, JS). We need a server in order to make AJAX requests.

3. If you encounter any [CORS](http://leopard.in.ua/2012/07/08/using-cors-with-rails/) errors or issues, add this Chrome extension called [Allow-Control-Request-Origin](https://chrome.google.com/webstore/detail/allow-control-allow-origi/nlfbmbojpeacfghkpbjhddihlkkiljbi) and turn it on.

4. Add this code to `application_controller.rb` and `developement.rb` if you STILL encounter any CORS errors or issues: 

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

> Also, try adding `:null_session` to `application_controller.rb` if you encounter more Insomnia errors.




## BONUS

Using the lesson above, see if you can access a movie from the [Open Movie Database](http://omdbapi.com/) and render some data. 

## DOUBLE BONUS

Using the lesson above, see if you can render Atlanta's current weather data from the [Open Weather Map API](http://openweathermap.org/api). NOTE - You'll need to register for an API key.


<details>
  <summary>Possible solution to Bonuses</summary>

```javascript
<!DOCTYPE html>
<html>
	<head>
		<title>AJAX!</title>
	</head>
	<body>
		<h1>AJAX!</h1>
		<div id="todo"></div><br>
		<div id="movie"></div><br>
		<div id="weather"></div>

		<script type="text/javascript" src='https://code.jquery.com/jquery-2.2.0.min.js'></script>
		<script type="text/javascript">


		  $.getJSON('http://localhost:3000/todos.json', function(data){
		     $('#todo').text("Todo location: " + data.todos[1].location);
		     console.log(data);
		  });

		  $.getJSON('http://www.omdbapi.com/?t=batman&y=1989&plot=full&r=json', function(data){
		  	$("#movie").html("<div>Title: " + data.Title + "</div><div>Release: " + data.Released + "</div>");
		  })

		  $.getJSON('http://api.openweathermap.org/data/2.5/weather?q=Atlanta&appid=< YOUR-API-KEY-HERE >', function(data){
		  	$("#weather").text("Atlanta's current weather is: " + data.weather[0].description);
		  })


		</script>
	</body>
</html>
```
       
</details>

### Helpful Tutorials
[Rails API Docs](https://github.com/rails-api/rails-api)

[Rails API Tutorial](https://wyeworks.com/blog/2015/6/11/how-to-build-a-rails-5-api-only-and-backbone-application)

[CORS + Rails](http://leopard.in.ua/2012/07/08/using-cors-with-rails/)