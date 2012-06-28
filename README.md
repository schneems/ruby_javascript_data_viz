# Move View Logic

## What?

Last week we pulled data from our database and showed it using ERB in our HTML views. We even took data from a user and put it into our database using forms.

This week we will move logic and SQL queries from the view to the controller and use view helpers for our forms.

## Fork & Clone

This exercise picks up where [last week's exercise](https://github.com/schneems/routes_controller_exercise) left off. Even so it will be a bit easier for you to follow along if you fork and clone this repo.

Go to the directory where you like to store your rails code.

Fork this project and then clone it to your local machine.


## Ruby

You will need ruby 1.9 or higher for this example. You can check your version of Ruby by running:

    $ ruby -v

## Install

Once on your local machine you will need to navigate to the project directory and run:

    $ bundle install

This might take awhile, afterwards  you will need to run:

    $ rake db:create
    $ rake db:migrate
    $ rake fake:data


This will create a Users table and a Products table. The MVCr (Model View Controller (r)outes) for users has already been created. Then start up a server

    $ rails server


## 1)

Open the project in your favorite text editor like [Sublime Text](http://www.sublimetext.com/), take a look at the `app/views/products/index.html.erb` this is the page where we  display all of our products. You might also want to open a web browser [http://localhost:3000/products](http://localhost:3000/products). As i'm developing i usually have a browser open with the site i'm working on, my text editor open, and the console available so I can see the logs.

