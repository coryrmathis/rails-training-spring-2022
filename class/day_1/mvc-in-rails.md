## MVC in Rails

  - [Anatomy of a Request](#anatomy-of-a-request)
  - [Rails Routes](#rails-routes)
  - [Controllers](#controllers)
  - [Views](#views)
  - [Models](#models)
  - [Forms and other Rails Actions](#forms-and-other-rails-actions)

You might be familiar with the Model View Controller design pattern. **Would anyone like to volunteer to explain MVC?**

MVC separates our application into three main concerns. We will dive into each of these pieces in more detail as we go, but it's worth giving a high level overview now. (Call on students to try to explain each piece first)
- Model is concerned with application data. Our models will talk directly with the database to fetch and save data, and will also manipulate that data.
- View layer is concerned with presentation. How do we want the user to interact with the application? What should they see?
- Controller is the shuttle-bus that acts as the go-between between the views and the models. It receives requests - either from the model or the view, and translates that to tell the other side what to do.

MVC is heavily relied upon in Rails to maintain separation of concerns and provide a predictable way to trace requests through the application.

### Anatomy of a Request

When a user types a url in the search bar, the interaction is instantaneous but there's actually a lot happening behind the scenes in a Rails application: (explain in terms of github.com?)
1. The first place that the interaction is going to look in our Rails application is the `config/routes.rb` file. This file tells the application what action and controller to send the request to. We already know this because this is the very first error we got in our test.
2. After that, the application is directed to the place that the `routes.rb` specified. This will be a controller and a particular action within that controller. The controller's job is to collect the information that will be important to each action. It talks to the model and the view - the important part here is that the view and model should never interact directly.
3. Database queries and other relevant information will happen in the model and send their information back to the controller for collection.
4. The controller will pass the data to the view and request the applicable template. The view takes the data and uses it to generate a HTML document which it sends back to the controller.
5. The controller then sends the compiled view back to the browser and it is consumed in a human readable way.

### Rails Routes

So the first place that the interaction with our application takes place is within the Rails Router or `routes.rb` file. If we open it up, there is a link to the [documentation](https://guides.rubyonrails.org/routing.html) where further detail is provided. The important parts to understand is that this file handles url requests and dispatches them to their proper location.

We can hard code our routes within this file and tell it specifically what controller and what action we want the url to go to:

```ruby
# routes.rb

Rails.application.routes.draw do
  get '/movies/:id', to: 'movies#show'
end
```

And if we run the command `rails routes` it will show us that we have this route defined now:

```sh
Verb        URI Pattern            Controller#Action
GET         /movies/:id(.:format)  movies#show
```

**Activity**
What if Rails provides us with a handy way to define all 7 of our RESTful resources in a one-liner? Let's see if we can figure that out using the Rails Routing guide. What happens if you run `rails routes` now?

We can define all our RESTful resources in a oneliner by using `resources`.

```ruby
# routes.rb

Rails.application.routes.draw do
  resources :movies
end
```

Now when we run `rails routes` our seven routes are defined for us plus, one more piece is added that is extremely helpful `Prefix`:

```sh
Prefix     Verb   URI Pattern                Controller#Action
movies     GET    /movies(.:format)          movies#index
           POST   /movies(.:format)          movies#create
new_movie  GET    /movies/new(.:format)      movies#new
edit_movie GET    /movies/:id/edit(.:format) movies#edit
movie      GET    /movies/:id(.:format)      movies#show
           PATCH  /movies/:id(.:format)      movies#update
           PUT    /movies/:id(.:format)      movies#update
           DELETE /movies/:id(.:format)      movies#destroy
```

The `Prefix` column tells us the prefix that will be used when Rails generates a path helper method for each of these routes. This is an additional helper method that allows us to refer to a method that returns the matching url pattern.

We can limit our resources, with the `only` or `except` keywords to eliminate unneeded routes. **(make this an activity, time permitting)**

### Controllers

Now if we run our test again, we are led to our next error:

```sh
E

Error:
MoviesTest#test_visiting_the_show:
ActionController::RoutingError: uninitialized constant MoviesController
Did you mean?  MoviesTest



rails test test/system/user_sees_one_movies_test.rb:4



Finished in 3.285638s, 0.3044 runs/s, 0.3044 assertions/s.
1 runs, 1 assertions, 0 failures, 1 errors, 0 skips
```
**What is this error telling us?**

It is telling us that we have an `uninitialized constant MoviesController` which makes sense since we haven't defined our Movies Controller. Let's do that:

```ruby
# app/controllers/movies_controller.rb

class MoviesController < ApplicationController

end
```

Notice that we are inheriting from a `ApplicationController` class and when we open that file up, it is empty besides defining the class name and itself, inheriting from `ActionController::Base`:

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
end
```

`ActionController::Base` provides a set of methods that are defined in the Rails API to be used within our application. This allows us to focus on writing applicable code rather than redefining methods that do specific things (convention over configuration). Methods that are available through this inheritance are specifically helpful to the controller classes. The `ApplicationController` is a class that allows us to share methods across all classes that inherit from it, reducing duplication of code.

Running the test again will give us:

```sh
E

Error:
MoviesTest#test_visiting_the_show:
AbstractController::ActionNotFound: The action 'show' could not be found for MoviesController



rails test test/system/user_sees_one_movies_test.rb:4



Finished in 2.571884s, 0.3888 runs/s, 0.3888 assertions/s.
1 runs, 1 assertions, 0 failures, 1 errors, 0 skips
```

Pretty straightforward, `The action 'show' could not be found for MoviesController`. Action is synonomous with method in this case is so our test is looking for a method called `show`. Thanks to RESTful routing, Rails knows how to match up our actions with the HTTP resource being requested. Let's add our show action (method) and run our test:

```ruby
# app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def show
  end
end
```

```sh
E

Error:
MoviesTest#test_visiting_the_show:
ActionController::MissingExactTemplate: MoviesController#show is missing a template for request formats: text/html



rails test test/system/user_sees_one_movies_test.rb:4



Finished in 2.470032s, 0.4049 runs/s, 0.4049 assertions/s.
1 runs, 1 assertions, 0 failures, 1 errors, 0 skips
```

This error brings us to another part of our MVC design pattern, the view.

### Views

The error we produced in the test is telling us `ActionController::MissingExactTemplate: MoviesController#show is missing a template for request formats: text/html` which takes some deciphering but `template` and `html` should give us some clues. We have not created a template for our html that the show can find. With a `GET` request to an action, our application will always look for a template with the same action name, whether that is `show` or `foo`. This is part of Rails "convention over configuration". Unless we explicitly tell our action what template to render, it will look for `action_name.html.erb`.

We can test this out by doing a small experiment. Let's take a step back and comment out our resource of movies:

```ruby
# routes.rb
# resources :movies
get "/movies/:id", to: "movies#foo"
```

When we run our tests, we see the error that we saw earlier but a little different:

```sh
AbstractController::ActionNotFound: The action 'foo' could not be found for MoviesController
```

And if we add that method/action:

```ruby
# movies_controller.rb

def foo
end
```

We see the `html`/`template` error again requesting that we add a `foo` view.

Now let's put our routes back the way they were and work towards making our test pass!

```ruby
# routes.rb
resources :movies
```

Since we will define multiple actions/views in one controller, we want a folder to hold those views. Let's create the folder and our `show` view:

```sh
mkdir app/views/movies && touch app/views/movies/show.html.erb
```

**Why do you think we have the file extension `html.erb`?**

We want the file extension `.html.erb` because it will be an html file that we embed ruby into - `erb` is short for "embedded ruby". Within this file, we can write standard html but we also have the ability to use our defined Ruby code from our controllers here as well. More on this later.

Now that we have our file, we can easily satisfy this test by hardcoding our expectation:

```erb
<!-- app/views/movies/show.html.erb -->

<h3>Parasite</h3>
<h4>Bong Joon-ho<h4>
```

```sh
Run options: --seed 38111

# Running:

Capybara starting Puma...
* Version 4.3.1 , codename: Mysterious Traveller
* Min threads: 0, max threads: 4
* Listening on tcp://127.0.0.1:63330
.

Finished in 5.695332s, 0.1756 runs/s, 0.1756 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

But what if we want to visit the show page for a different movie? Let's add a second test to our system test and see if we can make it pass.

**ACTIVITY** Give user story for next test, split into pairs, write test & try to make it pass).

```
As a user,
When I visit a movie with the id of 2,
I see the title for that movie
```

```ruby
# test/system/movies_system_test.rb

require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the show" do
    # As a user,
    # when I visit /movies/1
    visit "/movies/1"
    # I see the title of the movie "Parasite"
    assert_text "Parasite"
    # I also see the name of the director "Bong Joon-ho"
    assert_text "Bong Joon-ho"
  end

  test "visiting the show for another movie" do
    visit "/movies/2"

    assert_text "Titanic"
    assert_text "James Cameron"
  end
end
```

```sh
F

Failure:
MoviesTest#test_visiting_the_show [/Users/icorson/projects/movie_app/test/system/user_sees_one_movies_test.rb:9]:
expected to find text "Titanic" in "Parasite"


rails test test/system/user_sees_one_movies_test.rb:4



Finished in 4.419577s, 0.2263 runs/s, 0.2263 assertions/s.
1 runs, 1 assertions, 1 failures, 0 errors, 0 skips
```

We could always change the code in our `html.erb` file but that doesn't seem right. Looking back at our routes, we have the path `/movies/:id`. This path is dynamic and depends on an `id` and so far, we have hardcoded our id but what should that refer to? It should refer to the `id` of a `Movie` object yet we do not have a movie object yet.

### Models

We want a new instance of Movie that we can play with. Thinking in similar terms as how we define an object in Typescript, we want to define an object in Ruby/Rails. We need to give it a hash where the key is the attribute pointing to the value of that attribute.

```typescript
let movie: Movie = {
 title: string,
 director: string
}

new Movie("Parasite");
```

```ruby
# newer preferred syntax
attributes = { title: "Parasite" }

# older less-preferred syntax
attributes = { :title => "Parasite" }

Movie.new(attributes)
```

That looks like a good start to creating a new instance of a Movie to work with:

```ruby
class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the show" do
    attributes = { title: "Parasite", director: "Bong Joon-ho" }
    Movie.new(attributes)
    # As a user,
    # when I visit /movies/1
    visit '/movies/1'
    # I see the title of the movie "Parasite"
    assert_text "Parasite"
  end
end
```

```terminal
E

Error:
MoviesTest#test_visiting_the_show:
NameError: uninitialized constant MoviesTest::Movie
    test/system/user_sees_one_movies_test.rb:6:in `block in <class:MoviesTest>'


rails test test/system/user_sees_one_movies_test.rb:4



Finished in 1.703462s, 0.5870 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

Now we get an error that our Movie is uninitialized, meaning our class is undefined. **Knowing what we know about MVC, where might it make sense to define our movie class? Why?**  We want to define our class within the models directory. This communicates that this class is going to have instances stored in our database. We can have objects that do not live in our database and we would define those outside of this directory (location depends on company but usually `lib`). Let's create the Movie class now:

```sh
touch app/models/movie.rb
```

Notice that we are using the singular word `movie` while in our controller, we used the plural `movies`. This is because the controller manages all movies and their actions while a model is a blueprint for an instance of movie as well as methods defined on the table Movie. There are exceptions when we use a class method but this is convention.

```ruby
# app/models/movie.rb

class Movie < ApplicationRecord

end
```

We have defined a class called `Movie` and it inherits from `ApplicationRecord`. Simiarly to `ApplicationController`, `ApplicationRecord` is a class that can be shared across all model classes and reduces the duplication of code across models. It also inherits from `ActiveRecord` giving us a whole new set of methods to use in our models.

```ruby
# app/models/application_record.rb

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
```
