RackStack
=========

`RackStack` is a fully managed stack of Rack applications (*inspired by [Rack::Builder][]*)

```ruby
RackStack.new do
  use MyMiddleware
  map "/admin" do
    run AdminApp.new
  end
  run MyApp.new
end
```

If you're familar with Rack::Builder, that should look very familiar!

RackStack's API is actually intended to be [compatible with Rack::Builder's][compatibility].

RackStack adds a few features to Rack::Builder:

 1. May be used as either a Rack endpoint or middleware
 1. Conditional Logic (via `:when`)
 1. Naming

Endpoint or Middleware
----------------------

The Rack application generated by a Rack::Builder can only be run as a Rack endpoint,
not as a middleware.

```ruby
Rack::Builder.new {
  use SomeMiddleware

  # RackStack can be used as a middleware, alongside your existing Rack components
  use RackStack.new do
    use AnotherMiddleware, when: { path_info: /foo/ }
    run SomeApplication.new, when: { path_info: /bar/ }
  end

  # Or RackStack can be used as a Rack endpoint.
  run RackStack.new do
    run AnotherApplication.new  
  end
}.to_app
```

Conditional Logic
-----------------

```ruby
stack = RackStack.new do
  use MyMiddleware, when: { path_info: /^\/aboutus/ }
  map "/admin" do
    run AdminApp.new, when: ->{|request| request.path_info =~ /^\/aboutus/ }
  end
  run MyApp.new, when: ->{ path_info =~ /^\/aboutus/ }
end
```

RackStack allows you to easily add conditional logic for `:when` to `#run`, `#use`, or `#map` a rack component.

Styles ... {}, ->() ...

Naming
------

add names ...

remove ...

get access to...

[Rack::Builder]: http://rack.rubyforge.org/doc/classes/Rack/Builder.html
[compatibility]: https://github.com/remi/rack-stack/tree/master/rack-builder-compatibility
