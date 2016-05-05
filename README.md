# sbconstants

Generate a constants file by grabbing identifiers from storyboards in a project.

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
    -n, --namespace=<namespace>      Prefix each constant with <namespace>
    -p, --prefix=<prefix>            Only match identifiers with <prefix>
    -s, --source-dir=<source>        Directory containing storyboards
    -t, --templates-dir=<templates>  Directory containing the templates to use for code formatting
    -q, --queries=<queries>          YAML file containing queries
    -v, --verbose                    Verbose output
    -w, --swift                      Output to a Swift File
```

An example usage would look like:

    sbconstants MyApp/Constants/PASStoryboardConstants.h
    
**NB** The argument is the destination file to dump the constants into - this needs to be added manually
    
Every time `sbconstants` is run it will parse the storyboard files and pull out any constants and then dump them into `PASStoryboardConstants.(h|m)`. This of course means that `PASStoryboardConstants.(h|m)` should not be edited by hand as it will just be clobbered any time we build.

The output of running this tool will look something like this:

`PASStoryboardConstants.h`
```
// Auto generated file - any changes will be lost

#import <Foundation/Foundation.h>

#pragma mark - segue.identifier
extern NSString * const PSBMasterToDetail;
extern NSString * const PSBMasterToSettings;

#pragma mark - storyboardNames
extern NSString * const Main;

#pragma mark - tableViewCell.reuseIdentifier
extern NSString * const PSBAwesomeCell;

```

`PASStoryboardConstants.m`
```

// Auto generated file - any changes will be lost

#import "PASStoryboardConstants.h"

#pragma mark - segue.identifier
NSString * const PSBMasterToDetail = @"PSBMasterToDetail";
NSString * const PSBMasterToSettings = @"PSBMasterToSettings";

#pragma mark - storyboardNames
NSString * const Main = @"Main";

#pragma mark - tableViewCell.reuseIdentifier
NSString * const PSBAwesomeCell = @"PSBAwesomeCell";

```

Using the `--swift` flag this would produce

```
// Auto generated file from SBConstants - any changes may be lost

public enum SegueIdentifier : String {
    case PSBMasterToDetail = "PSBMasterToDetail"
    case PSBMasterToSettings = "PSBMasterToSettings"
}

public enum StoryboardNames : String {
    case Main = "Main"
}

public enum TableViewCellreuseIdentifier : String {
    case PSBAwesomeCell = "PSBAwesomeCell"
}
```

The constants are grouped by where they were found in the storyboard xml e.g. `segue.identifier`. This can really help give you some context about where/what/when and why a constant exists.

##Options

Options are fun and there are a few to play with - most of these options are really only any good for debugging.

####`--namespace`
    -n, --namespace=<namespace>      Prefix each constant with <namespace>

If you need to add a prefix to each constant generated, you can use `namespace` option. This is useful if you have issues with XIBs file constant names and classnames (usually `Whatever.xib` is associated with `Whatever` classname, so compiler will return an error).

####`--prefix`
    -p, --prefix=<prefix>            Only match identifiers with <prefix>
    
Using the `prefix` option you can specify that you only want to grab identifiers that start with a certain prefix, which is always nice.

####`--source-dir`
    -s, --source-dir=<source>        Directory containing storyboards
    
If you don't want to run the tool from the root of your app for some reason you can specify the source directory to start searching for storyboard files. The search is recursive using a glob something like `<source-dir>/**/*.storyboard`

####`--dry-run`
    -d, --dry-run                    Output to STDOUT
    
If you just want to run the tool and not write the output to a file then this option will spit the result out to `$stdout`

####`--verbose`
    -v, --verbose                    Verbose output
    
Perhaps you want a little more context about where your identifiers are being grabbed from for debugging purposes. Never fear just use the `--verbose` switch and get output similar to:

`sample output`
```

#pragma mark - viewController.storyboardIdentifier
//
//    info: MainStoryboard[line:43](viewController.storyboardIdentifier)
// context: <viewController restorationIdentifier="asd" storyboardIdentifier="FirstViewController" id="EPD-sv-vrF" sceneMemberID="viewController">
//
NSString * const FirstViewController = @"FirstViewController";

```

####`--queries`
    -q, --queries=<queries>          YAML file containing queries
    
Chances are I've missed some identifiers to search for in the storyboard. You don't want to wait for the `gem` to be updated or have to fork it and fix it. Using this option you can provide a YAML file that contains a description of what identifers to search for. The current one looks something like this (NB this is a great starting point for creating your own yaml):

`queries`
```

---
segue: identifier
view: restorationIdentifier
? - tableViewCell
  - collectionViewCell
: - reuseIdentifier
? - navigationController
  - viewController
  - tableViewController
  - collectionViewController
: - storyboardIdentifier
  - restorationIdentifier
  
```

This looks a little funky but it's essentially groups of keys and values (both the key and the value can be an array). This actually gets expanded to the following table:

    +--------------------------+-----------------------+
    |         node             |      attribute        |
    + -------------------------+-----------------------+
    | segue                    | identifier            |
    | view                     | restorationIdentifier |
    | tableViewCell            | reuseIdentifier       |
    | collectionViewCell       | reuseIdentifier       |
    | navigationController     | storyboardIdentifier  |
    | viewController           | storyboardIdentifier  |
    | tableViewController      | storyboardIdentifier  |
    | collectionViewController | storyboardIdentifier  |
    | viewController           | restorationIdentifier |
    | navigationController     | restorationIdentifier |
    | tableViewController      | restorationIdentifier |
    | collectionViewController | restorationIdentifier |
    +--------------------------+-----------------------+

####`--swift`

    -w, --swift                      Output to a Swift File
    
Outputs Swift code rather than Objective-C

####`--templates-dir`

    -t, --templates-dir=<templates>  Directory containing the templates to use for code formatting
    
See below

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
