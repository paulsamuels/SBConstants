# Sbconstants

Generate a constants file by grabbing identifiers from storybaords in a project

## Installation

    $ gem install sbconstants

## Usage

For automated use:

1. Add a file to hold your constants e.g. `PASStoryboardConstants.(h|m)`
2. Add a build script to build phases  
        sbconstants path_to_constant_file
3. Enjoy your identifiers being added as constants to your constants file

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
