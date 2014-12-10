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
    -p, --prefix=<prefix>            Only match identifiers with <prefix>
    -s, --source-dir=<source>        Directory containing storyboards
    -w, --swift                      Use the swift language
    -q, --queries=<queries>          YAML file containing queries
    -d, --dry-run                    Output to STDOUT
    -v, --verbose                    Verbose output
    -r, --remove-space               Remove space before * on const declaration "NSString const*" vs "NSString const *"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
