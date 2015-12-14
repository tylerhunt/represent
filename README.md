# Represent

Separate view models and templates for Rails apps.

## Installation

Add this line to your application's `Gemfile`:

``` ruby
gem 'represent'
```

Or, if your app uses `Bundler.setup`, leave off the `require` option and
manually require `represent/railtie` in your `config/application.rb`.

And then execute:

    $ bundle

Then, add this line to your `config/application.rb` where the other Railties
are loaded:

``` ruby
require 'represent/railtie'
```

## Philosophy

The idea behind Represent is to provide a new type of object to Rails
applications: the view model. In a typical Rails app, the instance variables of
the controller are exposed to the template. Among other problems with this
approach is the ease with which instance variable typos arise, leading to odd
errors about missing methods on `nil`.

A better approach is to use a separate object for the data that's associated
with each template, and bind this object to the template instead of blindly
copying over the controller’s instance variables, inadvertently exposing
unnecessary data to the template. This also has the benefit of giving
additional methods related to the view a place to live without cluttering up
the controller.

## Usage

The biggest change with Represent is that the directory typically associated
with "views" in a Rails app, `app/views`, has been moved to `app/templates`.
The `app/views` directory is not used for the newly introduced view models. For
the template `users/index.html.erb`, this would be implemented thusly:

``` ruby
module Users
  class IndexView < ApplicationView
    attr_accessor :users
  end
end
```

Then, in the controller, the `users` attribute would be assigned through the
use of the `#view_assigns` hash:

``` ruby
class UsersController < ApplicationController
  include Represent::AssignLocals

  def index
    users = User.all
    view_assigns[:users] = users
  end
end
```

A few things to note here:

  1. The view model is required to be implemented, even if it doesn’t have any
     attributes. An error will be raised if a view corresponding to the
     rendered template can’t be found.
  2. By default, the `#view_assigns` hash is the only means of injecting data
     into the view model/template. See below for an alternative.
  3. Method visibility may not work as expected with view models, as
     both `protected` and `private` methods are available to the template due
     to the nature of template rendering in Rails.

### `AssignLocals`

Rails has the concept of local assignments for templates, which will make use
of a hash of values to make data available within the template, bypassing the
typical means of exposing template data, like instance variables.

To make migration to Represent easier for applications using this approach, the
module `Represent::AssignLocals` has been provided. Including this module into
a controller (e.g. `ApplicationController`) changes the behavior of the
`:locals` option of `#render` by causing the its values to be injected into the
view model instead of being made available directly to the template.

Then, in the controller, the `users` attribute would be assigned through the
use of the `:locals` hash on the `#render` calls:

``` ruby
class UsersController < ApplicationController
  include Represent::AssignLocals

  def index
    users = User.all
    render locals: { users: users }
  end
end
```

Note that you will still need to add an attribute accessor to the view model
for each value you intend to assign via the `:locals` hash.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tylerhunt/represent.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
