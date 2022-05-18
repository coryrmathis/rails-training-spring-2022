## ActiveRecord

- [Validations](#validations)
- [FactoryBot](#factorybot)
- [Enums in Rails](#enums-in-rails)

ActiveRecord is an Object Relational Mapper (ORM). An ORM allows us to translate our objects and methods into sql and communicate with the database. It is performing sql under the hood. AR::Rails as Hibernate::Java or TypeORM::TS or EntityFramework::C# or SQLAlchemy::Django. Remember what inheritance does; by inheriting from ActiveRecord, we gain the ability to use human readable ruby code in our application and let ActiveRecord perform the sql queries that we desire to do.

**ACTIVITY** Let's break into pairs to test drive our Movie object. We want to have a movie object and we want to make sure that each of our movie objects have a title present:
(Offer file/very bare bones scaffolding)

`touch test/models/movie_test.rb`

```ruby
# test/models/movie_test.rb

require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "movie is valid with a title" do
    movie = Movie.new(title: "Parasite", director: "Bong Joon-ho")
    assert_equal movie.title, "Parasite"
    assert_equal movie.director, "Bong Joon-ho"
  end
end
```

**What feedback do you think this test will give us?**

Running this gives us a particular error:

```terminal
# Running:

E

Error:
MovieTest#test_movie_is_valid:
ActiveRecord::StatementInvalid: Could not find table 'movies'
    test/models/movie_test.rb:5:in `block in <class:MovieTest>'


rails test test/models/movie_test.rb:4



Finished in 0.081121s, 12.3273 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

**What is this error telling us?**

We need to create the table in our database for movies. While we are at it, lets create some more attributes for our movie so we can play around:

```sh
rails g migration CreateMovies title:string facebook_likes:integer year:string plot_keywords:string director: string
```

Rails `g` stands for `generate`. As it it turns out Rails has a lot of of these generators - we can just run `rails g` to see the full list. As your instructors, it's here that we owe you an apology for not showing you these sooner. But, this is more of a "sorry not sorry" situation - there is some value in learning how to hand roll bits of Rails boilerplate before letting the tool do the work for you. A lot of folks who are new to Rails dive straight into the generators, never digging into the files they've created until they're trying to troubleshoot (and have no idea what they're looking at), or leaving a lot of generated but unused code hanging around waiting to confuse the next developer who's trying to figure out if all of that code is really needed.

In this case however, a generator can save us the tedium of having to hand-roll a migration.

You're all going to have to run this on your machines in order to run the migration that we've pushed.

**So, can anyone guess what the generator command we just ran is doing?**

If we follow `rails g migration` it by a specific `Create` command, it will create a migration with the proper migration name for our movies table. There are other specific syntaxes to pass to `rails g migration` to generate migrations of specific kinds:
`AddColumnToMovies` will create a migration to add a column to the movies table.
`RemoveColumnFromMovies` will create a migration to remove a column from the movies table.

By adding `title:string facebook_likes:integer year:string plot_keywords:string director:string` we are allowing Rails to generate even more syntax for us, making the migration complete without even touching it. We are telling the migration that we want a columns of `title, facebook_likes, year, plot_keywords and director` and the data types for each column.

Migrations are named by their date stamp (used to run the migrations in the proper order) as well as the first argument (PascalCase to snake case) after `migration`. A primary key (an id) is added, by default, when a table is created so we do not need to include that.

```ruby
class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :facebook_likes
      t.string :year
      t.string :plot_keywords
      t.string :director
    end
  end
end
```

When we run `rails db:migrate`, behind the scenes, ActiveRecord is doing a sql
command to create a table in our database and record our database to our
`db/schema.rb` file. Remember the `db/schema.rb` file is the blueprint of our
database. It's convention in Rails to never edit this file directly, but rather
only through migrations. This allows anyone working in the codebase to be able
to recreate the schema following the same history it took to get to the current
point.

Let's look at schema.rb

```ruby
# db/schema.rb

ActiveRecord::Schema.define(version: 2020_02_26_002240) do

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.integer "facebook_likes"
    t.string "year"
    t.string "plot_keywords"
    t.string "director"
  end

end
```

So let's run `rails db:migrate` and then go ahead and run our test again. **Can anyone guess what will happen?**

```sh
Running via Spring preloader in process 52804
Run options: --seed 43623

# Running:

.

Finished in 0.123508s, 8.0966 runs/s, 8.0966 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

Older rails apps might have hundreds of migrations in them. Rails uses `schema.rb`
to avoid having to re-run the entire set. `Schema.rb` is the authoritative source
of what the database should look like.

We left you with an exercise to write a migration. Your migration is pretty
unlikely to match ours, so what do we do about it?

The easiest answer is `rails db:reset`, which is a shorthand for `bin/rails db:drop db:setup`, which is a shorthand for `rails db:create db:schema:load db:seed`.

We'll talk more about seeds later.

Since this drops the database, it'll undo whatever migration you wrote. You may also want to `git checkout` or similar.
If it's left in the source tree rails might try to run it again.

### Validations

We have a passing spec! Let's create another test to test our sad path where our movie does not have a title:

```ruby
# test/models/movie_test.rb

require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "movie is valid with a title" do
    movie = Movie.new(title: "Parasite", director: "Bong Joon-ho")
    assert_equal movie.title, "Parasite"
    assert_equal movie.director, "Bong Joon-ho"
  end

  test "movie is not valid without a title" do
    movie = Movie.new(title: " ")
    refute movie.valid?
  end
end
```

The output of this is:

```sh
# Running:

.F

Failure:
MovieTest#test_movie_is_not_valid_without_a_title [/Users/icorson/projects/movie_app/test/models/movie_test.rb:12]:
Expected true to be nil or false


rails test test/models/movie_test.rb:9



Finished in 0.090888s, 22.0051 runs/s, 33.0077 assertions/s.
2 runs, 3 assertions, 1 failures, 0 errors, 0 skips
```

Let's see if we can get this to pass as a breakout activity. We'll drop [the rails
guide for
validations](https://guides.rubyonrails.org/active_record_validations.html)
into slack and see what you all come up with.

The command to run is `bin/rails test`, remember that our system test is still
failing.

We want to put a validation in place to be sure that a movie cannot be created
without a title. We can see that ActiveRecord gives us the `valid?` method
right out of the box to check this. The fact that this method ends with a `?`
gives us a clue that the return value is going to be a boolean. This convention
is strongly adhered to throughout both Rails and plain Ruby.

Validations come from ActiveRecord and allow us to make sure that certain
attributes are present, included, unique and other validations. Let's add our
validation to our model.

```ruby
# app/models/movie.rb

class Movie < ApplicationRecord
  validates_presence_of :title
end
```

Again, passing spec!

Notice how we are enforcing presence on the model, rather than on the database.
In order for ActiveRecord to understand this requirement, we need to specify it
on the model. Otherwise, an exception would happen when we attempt to persist
to the db, and it may not surface in the way that we want.

You could enforce this at the database level instead by adding a migration
with a not null constraint. But we're doing it in rails land today.

Lets dig into our `movie` object a little more. The goal is to create a movie
object with an id so that we can duplicate and use it in our system test. Let's
add `pry` to our application - we need to add it to our `Gemfile` in the
test/development group and `bundle install`.

```ruby
# Gemfile
group :development, :test do
  gem 'pry'
end
```

And now lets use it in our test file to dig in further.

```ruby
class MovieTest < ActiveSupport::TestCase
  test "movie is valid with a title" do
    movie = Movie.new(title: "Parasite")
    assert_equal movie.title, "Parasite"
    assert_equal movie.director "Bong Joon-ho"
    binding.pry
  end
end
```

This sets a break point after we have instantiated a new instance of movie and
allows us to play with the movie object a little more. Running our tests will
bring us to that break point:

```terminal
[1] pry(#<MovieTest>)> movie
=> #<Movie:0x00007fa6bd4397c8 id: nil, title: "Parasite", facebook_likes: nil, year: nil, plot_keywords: nil, director: "Bong Joon-ho">
```

As we can see, our movie has no id. **Why?** To actually insert this movie to our test database, we need to call the ActiveRecord method `save` on it. Lets do that in our pry session and then call the movie instance again:

```terminal
[2] pry(#<MovieTest>)> movie.save
=> true
[3] pry(#<MovieTest>)> movie
=> #<Movie:0x00007fa6bd4397c8 id: 1, title: "Parasite", facebook_likes: nil, year: nil, plot_keywords: nil, director: "Bong Joon-ho">
```

Now we see that our movie has an id, which is exactly what we need for our
system test. In ActiveRecord, there is a short cut method to instantiated a new
object and saving it at the same time: `create`. Let's pause on our project
here to work through some more ActiveRecord exercises. We'll do the first few
together and then break into pairs for the rest.

We are going to work in our `rails console` or `rails c` environment to do the
exercises. The `rails console` is our access point to our development database.
If we drop into our console, we can see that we do not have any movie objects
in our database, even though we just created one in our test.

```sh
icorson: movie_app $ rails c
Running via Spring preloader in process 53491
Loading development environment (Rails 6.0.2.1)
irb(main):001:0>
```

If we call the ActiveRecord method `all` on our Movie class we get some feedback:

```sh
irb(main):001:0> Movie.all
   (0.5ms)  SELECT sqlite_version(*)
  Movie Load (0.4ms)  SELECT "movies".* FROM "movies" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation []>
```

Some interesting pieces here: It is giving us the sql query that it ran `SELECT
"movies".* FROM "movies" LIMIT ?` and it also gives us the output
`#<ActiveRecord::Relation []>` this tells us that what we are returning is an
ActiveRecord collection and not a simple array. To further demonstrate this, we
can call `Movie.all.class` to see what type of class this is, which is
`Movie::ActiveRecord_Relation`. `all` is an ActiveRecord class method defined
on all objects that inherit from ActiveRecord. We can imagine that in our
`app/models/movie.rb` file, we have code like this but hidden behind the
inheritance from ActiveRecord.

```ruby
class Movie < ApplicationRecord
  def self.all
    find_by_sql('SELECT * FROM "movies"')
  end
end
```

A file that is important in our development environment is our `db/seeds.rb` file. This file is where we put code that populate objects in our initial development/production databases. We have created [this](https://gist.github.com/kbaribeau/3261ec6d7a709b800ad0d56246608af0) gist to `seed` our development environment. If we copy and paste this into our seed file. To seed our development database, we can use the command `rails db:seed`. Then we can check back in our console to see the output and also the sql statement that `.count` does under the hood:

```sh
irb(main):002:0> Movie.count
   (0.2ms)  SELECT COUNT(*) FROM "movies"
=> 12
```

Activity: Let's work through the following
[these](https://gist.github.com/marlabrizel/56decb4e4ffde0225cf3f208e2b7c294)
exercises on our own, using the ActiveRecord
[documentation](https://guides.rubyonrails.org/active_record_querying.html):

Most of these will make sense as class methods on the Movie class.

Now challenge yourself to write tests for each of the exercises.
* Make a method/write a test that returns the number of movies in the database with more than a given number of Facebook likes
* Make a method/write a test that returns an array of just movie titles.
* Make a method/write a test that returns all movies by a director that were made after the year 2010.
* Make a method/write a test that returns all movies in order of most to least facebook likes.
* Make a method/write a test that can find a movie by its title, and tell you what year it was released.

We are going to revisit ActiveRecord a little later and continue to explore ActiveRecord methods.

Lets go back to our system test and update it.
But don't forget to remove the `binding.pry` from the model test!

You will notice that we have removed the hardcoded route of `/movies/1` and
replaced it by interpolating our `id` into the route. This ensures that no
matter the id of the movie object, it will find the route associated with that
specific movie because behind the scenes, it is basically doing a
`Movie.find(id)`. If we test this out and change our interpolated id to a
interpolated movie title, our routes will get confused.
`/movies/#{movie.title}`

```ruby
# test/system/movies_system_test.rb

require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the show" do
    attributes = { title: "Parasite" }
    movie = Movie.create(attributes)
    # As a user,
    # when I visit /movies/1
    visit "/movies/#{movie.id}"
    # I see the title of the movie "Parasite"
    assert_text "Parasite"
    # I also see the name of the director "Bong Joon-ho"
    assert_text "Bong Joon-ho"
  end

  test "visiting the show for another movie" do
    attributes = { title: "Titanic" }
    movie = Movie.create(attributes)

    visit "/movies/#{movie.id}"
    assert_text "Titanic"
    assert_text "James Cameron"
  end
end
```

**What do you think will happen now when we run our test file?** When we run
it, our first test will pass but our second will fall because we have hard
coded the html file.

```sh
F

Failure:
MoviesSystemTest#test_visiting_the_show_for_another_movie [/Users/marlabrizel/projects/movie_app/test/system/movies_system_test.rb:19]:
expected to find text "Titanic" in "Parasite Bong Joon-ho"


rails test test/system/movies_system_test.rb:14



Finished in 4.736157s, 0.4223 runs/s, 0.4223 assertions/s.
2 runs, 2 assertions, 1 failures, 0 errors, 0 skips
```

We have our `.erb`, or embedded Ruby file, but we have not actually embedded
any Ruby in it. Per our MVC discussion earlier, we know that the controller
should be the communicator to the view and send the view the Ruby we want to
embed. Back in our controller if we put a pry into our show method, we will
stop before we get to the view so that we can figure out what's going on.

```ruby
# app/controllers/movie_controller.rb

class MoviesController < ApplicationController
  def show
    binding.pry
  end
end
```

When we are in the pry session, we can see our `params` or parameters. This is a class of its own and behaves like a hash. It is only available in classes that inherit from ActionController. For this `GET` action, our params are being sent in our url request. This is one of the parts of convention vs configuration where Rails is assuming we are going to pass the id into the url. We can change the name of this param at any time but id makes the most sense because it will definitely be a unique indicator while title may be ambiguous.

When we look at this object, we see that our id is inside the object as `:id`. We want to use what we learned from ActiveRecord to find the movie we want to display by `id`. Since it behaves like a hash, we can call `params[:id]` to pull the id and `Movie.find(params[:id])`. We need some way to pass our found movie to the view now. We can either use an instance variable or a local variable and pass it to the view. **Does anyone think they know which one we might want and why?** With an instance variable, our application will know about that instance variable for each request. The instance variables do not persist across requests (this is different from a model instance method), rendering a view is still the same request so our view can access to any information stored on our instance variable. **Does anyone remember the syntax for an ivar?** An instance variable is a variable but it starts with an `@` symbol. Lets set this in our controller:

```ruby
# app/controllers/movie_controller.rb

class MoviesController < ApplicationController
  def show
    @movie = Movie.find(params[:id])
  end
end
```

To embed Ruby in our `.erb` file, we can use two different syntaxes:

```erb
<!-- this will run but not print anything to the page -->
<% some ruby here >

<!-- this will run and print the output to the page -->
<%= some ruby here >
```

Fun trick is that we can also put a pry into our view, using non printing erb tags and be able to have a sandbox:

```erb
<!-- show.html.erb -->
<% binding.pry %>
```

If we check, we have access to our `params` here as well. We do not want to skip the controller and make a database call straight from our view. As noted, we want our controller to talk between the two so the following is possible but not recommended:

```erb
<!-- show.html.erb -->
<% binding.pry %>
<h3><%= Movie.find(params[:id]).title %></h3>
<h4><%= Movie.find(params[:id]).director %><h4>
```

Lets check if we have access to our instance variable here as well by calling `@movie` in our pry session. `@movie` is holding a reference to our movie object so now we can call `.title` on our movie and get the title "Parasite".

We could update our `show.html.erb` file to the following:

```erb
<!-- show.html.erb -->
<h3><%= @movie.title %></h3>
<h4><%= @movie.director %><h3>
```

Now lets run our test. We have a passing test!

```sh
Run options: --seed 998

# Running:

Capybara starting Puma...
* Version 4.3.1 , codename: Mysterious Traveller
* Min threads: 0, max threads: 4
* Listening on tcp://127.0.0.1:62517
..

Finished in 1.213749s, 1.6478 runs/s, 1.6478 assertions/s.
2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

It's worth noting that GitHub structures controllers a bit differently. Instead of using instance variables to then pass to the views, GitHub uses local variables instead. The short explanation is that this allows for extra precision in specifying which objects should be passed through to views - coming in handy when applications are large and the potential for conflating instance variables increases.

We can refactor our controller to use local variables like so:

```ruby
# app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def show
    movie = Movie.find(params[:id])

    render locals: { movie: movie }
  end
end
```

**Activity**
On your own, create a test and make it pass for a movies index (showing at
least two movies).

```ruby
# test/system/movies_system_test.rb

require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the index page" do
    movie1 = Movie.create(title: "Parasite", director: "Bong Joon-ho")
    movie2 = Movie.create(title: "Titanic", director: "James Cameron")

    visit "/movies"

    assert_text "Parasite"
    assert_text "Bong Joon-ho"
    assert_text "Titanic"
    assert_text "James Cameron"
  end

  test "visiting the show page" do
   ...
  end

  test "visiting the show for another movie" do
  ...
  end
end
```

```ruby
# config/routes.rb

Rails.application.routes.draw do
  resources :movies, only: [:index, :show]
end
```

```ruby
# app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def show
    movie = Movie.find(params[:id])

    render locals: { movie: movie }
  end
end
```

```erb
<-- app/views/movies/index.html.erb -->

<% movies.each do |movie| %>
  <h3><%= movie.title %></h3>
  <h4><%= movie.director %></h4>
<% end %>
```

TODO need intro into why we would bring in factory bot here

### FactoryBot

FactoryBot is a gem - remember, gems are external libraries we can incorporate into our codebases - and it provides us with an easy way to create dummy objects for test purposes. It allows us to create multiple objects with ease and associate them to other objects. Documentation can be found [here](https://github.com/thoughtbot/factory_bot). We are going to use FactoryBot in conjunction with Faker. [Faker](https://github.com/faker-ruby/faker) is another gem that allows us to generate fake data since we really don't care about having real data at this point, just that the application works. It is helpful when we find ourselves having to make up a lot of data - after all, you can probably only come up with so many cat or dog names!

We want to be able to use both Faker and FactoryBot in our test and development environments, lets add those and `bundle` to install our new dependencies:

```ruby
# Gemfile

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'faker'
  gem 'factory_bot_rails'
end
```

We need to do some setup to enable FactoryBot within our tests. **Follow the documentation for FactoryBot to configure it for your Rails application and define a new director factory. Use Faker to generate the data for `name` and `age`. If you finish that, confirm your factory works by using it in your `director_test`. Bonus: define the movie factory as well with a relationship to the director factory. Use any Faker data to populate the data for `title`, `year`, `plot_keywords`. Use a random number (using ruby `rand(100)` to generate the `facebook_likes`.**

```ruby
# test/test_helper.rb

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'pry'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
  FactoryBot.reload #may be necessary if Factories are erroring as not registered
end
```

`mkdir test/factories && touch test/factories/movie.rb`

```ruby

# test/factories/movie.rb

FactoryBot.define do
  factory :movie do
    title { Faker::Superhero.name }
    director { Faker::Name.name }
    facebook_likes { rand(100) }
    plot_keywords { "#{Faker::Lorem.word}|#{Faker::Lorem.word}"}
    year { Faker::Date.between(from: 10.years.ago, to: Date.today).year }
  end
end
```

```ruby
# test/models/movie_test.rb

require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "movie is valid with a title" do
    movie = build(:movie, title: "Parasite", director: "Bong Joon-ho")
    assert_equal movie.title, "Parasite"
    assert_equal movie.director, "Bong Joon-ho"
  end

  test "movie is not valid without a title" do
    movie = build(:movie, title: " ")
    refute movie.valid?
  end
end
```

Now let's take a look at our system test. 

``` ruby
# test/system/movies_system_test.rb

require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the index page" do
    movie1 = Movie.create(title: "Parasite", director: "Bong Joon-ho")
    movie2 = Movie.create(title: "Titanic", director: "James Cameron")

    visit "/movies"

    assert_text "Parasite"
    assert_text "Bong Joon-ho"
    assert_text "Titanic"
    assert_text "James Cameron"
  end


  test "visiting the show" do
    attributes = { title: "Parasite" }
    movie = Movie.create(attributes)
    # As a user,
    # when I visit /movies/1
    visit "/movies/#{movie.id}"
    # I see the title of the movie "Parasite"
    assert_text "Parasite"
    # I also see the name of the director "Bong Joon-ho"
    assert_text "Bong Joon-ho"
  end

  test "visiting the show for another movie" do
    attributes = { title: "Titanic" }
    movie = Movie.create(attributes)

    visit "/movies/#{movie.id}"
    assert_text "Titanic"
    assert_text "James Cameron"
  end
end
```

FactoryBot is extremely useful in this case. Every time this test runs, a new instance of a Movie is being created with a new title. We don't need multiple different tests to make sure this page is working, the dynamic test would be acceptable. Lets delete all the other tests within this file and just leave our dynamic test.

```ruby
require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the index page" do
    movie1 = create(:movie, title: "Parasite", director: "Bong Joon-ho")
    movie2 = create(:movie, title: "Titanic", director: "James Cameron")

    visit "/movies"

    assert_text "Parasite"
    assert_text "Bong Joon-ho"
    assert_text "Titanic"
    assert_text "James Cameron"
  end
  
  test "visiting the show" do
    movie = create(:movie)

    visit "/movies/#{movie.id}"

    assert_text movie.title
  end
end
```

The last thing that we want to do here is use our prefix url helper methods to directly access our path. If we look back at our routes (`rails routes`) we will see that the show action matches a prefix called `movie`. What this is really saying is that `movie` is the prefix for `path`. You can imagine that all of these prefixes are followed by `_path`. Lets update our route to be our path helper:

```ruby
require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the show" do
    movie = create(:movie)

    visit movie_path

    assert_text movie.title
    assert_text movie.director.name
  end
end
```

We get an error that is quite common:

```terminal
E

Error:
MoviesSystemTest#test_visiting_the_show:
ActionController::UrlGenerationError: No route matches {:action=>"show", :controller=>"movies"}, missing required keys: [:id]
    test/system/movies_system_test.rb:7:in `block in <class:MoviesSystemTest>'


rails test test/system/movies_system_test.rb:4



Finished in 1.562018s, 0.6402 runs/s, 0.0000 assertions/s.
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

**Does anyone think they can break this error down?**
This piece `missing required keys: [:id]` is telling us something important - we have not included the key of `id` anywhere. Knowing that these path helpers will take arguments is important. On any route that has a key of `:id` included, this is required, while on other routes, it is optional.

```ruby
require "application_system_test_case"

class MoviesSystemTest < ApplicationSystemTestCase
  test "visiting the show" do
    movie = create(:movie)

    visit movie_path(movie)

    assert_text movie.title
    assert_text movie.director.name
  end
end
```



### Enums in Rails

An enum is a set of options that an object has. There are a finite number of options for an enum, we cannot input any string, number, etc. as the enum value. For instance, per our dataset, a movie can either be "black and white" or "color". There is a specific way to declare and utilize these options in Rails.

Lets add a `color_format` column in our database for an enum with `black_and_white` and `color` as options.

**ACTIVITY** See if you can use documentation to create a new column and declare an enum in your movie class. Make `color` the default `color_format` when a movie object is created:

`rails g migration AddColorFormatToMovies color_format:integer`

```ruby
class AddColorFormatToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :color_format, :integer, default: 0
  end
end
```

`rails db:migrate`

```ruby
class Movie < ApplicationRecord
  validates_presence_of :title
  enum color_format: [:color, :black_and_white]
end
```

Lets drop into a `rails c` and check out our new attribute and what additional methods it gave us for free.

`movie = FactoryBot.create(:movie)`

`movie.color? => true`

**What is this doing?** both Ruby and Rails conventionally use `?` to denote predicate methods

`movie.black_and_white? => false`
`movie.black_and_white!`

**What do you think this does?**

`movie.black_and_white? => true`
Conventionally, `!` denotes mutating methods - calling this kind of method will typically mutate state
`Movie.color_formats => {"color"=>0, "black_and_white"=>1}`
`Movie.where(color_format: 0)`
`Movie.where(color_format: :color)`
`Movie.where(color_format: "color")`