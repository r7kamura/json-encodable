# JSON::Encodable
Make a class encodable into JSON format.

## Usage
1. Include `JSON::Encodable` module
2. Call `.property` method with property name
3. Then the instance will be able to respond to `to_json` method

### #to_json
```ruby
class Blog
  include JSON::Encodable

  property :id
  property :title
  property :username

  def id
    1
  end

  def title
    "wonderland"
  end

  def username
    "alice"
  end
end

Blog.new.to_json
#=> '{"id":1,"title":"wonderland","username":"alice"}'
```

### #as_json(options = {})
You can also call `.as_json` method with `:except` and `:only` options.

```ruby
Blog.new.as_json(only: [:id, :username])
#=> { "id" => 1, "username" => "alice" }

Blog.new.as_json(except: :username)
#=> { "id" => 1, "title" => "wonderland" }
```
