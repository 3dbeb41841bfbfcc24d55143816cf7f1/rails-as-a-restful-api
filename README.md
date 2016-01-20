# rails-as-a-restful-api


We're gonna create a Rails app that only uses the API, no views. We'll then access our API using Insomnia. Later, we'll use jQuery to access it and render info to a page.

> The original idea behind Rails API was to serve as a starting point for a version of Rails better suited for JS-heavy apps. As of today, Rails API provides: trimmed down controllers and middleware stack together with a matching set of generators, all specifically tailored for API type applications.


## Let's get started...

Check out the [Rails API Gem](https://github.com/rails-api/rails-api) documentation.

1) run `gem install rails-api`

2) run `rails-api new my_api`

3) Add this to the `Gemfile` then `bundle`:

```ruby
# Gemfile
gem 'rack-cors'
gem 'active_model_serializers'
```


4) Add to `application_controller.rb`

```ruby
include ActionController::Serialization
```

5) Add to `application.rb` inside the class:

```ruby
class Application < Rails::Application
	config.api_only = true
	...
end
```

> This makes Rails more lightweight by only using middlewares need for our API.

## Let's scaffold a todo resource

1) From the command line run

```ruby
rails g scaffold todo title completed:boolean order:integer
```

2) Run `rake db:create` (if using postgresql) then `rake db:migrate`

3) Take a look at our Todos Controller...

- What do you notice that's different from a regular scaffolded controller?
- Which actions are we missing? Why?
- What do the actions only respond in JSON?

4) Also check out `routes.rb`...

- What is different?
- run `rake routes`

5) How are we going to determine how our JSON data is returned? Using serializers:

```ruby
# run on the command line
rails g serializer todo title completed order
```

> This determines what info is sent to the requesters. We now have a working backend!

## Create a todo using the API

1) Fire up our `rails s`

2) Open Insominia

3) How do we make a request for all the todos? Make `GET` request to this URL to get all the todos...

```ruby
http://localhost:3000/todos.json
```

4) How could we `POST` a new todo to our database?

```ruby
# POST request to this route
http://localhost:3000/todos.json

# Our Todo object
{
    "todo": {
        "title": "Adding our First Todo!",
        "completed": false,
        "order": 20
    }
}
```

5) Try the `GET` request from step 3 again. You should have 1 Todo in your array.

**YOU DO**

- Add 2 more todos to the database
- `UPDATE` one of the todos
- `DELETE` one of the todos

**BONUS**
- Add a new field to our Todo model and make it accessible to our API for all CRUD actions.

##Part 2 - using AJAX to access our DB

- `index.html` completed:
 
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
    	$('#stuff').text(d.todos);
  		console.log(d.todos);
  		});

	  var weather = $.getJSON('http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2de143494c0b295cca9337e1e96b00e0', function(d){
	    $('#weather').text(d.weather[0].main);
	  console.log(d.weather[0]);
	  });

	</script>
</body>
</html>
```

- Python Simple Server `python -m SimpleHTTPServer 8080`

- If you're having any issues, check this out:

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
### Helpful Tutorials
[Rails API Docs]('https://github.com/rails-api/rails-api')

[Rails API Tutorial]('https://wyeworks.com/blog/2015/6/11/how-to-build-a-rails-5-api-only-and-backbone-application')