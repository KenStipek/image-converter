# Lets Convert Some Images!
It is very common for modern web applications to handle image storage, conversion, and hosting. To reduce bandwidth use, applcations convert uploaded images into various sizes, quality levels, and formats. This can be very processor intensive and limiting as the applications are only able to get the image formats that they have already generated (and genarating new images can take forever for large image sets).

### This Solution!
This tool is designed to sit between an application's file store and its content distribution network (CDN). It works by setting your CDN's origin server to this tool. So when an image is requested from your CDN it request the image from this tool, this tool then grabs the original image from your file store, processes it (resize, quality, format conversion, etc...), and send it back to the CDN. Now whenever that image is requested, it will simply respond with the image stored in the CDN (and won't re-process it).

### Cool! What all can this tool do?
This tool is built on top of ImageMagick and RMagick. So pretty much everything ImageMagick can do, this tool can do to (see a [full list here](https://github.com/KenStipek/image-converter/blob/readme/methods.md), and the [RMagick API docs here](http://www.imagemagick.org/RMagick/doc/))!

### What does a request look like?
Lets say you have an images stored at http://example.com/images/ and you wanted to get an image called be-cool.jpg, remove some of the colors, and convert it to a PNG. Assuming you have your CDN set up at cdn.example.com and that CDN's origin server is pointing at this tool all you would need to do is include the ImageMagick methods and attributes in the path before the path split character.
```
http://cdn.example.com/quantize/10/_/images/be-cool.png
```
The tool ignores the file extension and converts whatever image it finds with the given name to the requested extension.

You don't have to put the methods in path if you don't want to. You can set up defaults and templates using your server's environmental variables.

###### Original Image
![original image](https://limitless-island-6276.herokuapp.com/be-cool.jpg)

###### Converted Image
![converted image](https://limitless-island-6276.herokuapp.com/quantize/10/_/be-cool.png)

### Why use the path and not GET params for the methods and attributes?
Because some CDN's ignore everything after the '?' in a request and wont include them in the request to the origin server.

# Getting Started
1. Fork this Repo
2. Download and set up the Sinatra app (see this if need help with this)
3. Install ImageMagick ```brew install imagemagick``` on OSX using Homebrew, more info here
4. Install the Gems using ```bundle install```
5. Start playing with it on your local system and figure out what settings you need
6. Deploy and start rocking (don't forget to change your CDN's origin server)

## Set Up

### Requesting Images
A path is made up of two parts split by an underscore. The first half is the conversion paramaters, this can be the actual methods and attributes, a template, or both.

#### Param Attributes