# Sbconstants

Generate a constants file by grabbing identifiers from storyboards in a project. See [my blog post](http://paul-samuels.com/blog/2013/01/31/storyboard-constants/) for more use cases.

## Installation

    $ gem install sbconstants

## Usage

For automated use:

1. Add a file to hold your constants e.g. `PASStoryboardConstants.(h|m)`
2. Add a build script to build phases  
        sbconstants path_to_constant_file
3. Enjoy your identifiers being added as constants to your constants file

For manual usage ( in swift ):
  `sbconstants app/objc.swift --source-dir resources/Storyboards --swift`

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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
