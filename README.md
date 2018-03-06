# Dictionary based map filter for [Fluentd](http://fluentd.org)

Map field to other value with dictionary

## Installation

Use RubyGems:

    gem install fluent-plugin-dict-map

## Configuration

Use `@type dict_map` in `<filter>`.

    <filter pattern>
      @type dict_map
      key_name level
      dictionary {"I":"INFO","W":"WARN","E":"ERROR"}
    </filter>

For example, if following record is passed,

```js
{"msg":"hello!","level":"I"}
```

then you got filtered record like below:

```js
{"msg":"hello!","level":"INFO"}
```

### key_name

The target key name.

### destination_name

The destination key name for mapped result. If not specified, the value is overwritten in `key_name`.

Example:

    # configuration
    destination_name mapped
    # filtered record
    {"msg":"hello!","level":"I","mapped":"INFO"}

### default_value

This value is used when incoming value is missing in the dictionary. If not specified, value mapping doesn't happen.

    # configuration
    default_value UNKNOWN
    # incoming record
    {"msg":"hello!","level":"Z"}
    # filtered record
    {"msg":"hello!","level":"UNKNOWN"}

### dictionary

The json dictionary for value mapping.

### dictionary_path

Use json file instead of in-place `dictionary` parameter. This is useful for large dictionary. File ext must be `json`.

Example:

    dictionary_path /path/to/dict.json

## Copyright

<table>
  <tr>
    <td>Author</td><td>Masahiro Nakagawa <repeatedly@gmail.com></td>
  </tr>
  <tr>
    <td>Copyright</td><td>Copyright (c) 2018- Masahiro Nakagawa</td>
  </tr>
  <tr>
    <td>License</td><td>Apache 2 License</td>
  </tr>
</table>
