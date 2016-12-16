# rando-pk: a randomized pecha kucha generator

Ever want to practice your improv skills and your presentation skills? The rando-pk is the tool for you. It grabs a random image from https://commons.wikimedia.org and generates a random title. The rules of a pecha kucha is simple:

> 20 slides are shown for 20 seconds each (6 minutes and 40 seconds in total)

## Prerequisites
- imagemagik (https://www.imagemagick.org/script/binary-releases.php) and its dependencies
- ruby 2.2.6
- bundler

## To run (dev mode)
- Install all the required gems `bundle install`
- Start the app through rake `rake shotgun`
- Open the app (http://127.0.0.1:9393) in your favourite browser

## Docker
- Build the image `docker build . -t rando-pk`
- Start the image `docker run -d -p 80:80 rando-pk`
- Open the app (http://127.0.0.1) in your favourite browser

## Improvements
- Make the introduction slide generate faster: the app uses imagemagik to generate a slide and the generation take between 1 and 10 seconds
- Make a better randomzied title: it's just a random quote generator that sometimes makes no sense at all
- Make the images search based off of the topic
