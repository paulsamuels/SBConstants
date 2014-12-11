# sbconstants

Generate a constants file by grabbing identifiers from storyboards in a project. See [my blog post](http://paul-samuels.com/blog/2013/01/31/storyboard-constants/) for more use cases.

## Installation

    $ gem install sbconstants

## Usage

For automated use:

1. Add a file in Xcode to hold your constants e.g. `PASStoryboardConstants.(h|m)`
2. Add a build script to build phases  
        sbconstants path_to_constant_file
3. Enjoy your identifiers being added as constants to your constants file

For manual use (using swift):

1. Add a file in Xcode to hold your constants e.g. `StoryboardIdentifiers.swift`
2. Add a command to your [Makefile](https://github.com/artsy/eidolon/blob/15da1330a04615b3553779742f166b707c6ef65f/Makefile#L54) to run something similar to `sbconstants path/to/StoryboardIdentifiers.swift --source-dir path/to/Storyboards --swift`

## Command line API

```sh
$ sbconstants -h
Usage: DESTINATION_FILE [options]
    -d, --dry-run                    Output to STDOUT
    -p, --prefix=<prefix>            Only match identifiers with <prefix>
    -s, --source-dir=<source>        Directory containing storyboards
    -t, --templates-dir=<templates>  Directory containing the templates to use for code formatting
    -q, --queries=<queries>          YAML file containing queries
    -v, --verbose                    Verbose output
    -w, --swift                      Output to a Swift File
```

## Custom formatting

If you are running tools that verify your team is sticking to coding conventions you might find that the default output might not fit your requirements. Not to fear you can provide your own templates to decide the formatting you require by passing the `--templates-dir` option with the path to the directory containing the templates to use.

Inside your custom templates you can interpolate the `constant_name` and `constant_value` like this

```
NSString * const <%= constant_name %> = @"<%= constant_value %>";

```

You can override how the Objective-C constants are formatted by creating `objc_header.erb` and `objc_implementation.erb` files and adding the `--templates-dir` flag pointing to their containing directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
