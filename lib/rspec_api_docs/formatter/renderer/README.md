# Renderers

Included renders:

- JSON renderer for https://github.com/twe4ked/api-docs
- Raddocs renderer for https://github.com/smartlogic/raddocs
- Slate renderer for https://github.com/lord/slate

## Protocol

A renderer gets initialized with an array of `Resource`s and then the `render`
instance method is called.

## Example

``` ruby
class ExampleRenderer
  def initialize(resources)
    @resources = resources
  end

  def render
    puts @resources.map(&:name).join("\n")
  end
end

RspecApiDocs.configure do |config|
  config.renderer = ExampleRenderer
end
```
