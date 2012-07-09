# Javascript & Data Viz in your View

## What?

So far we've focused solely on server side programming, but most powerful modern websites use a combination of server side (ruby) and client side (javascript) to accomplish a more native feel. This combination is where the whole web 2.0 hype came from. In this exercise we'll introduce you to javascript and jQuery, as well as the manipulating the DOM and visualizing data with a javascript library called HighCharts. Finally we'll add some dynamic asynchronous behavior using AJAX. What are you waiting for? Get started!


## Fork & Clone

This exercise mostly picks up where last week's exercise left off. Even so it will be a bit easier for you to follow along if you fork and clone this repo.

Go to the directory where you like to store your rails code.

Fork this project and then clone it to your local machine.


## Ruby

You will need ruby 1.9 or higher for this example. You can check your version of Ruby by running:

    $ ruby -v

## Install

Once on your local machine you will need to navigate to the project directory and run:

    $ bundle install

This might take awhile, afterwards you will need to run:

    $ rake db:create
    $ rake db:migrate
    $ rake fake:data


This will create a Users table and a Products table. The MVCr (Model View Controller (r)outes) for users has already been created. Then start up a server

    $ rails server


## 1 ) Javascript & jQuery

Javascript is an extremely important part of the internet, enabling us to manipulate the [DOM](http://en.wikipedia.org/wiki/Document_Object_Model) and enable rich desktop interactions without page refreshes like [Gmail](http://gmail.com).

> If you already know javascript jQuery well, you can skip to the next section, or you can still do this section for review.

Open up a browser and visit [http://localhost:3000/products](http://localhost:3000/products), chrome is recommended, but firefox or safari should work as well. Right click anywhere on the page and select "Inspect Element", then select the "Console" tab. (directions may be different in different browsers). From here you have a javascript console with access to the page. Let's prove it by making an alert pop up on the page. Enter this into the console and hit enter:

    > alert('hello world');



You should get a popup that tells you "hello world". Unlike Ruby, Javascript lines should end in a semicolon `;`.
Javascript is a general purpose programming language that has types similar to Ruby including strings, integers, and arrays. You can use all of these directly in the console:

    > 1+1;
    => 2
    > "hello" + "there";
    => "hellothere"
    > a = [1,2,3,4];
    > a[0]
    => 1


If you want to print something to the console (like puts in ruby) we can run `console.log` go ahead and try this inside of the javascript console:

    > console.log('hello world');

This should output 'hello world' on the next line. By default Rails includes a javascript library called jQuery. jQuery has many powerful ways for selecting and manipulating the DOM. First we want to make sure we have jQuery loaded. Enter a dollar sign into the console `$`:

    > $

The output should be a function, similar to this:

  function ( selector, context ) {
      // The jQuery object is actually just the init constructor 'enhanced'
      return new jQuery.fn.init( selector, context, rootjQuery );
    }

If you get a SyntaxError, that means that jQuery is not loaded. If you view source on the page you should be able to see jquery being loaded:

      <script src="/assets/jquery.js?body=1" type="text/javascript"></script>

You can even see the code behind jquery by visiting [http://localhost:3000/assets/jquery.js](http://localhost:3000/assets/jquery.js). For now it's not important to know how jQuery works, but you need to understand that it is a library written in javascript that can be loaded into a web page. It is also important thtat you understand how to check for the presence of jQuery.

Now that we've seen that jQuery is successfully loaded, lets manipulate the DOM a bit.

jQuery takes css style selctors, that means we can target id's using `#` classes using `.` and elements by using them directly. To target all link's on the page we can use this selector:

    > $('a')

The output of this in the console should be an array of links similar to:

    [<a href=​"/​users">​a list of users​</a>​, <a href=​"/​products">​a list of products​</a>​]

Now that you have references to these elements you can manipulate them using jQueries available manipulators [http://api.jquery.com/category/manipulation/](http://api.jquery.com/category/manipulation/) and effects [http://api.jquery.com/category/effects/](http://api.jquery.com/category/effects/).

As i'm working with jQuery, I often want to make sure I am targeting the right elements. To help with that end, I like using `hide()` and `show()`. Note that javascript functions require parenthesis even if there are no arguements unlike ruby. Let's make sure we've got the links we're looking for:

    > $('a').hide();

You should see the links in the top of the page go away. You can bring them back by running

    > $('a').show();

Once we have a reference to an element, we can walk up and down it's dom tree by traversing the DOM "tree" [http://api.jquery.com/category/traversing/](http://api.jquery.com/category/traversing/).

If we only wanted to hide the last DOM element we could run

    > $('a').last().hide();

And then to show it again:

    > $('a').last().show();

If we have access to one element on the page, we can walk up and down our tree to get any element. Lets grab a table data `td` cell:

    > $('td').first().toggle();

Toggle will hide if the element is visible and show if it is hidden.

Now that we have a table cell lets get the whole table. Since a table cell is inside of a table, it can be said that the table is a table cell's parent.

We can get the parent by calling `parent()` let's give this a shot:

    > $('td').first().parent().toggle();

What happened when you hit enter? The table didn't dissapear, but why? If you inspect the html (right click >> inspect, or click on the "elements" tab in the inspector) you can see that the table cells `td` are inside of table rows `tr`


    <tr>
      <td>1</td>
      <td>HD Electric Amplifier</td>
      <td>$381</td>
      <td>Asa Morar</td>
    </tr>

When we grabbed the parent of our first `td` we got a reference to the first `tr` (table row) so when we hit enter the first row of our data goes away. Now that we have a reference to the first `tr` how can we get a reference to `table`?

Take a look at the html if you don't see it right away. Take a look below:

    <table>
      <tbody>
      ...
        <tr>
          <td>1</td>
          <td>HD Electric Amplifier</td>
          <td>$381</td>
          <td>Asa Morar</td>
        </tr>
      ...

We got a reference to `<td>1</td>` then got it's parent `<tr>`, now we want `<table>` which above `<tbody>`'s parent. So table is just a parent of `tbody` which is a parent of `tr` which is a parent of `td`. We can select it like this:

    > $('td').first().parent().parent().parent().toggle();

And now our table is gone! Run the command again to bring it back. This isn't the only way to make the table dissapear, but it is one way to show how we can walk up the dom tree. If we wanted we could reference it directly:

    > $('table').toggle();

Or we can use the advanced finding features made available via the `parents()` function [http://api.jquery.com/parents/])(http://api.jquery.com/parents/):

    > $('td').first().parents('table').toggle();

Note that this is parents with an 's' and not parent. jQuery provides us with many ways of traversing elements, when you find that you need to do this just break up your elements mentally into parents, siblings, and children and then check the jQuery docs on traversing [http://api.jquery.com/category/traversing/](http://api.jquery.com/category/traversing/).

# 1.2) Put some javascript in our ERB

Now that you've played around with jQuery, let's put some in our code, We can embed javascript right into our html by using script tags. Open up `app/views/products/index.html.erb` and add this code to the bottom of the page:

    <script type='text/javascript'>
      alert('hello world');
    </script>

Open up [http://localhost:3000/products](http://localhost:3000/products) to refresh the page, you should be greated by a nice pop up. Make sure your javacript console is open and change the alert to `console.log('hello world');` like this:

    <script type='text/javascript'>
      console.log('hello world');
    </script>

You should see "hello world" in the log. Using `console.log()` is a great way to debug our code without having annoying alerts popping up all over the place. You can do anything inside of these script tags that you can do inside of a javascript console.

Lets try manipulating the DOM:

    <script type='text/javascript'>
      $('table').hide();
    </script>

When you refresh the page, the table disappears. Now try moving that code up to the top of your `index.html.erb`, above the `h2`. When you refresh the page what happens? You can still see the table, why is that? As the page is rendering in the browser, it renders from top to bottom when it gets to the line `$('table').hide();` it will tell the browser to hide all table elements. The problem is we put this line above our `<table>`, so although the browser is correctly told to hide the table, it isn't on the page yet, so nothing happens. The browser then continues to render the page after our script tags. It then renders the table and completes the page.

So we can manipulate the DOM, but only if it's loaded. What if there was some way we could tell our browser to wait till the page is loaded before we execute the javascript. Luck for you, we can...jquery comes with a great little helper called `ready()`, so we can change the code to this:

    <script type='text/javascript'>
      $(document).ready(function(){
          $('table').hide();
        });
    </script>

Now refresh the page, and the table is gone like we would expect. Let's take a look at what we just did.

We already know about the script tags and `$('table').hide();` so lets look at the `ready()` line:

      $(document).ready(function(){

Here we are taking the document object (which is given to us for free by javascript[http://www.w3schools.com/jsref/dom_obj_document.asp](http://www.w3schools.com/jsref/dom_obj_document.asp)). The `document` object is a reference to our whole page. In the console we can run

    > document.write('foo');

This will replace all the contents of the page with the text 'foo'. Refresh the page to get your old content back. If we want to be able to call jquery methods on an object we can pass that object into the jquery function `$` this is what happens when we execute

    $(document)

This is similar to when we used jQuery's css selector syntax except we are passing a javascript object `document` directly in.

Now that we have a jQuery object we can call jQuery functions on the object. `ready()` happens to be a jquery function [http://api.jquery.com/ready/](http://api.jquery.com/ready/).

So we've got most of the first line except for that pesky function thing, what is that? In ruby we can define functions using the `def` keyword. In javascript we can define a function using `function(){}` any code that is put in the curly brackets `{}` gets executed when the function is called. Let's open the console and take a look:

    > fun = function(){console.log('this is fun')};

Here we are creating a function that contains the code `console.log('this is fun')` and assigning it to a variable. This is where javascript starts to look totally different from ruby. In javascript functions can be passed around like objects. If we call our `fun` variable we can see the contents of the function:

    > fun
    => function (){console.log('this is fun')}

So how do we call this function? Since it isn't taking any arguments we can call it by adding empty parenthesis to the end of the variable:

    > fun();
    => "this is fun"

Javascript often takes functions as arguments in order to use them as callbacks. Callbacks behave much like they sound. If you tell your friends to give you a call back when they get home, you can continue to do work without having to worry about when your friend is home, when they get home they will call you back. In the same way we are registering this function:

    function(){
      $('table').hide();
    }

as a callback so when the document is done loading it will say that it is 'ready' when this happens our callback can be called.

So when we put it all together:

      $(document).ready(function(){
          $('table').hide();
        });

We are telling the document object that when it is ready, call the function that has the code `$('table').hide();`.

Wow that was a lot of explanation for a very little bit of code. The reason I want to talk about it here, is that javascript uses callbacks heavily. This type of programming can be refered to as event based programming, since we are waiting for an event (the document is ready) before we run our code.

Callbacks especially can be tricky, so lets take a look at another real world example. Let's say you are looking for a new job and you go into an interview. You give them your phone number so that when they make a decision they can call you and you can celebrate if you got the job, or be sad if you didn't. The alternative if that callback mechanism didn't exist would be to call the company every few minutes to see if they made a decision. This would render you incapable of doing anything else, and your life would be rendered useless until they make a decision. This type of behavior is referred to as polling, since you are polling the company to ask if they have made a decision. Callbacks in code work in a similar way. Here instead of waiting for a decision from our interview we are waiting for a programming defined event called document ready. We'll store the function to be called later and when that event fires it will trigger our function. We can also refer to this behavior as non-blocking, since it does not stop, or block, the execution of the program while waiting for the event.


## 2)  javascript and ERB

We're almost done playing around and ready to add some awesome javascript charts and graphs to our page. Before we can do that we need to send some data to javascript. First remove the javascript to hide our table. We are going to pass data from ruby to javascript using erb. Here we want to log the number of products to the javascript console

    <script type='text/javascript'>
      console.log('the number of products is ' + '<%= @products.count %>');
    </script>


I get this as an output:

    the number of products is 231

Your number might be different but the important part is that number of products contained in ruby was written to our HTML document where javascript could read it. If you view source on the page you'll see that number in plain text:

    <script type='text/javascript'>
      console.log('the number of products is ' + '231');
    </script>

Hopefully you can start to see how ERB and javascript can interact. Lets add a charting library to our project. There are many different javascript charting libraries. One of my favorites is [High Charts](http://www.highcharts.com/) which is free to use for non comercial use, and pretty cheap for commercial projects. Another popular library is (D3)[http://d3js.org/], D3 is open source and completely free to use. There are also a number of libraries built on top of D3 like [LiesDamnedLies](https://github.com/Induction/LiesDamnedLies). For this project we will be using High Charts. First go to [http://www.highcharts.com/](http://www.highcharts.com/) and then download the Highcharts (version 2.2.5 at the time of this writing) http://www.highcharts.com/download.

Once the file is done downloading, unzip it and open the folder. THere should be an `index.htm` file. Open this in a web browser such as chrome. This is a static HTML file that contains links to all of the examples that come with the library. If you are having problems implementing a chart it can be very useful to see a simple working example. Take a look at the file and view several examples. When you're done open up the `js` folder where we have access to all of the javascript files.

Here we have access to several folders and files. We will be focusing on `highcharts.src.js`. This contains the same code as `highcharts.js` but `highcharts.js` is minified. Since javascript is run in the browser the entire source code must be sent each time a page is loaded, because of this larger javascript files can slow down page loads. To combat this we can run javascript through a minifier like [YUI compressor](http://developer.yahoo.com/yui/compressor/). A minifier removes all whitespace (spaces and new lines) and will rename internal variables to shorter versions, for example it my rename `mobileShowDidDisplay` to `m`. This might seem pedantic, but there are signifigant size savings while minifying javascript.

Since we're using Rails (above 3.1) we have acces to the asset pipeline which helps to minimize javascript for us. Because of this we can use the full source in developement, and serve the minified version in production. Copy the `highcharts.src.js` file and paste it into the `app/assets/javascripts/` directory in your rails project.

Visit http://localhost:3000/products in your browser and inspect the source, you should see this in your HTML:

    <script src="/assets/highcharts.src.js?body=1" type="text/javascript"></script>

If you don't then you might not have put the highcharts file in the correct place. When we deploy to production, all the javascipt files will be minified and put into one file (application.js). This is because the asset pipeline in rails will compile the `app/assets/javascripts/application.js` and it contains this line


    //= require_tree .

Which tells it to load all javascript files in the same directory (in unix a period . indicates current directory, much like you can open a directory from the command line by running `$ open .`). This ability is brought to us by the asset pipeline and is not a usual javascript ability.

Once we have the highchart library loaded into our view, we can use it. High charts requires a target element where you tell it to render the chart in your html, so let's add one, open up `app/views/products/index.html.erb` and before your table put this in:


    <div id="highChartContainer" style="min-width: 400px; height: 400px; margin: 0 auto"></div>


Here we are adding a blank `div` element and giving it an inline style and setting it's id to `highChartContainer`. In HTML id's on a page are expected to be unique, there should not be two identical id's on a page. It is considered bad form to use id's for styling, instead you would likely use classes `class='btn'` instead. Now that we have an element with an id that highcharts can target lets add our javascript, open up the file and at the bottom of your page add this:


    <script type='text/javascript'>
        chart = new Highcharts.Chart({
        chart: {
            renderTo: 'highChartContainer',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'Browser market shares at a specific website, 2010'
        },
        series: [{
            type: 'pie',
            name: 'Browser share',
            data: [
                ['Firefox',   45.0],
                ['IE',       26.8],
                ['Chrome',   12.8],
                ['Safari',    8.5],
                ['Opera',     6.2],
                ['Others',   0.7]
            ]
        }]
      });
    </script>



Refresh your page [http://localhost:3000/products](http://localhost:3000/products) and you should see a pretty sweet pie chart. If you don't check your javascript console to see if there are any errors. Double check the ID on your div matches the `renderTo` in your chart. Like we did before we're going to want to wrap this in a `$(document).read()` call so it doesn't matter where on the page we put our javascript. Add those lines at the top and the bottom of your javascript code:



    <script type='text/javascript'>
      $(document).ready(function(){
        // ... chart code goes here
        });
    </script>


Refresh the page to make sure everything worked. The javascript you've entered is pretty long and seemingly complex but it's not really, quite a bit of it is configuration and is optional. Most of this configuration is done using javascript objects. Javascript objects look and behave much like ruby hashes, this is an example of a javascript object, we can take the first part and assign it to a variable called `foo` in the console:


    > foo = {
          renderTo: 'highChartContainer',
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
        }

Now we can use the keys on the left as methods on our object `foo`

    > foo.renderTo
    => "highChartContainer"

    > foo.plotBackgroundColor
    => null

Some things to note that are different from ruby here, javascript uses `null` instead of `nil` and the hashrocket (`=>`) notation will not work in javascript. Finally method names are camel case, which means that rather than separating method names with underscores like `render_to` we separate them by changing the case of our variables like `renderTo`. This mostly stems from javascript's attempts to minimize size. You can name your variables anything you want, but seasoned javascript devs will appreciate it if you use camel case.

There are a number of options that can be configured, you can see them if you go to [http://www.highcharts.com/demo/pie-basic](http://www.highcharts.com/demo/pie-basic) you can see a demo, you can visit the documentation to see all of the different options available at the [Highcharts reference](http://www.highcharts.com/ref/). You can even experiment with options in your browser by viewing the charts in [jsFiddle](http://jsfiddle.net/gh/get/jquery/1.7.2/highslide-software/highcharts.com/tree/master/samples/highcharts/demo/pie-basic/).

It is common to have the documentation and jsFiddle open in addition to your project.

Okay, so most of the options are configured using javascript objects, which can also be called JSON for JavaScript Object Notation. How do we get data to our chart? If you look at the last key in our configuration, it is called `series`. This key contains a value of an array of arrays:


    [
      ['Firefox',   45.0],
      ['IE',       26.8],
      ['Chrome',   12.8],
      ['Safari',    8.5],
      ['Opera',     6.2],
      ['Others',    0.7]
    ]

The first value in each is the name of the pie slice, and the second is the value in decimal, this is how we will get data to highcharts, we will take the price of all of our products and show the percentage of total prices it represents.

We'll need an array of arrays with our product prices and names populated from ruby. If you open up a rails console we can try to build this before we put it into our view:

    $ rails console
    > products = Product.all
    > total    = Product.sum(:price)
    > products.map do |product|
        [product.name, product.price/total.to_f]
      end
    => [["GPS Output Case", 0.0023375604217626875], ["HD Component", 0.0036399155138876135]...]

Okay, lets look at what we just did, we got all of our products and the sum of our product prices using SQL through active record. Then we used an iterator to build an array of arrays. The first entry is `product.name` and the last is the product's price divided by the total price `product.price/total.to_f`. You may be qondering why we call `total.to_f` ? This is because product.price is an integer and total is also an integer, when you divide an integer by an integer you will get an integer as a result go ahead an run:

    > 1/1
    => 1

Okay that makes sense but lets try

    > 1/2
    => 0

That doesn't make sense, we should get `0.5`. Lets add a `to_f` (to float) on one of the integers

    > 1/2.to_f
    => 0.5

That's much better, we can also add a decimal to one of the digits to get the same result

    > 1/2.0
    => 0.5

If you get strange results durring division in ruby check to make sure one of your digits is a float.

Alright, we've got our array of arrays but we've got to put it into our javascript through ERB.

Open up your products controller and add this line into the index action:


    @sum_price = Product.sum(:price).to_f

Then in your index.html.erb view put this outside of the JS tags:


    <%=
        @products.map do |product|
          [product.name, product.price/@sum_price]
        end
    %>


When you refresh your products page you should see an array of arays of product names and prices

  [["GPS Output Case", 0.0023375604217626875], ["HD Component", 0.0036399155138876135]...]

Let's put this into our javascript, replace your javascript with this code:


    <script type='text/javascript'>
      $(document).ready(function(){
            chart = new Highcharts.Chart({
            chart: {
                renderTo: 'highChartContainer',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Browser market shares at a specific website, 2010'
            },
            series: [{
                type: 'pie',
                name: 'Product Share',
                data:
                  <%=
                      @products.map do |product|
                        [product.name, product.price/@sum_price]
                      end
                  %>
            }]
        });
    });
    </script>


When you refresh the page, the graph goes away, why? Lets view source on our javascript. When you get to the data section of your series you should see something like this:


   data:
              [[&quot;HD Electric Amplifier&quot;, 0.0031807518596127997], [&quot;Video Electric Amplifier&quot;, ... ]

What happened? When we put it in our HTML it looked fine when it rendered on the page. If you google `&quot;` you'll see this is how we can represent a quotation mark in HTML. What is happening, is rails isn't exactly sure how we want to render that array, since we have to output it to the page as a string, it is converting our array to a string and making some assumptions for us. Second, since we're building that string using data from our database rails is being helpful by automatically escaping strings for us, otherwise we could get into trouble if someone devious decided to enter some bad html into the product name like `<script type='text/javascript>document.write('haha i broke your website')</script>`.

So we need to tell rails how to convert our array into a proper string javascript can understand and then tell rails that all of these values from the database are safe since we put them all there. We can change our ruby line to this:

    @products.map do |product|
      [product.name, product.price/@sum_price]
    end.to_json.html_safe

Here we are calling `to_json` on our array of arrays which puts it into a string that javascript can easily understand, then we tell rails that we don't want the values to be escaped as html. When you refresh the page again you should be rewarded with a pie chart of our data!

Passing data from ruby to javascript is as easy as building strings in ruby and rendering it using ERB. If your data is like mine, you've got way too many products, you can limit these in your controller by replacing this line:

    @products = Product.includes(:user).all

with this line:

    @products = Product.includes(:user).first(20)

Now refresh the page, and the chart should be much easier to read with fewer values. Awesome!!

So again, passing values from our database to javascript can be as "easy" as rendering html.

Javascript is a very powerful front end tool and can help make our web site more responsive.


## 3) Manipulating View with jQuery

We've played around with the DOM through jQuery but we haven't done anything serisous. We've got a bunch of information on this page, but it is hard to see all of it at the same time. We're going to build some javascript powered links that hide our chart or data depending on what button we press.

We can embed javascript directly into a link by adding `javascript:` into the href like this:


    <a href="javascript:$('#highChartContainer').toggle()">Chart</a>

Add that link into your page, refresh and then click the link to make sure your chart toggles correctly.

We can do this using the onclick handler of links if we wanted:

    <a href="#" onclick="$('#highChartContainer').toggle()">Chart</a>

Note that we put a hash `#` into the href of the link, without it the browser doesn't know that the link can be clicked and the user will not get a different cursor when they hover over it. This has an unfortunate side effect of scrolling users to the top of the page when they click the link, instead we can add `javascript:void(0)` which will not scroll the page:

    <a href="javascript:void(0)" onclick="$('#highChartContainer').toggle()">Chart</a>


So you can put your javascript in the `href` using `javascript:` or you can put it in an onclick handler. Though much like using inline styles, putting inline scripts is typically avoided when possible. It is considered better practice to seperate the link and the javascript, we can use id's, classes, or data attributes to mark our tags and then use jquery's powerful selector syntax to add javascript ability to them.

First add a link:

    <a href="#">Chart</a>

Now we ned to give it an attribute so that jquery can find this one specific link, if we chose an ID we can only have one link that closes the charts on the page, since id's should be unique. Instead let's use a class:

    <a href="#" class='closeChart'>Chart</a>

So now we can target any link (or element) with a class of `closeChart` using `$('.closeChart')` we can simply add an onclick handler using jquery:

    <script type='text/javascript'>
      $('.closeChart').on('click', function(){
          $('#highChartContainer').toggle()
        });
    </script>

The jQuery event handler [on](http://api.jquery.com/on/) takes an event name, in this case 'click' and then a function to be executed once the click is performed. Now we can add links that close our charts container all over the page:


There is one way we could improve this further. Since we're targeting this element with a class which is how css targets elements to be styled it might be possible down the road that you or a designer adds a style to the class `closeChart` but doesn't like the way it looks on this page (only on other pages) so they do the logical thing and delete the class:


    <a href="#" class=''>Chart</a>

Now the page looks as it should to them! Unfortunately that just broke our javascript. Instead of relying on class or id, I mentioned that we could instead use data attributes, these are custom attributes that start with `data-`: Let's add one to our link:

    <a href="#" data-hide-element='chart'>Chart</a>


We can select attributes using brackets in jquery `[]` so we can re-write our javascript like this:

    <script type='text/javascript'>
      $('[data-hide-element=chart]').on('click', function(){
          $('#highChartContainer').toggle()
        });
    </script>

Now anyone on your team can edit id's and classes as they please. Your javascript will still work as planned.


## 4) Asyncronous Client Side Updates (AJAX)

By now we've used jquery to manipulate the DOM, and used ruby to render some pretty sweet data visualizaitons. All of this is just manipulating static html, what if we wanted to update some elements on the page from our server dynamically, or send data to our server without a page refresh, how would we do that?

We can send asyncronous requests from javascript to our server, and then manipulate our page with any data we get back. Asyncronous means that we don't have to wait for the request to finish and we don't have to refresh the page. A text message is asyncronous communication, you can send one and forget about the conversation until you get one back. Calling someone on a phone is syncronous communication since you can't go anywhere untill the call is over and you hang up the phone.

What type of functionality might we want to make asyncronous? There are plenty of 'upvote' and 'like' buttons on the Internet these days, while we aren't recording votes, our products do have a price. We could add a button that would allow us to update the button's price. 

First we'll build this functionality in normal synchronous way using page refreshes and links. We'll then re-build it asyncronously using javascript.

in `app/views/products/index.html.erb` Add this line to your table at the end:


    <td><%= link_to "+", product_path(product, :product => {:price => product.price + 1}), :method => :put %></td>


We are build a link to the update action and we are sending the price + 1 so when you click the link it will hit the update action, which will redirect you back to this page. You should see the value go up by one. You can click again and the value will go up again. This happens pretty fast, but there is still a noticible page refresh, let's change this to an asynchronous javascript request.


We'll take the same basic pattern, of hitting the update action to update the database, and then updating our view using javascript. To do this change this line:

    <td>$<%= product.price %></td>

to this:

    <td data-product='<%= product.id %>'>$<%= product.price %></td>


We're tagging our price with the current product id so we can target it with javascript later. Next change your link that we added to increment the price to this:

        <td><%= link_to "+", product_path(product), 
                'data-incr-price' => product.id,  
                :method           => :put %></td>


We're adding another data attribute to tag our increment link. What we need to do is see when this link is clicked, prevent the default behavior (page refresh) from happening, and instead submit the value with javascript. Let's do that now:

    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){

        console.log('clicked');
        })
    </script>

If you refresh the page, open a javascript console and click a plus button '+' you should get "clicked" as an output in the console, but clicking the link still activated a page reload, how do we prevent that? Notice in our on() method above we are passing in our event to our function() as a variable `e`. We can use this to stop propagation of that event (clicking the link) and prevent it from triggering a page reload like this:

    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();
        console.log('clicked');
        })
    </script>

Refresh the page and try again, you should get "clicked" in the log, but it shouldn't refresh the page. Alternatively we can return false from the function like so:

    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        console.log('clicked');
        return false;
        })
    </script>

While this is shorter, it's less clear the intent of the code, so the first method is preferred. Now that we've intercepted our click, let's send our request using javascript. 


First we will need a url to send data to. We can get this from our link, let's do that now:

    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        url = $(this).attr('href')

        console.log(url);
        })
    </script>

You should see a url in your console when you refresh the page and click a `+` link. The variable `this` is similar to ruby's `self` it represents the current context. In this case `this` refers to the link we just clicked. So we can turn it into a jquery object `$(this)` and then get attributes from the object. In this case we want the url so we're grabbing the `href` attribute. All of that together gives us the url `url = $(this).attr('href')`. 

Now that we have the url we need to send out a request, to do that we will be using jQuery's [ajax method](http://api.jquery.com/jQuery.ajax/). To use it we can call `$.ajax()` and pass in options, you can get a list of options from the docs. First we'll want to pass in the url.


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          
          $.ajax({ url: url })
        })
    </script>


Save and refresh the page, now click a link again. What happened? Nothing? Check your logs? You should see something like this:

    Started GET "/products/1" for 127.0.0.1 at 2012-07-08 19:52:22 -0500
    Processing by ProductsController#show as */*
      Parameters: {"id"=>"1"}
      Product Load (0.2ms)  SELECT "products".* FROM "products" WHERE "products"."id" = 1 LIMIT 1
      Rendered products/show.html.erb within layouts/application (2.0ms)
    Completed 200 OK in 19ms (Views: 10.5ms | ActiveRecord: 0.2ms)

We successfully made a request with javascript, but there's some problems first it was issued as a GET, and not a PUT. If you check the docs on `$.ajax()` you can find that one of the options is `type` so we can change that to "put":


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          
          $.ajax({ url: url,
                   type: 'put',
                  })
        })
    </script>


Save and refresh, now when you click the link and check your logs you'll see that we're now pointing at the right url and now with a 'PUT' request. You'll see that we're still getting an error, why? It looks like it's redirecting to /products

    Redirected to http://localhost:3000/products

Take a look in your `app/controller/products_controller.rb` and the update action. Specifically the render section:


    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to :back, :notice => 'Product was successfully updated.' }
        format.json { render json: @product }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, :status => :unprocessable_entity }
      end
    end

So it looks like the @product was updated successfully and then we were redirected back to our previous path `/products`, but there is a problem here. We don't want an HTML response, we want a json response. We'll use the new price to update our view. If you check the jQuery docs for ways to change the response type, you'll find there is an option called `dataType` that we can pass as 'json', let's try that now:



    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          
          $.ajax({ url: url,
                   type: 'put',
                   dataType: 'json',
                  })
        })
    </script>


Save, render, and click the link. Now when you check your logs you'll see that we get the right url, HTTP verb, and now the right request format:

    Started PUT "/products/1" for 127.0.0.1 at 2012-07-08 20:05:21 -0500
    Processing by ProductsController#update as JSON
      Parameters: {"id"=>"1"}
      Product Load (0.2ms)  SELECT "products".* FROM "products" WHERE "products"."id" = 1 LIMIT 1
       (0.0ms)  begin transaction
      Product Exists (0.2ms)  SELECT 1 AS one FROM "products" WHERE ("products"."name" = 'HD Electric Amplifier' AND "products"."id" != 1) LIMIT 1
       (0.0ms)  commit transaction
    Completed 200 OK in 5ms (Views: 0.4ms | ActiveRecord: 0.4ms)


Notice that it is saying it is processing as JSON;

    Processing by ProductsController#update as JSON

So now that we've got the right action, we've need to send a new price. Our update action is looking for a hash of attributes named `product`, so if we want to update price, we'll need to update `params[:product][:price]`. We can send data with our `ajax()` request using the `data` option (again you can check the docs for available options). Before we can update the old price, we have to get the current price. To help out with this process we can add our price to our link as a data attribute like this:

        <td><%= link_to "+", product_path(product), 
                'data-price'      => product.price,
                'data-incr-price' => product.id,  
                :method           => :put %></td>


Now we can get our price using jQuery's `attr()` method:


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          price = $(this).attr('data-price');
          console.log(price);

          $.ajax({ url: url,
                   type: 'put',
                   dataType: 'json',
                  })
        })
    </script>


Before we add this to our ajax request we want to make sure that we've got the right value. Save, refresh, and click a link. You should see the price in your javascript console, if not double check your last steps.

Once we've got our price we need to increment it. 



    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          price = $(this).attr('data-price');
          newPrice = parseInt(price) + 1;

          console.log(newPrice);

          $.ajax({ url: url,
                   type: 'put',
                   dataType: 'json',
                  })
        })
    </script>


When we grab the value using `attr()` it will come back as a string so we need to convert it to an integer using `parseInt()` before we can increment it. It is a good idea to check this worked correctly before moving on. When I am working with javascript, I make very small steps and check frequently using `console.log()` it can be difficult to find exactly where problems crop up if you try to skip too many steps.

Now that we have a new price we want to send it to our update action, we can do that like this:


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
          e.preventDefault();
          e.stopPropagation();
          url   = $(this).attr('href');
          price = $(this).attr('data-price');
          newPrice = parseInt(price) + 1;

          $.ajax({ url: url,
                   type: 'put',
                   dataType: 'json',
                   data: { product: {price: newPrice} }

                  })
        })
    </script>


You want to save, refresh, & click a link again. Once you've done that you should see that your update worked in your log:

    Started PUT "/products/1" for 127.0.0.1 at 2012-07-08 20:19:01 -0500
    Processing by ProductsController#update as JSON
      Parameters: {"product"=>{"price"=>"254"}, "id"=>"1"}
      Product Load (0.2ms)  SELECT "products".* FROM "products" WHERE "products"."id" = 1 LIMIT 1
       (0.0ms)  begin transaction
      Product Exists (0.2ms)  SELECT 1 AS one FROM "products" WHERE ("products"."name" = 'HD Electric Amplifier' AND "products"."id" != 1) LIMIT 1
       (0.3ms)  UPDATE "products" SET "price" = 254, "updated_at" = '2012-07-09 01:19:01.118057' WHERE "products"."id" = 1
       (1.0ms)  commit transaction
    Completed 200 OK in 5ms (Views: 0.4ms | ActiveRecord: 1.7ms)

If you refresh the page, you'll see the price has changed. Awesome! We're most of the way there, now we just need to update the value without a page refresh. The object returned by `ajax()` has a method called `success()` that allows us to set a callback for when the request completes successfully:


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        url   = $(this).attr('href');
        price = $(this).attr('data-price');
        newPrice = parseInt(price) + 1;

        console.log(location.protocol + "//" + location.host + url);
        $.ajax({ url:   url, 
                 type: 'put',
                 dataType: 'json',
                 data: { product: {price: newPrice} }
               }).success(function(data, textStatus, jqXHR) { 
                  console.log('done');
          });
        })
    </script>


Here we add the `success()` method and we can verify it works with a `console.log()`. Once you've verified it does what we think it will, we can use the return data from our ProductsController#update action. Since we're rendering our product as JSON:

          format.json { render json: @product }

We can use the result directly:


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        url   = $(this).attr('href');
        price = $(this).attr('data-price');
        newPrice = parseInt(price) + 1;

        console.log(location.protocol + "//" + location.host + url);
        $.ajax({ url:   url, 
                 type: 'put',
                 dataType: 'json',
                 data: { product: {price: newPrice} }
               }).success(function(data, textStatus, jqXHR) { 
                console.log(data);
                console.log('id is:' + data.id);
                console.log('price is:' + data.price);
          });
        })
    </script>


Verify the contents of the data object and then we'll finally get around to updating our view. First we'll grab the product price that we set with a data attribute by doing this `$('[data-product='+ data.id +']')` which will grab a reference to our `<td>` that holds our price. Next we can change the contents of it's html contents using the `html()` function and passing in `"$" + data.price`. When we put it all together it looks like this:


    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        url   = $(this).attr('href');
        price = $(this).attr('data-price');
        newPrice = parseInt(price) + 1;

        $.ajax({ url:   url, 
                 type: 'put',
                 dataType: 'json',
                 data: { product: {price: newPrice} }
               }).success(function(data, textStatus, jqXHR) { 
                $('[data-product='+ data.id +']').html("$" + data.price);
          });
        })
    </script>


We're almost done, promise. Do the save, refresh, & click dance. You should see the value in our row change!! That's awesome you just updated a value in the database without having to refresh your page! Click the same `+` link again, and ... disappointment, nothing happens...why is that? We updated the value we're showing but not the value of `data-price` in our link. So we can use the same trick to select our link via data attribute `$('[data-incr-price='+ data.id +']')` and then if you pass two values to `attr()` it will set the value. Since we want to set the `data-price` attribute we can do it with this code `$('[data-incr-price='+ data.id +']').attr('data-price', data.price);`. All together it looks like this:



    <script type='text/javascript'>
      $('[data-incr-price]').on('click', function(e){
        e.preventDefault();
        e.stopPropagation();

        url   = $(this).attr('href');
        price = $(this).attr('data-price');
        newPrice = parseInt(price) + 1;

        $.ajax({ url:   url, 
                 type: 'put',
                 dataType: 'json',
                 data: { product: {price: newPrice} }
               }).success(function(data, textStatus, jqXHR) { 
                $('[data-product='+ data.id +']').html("$" + data.price);
                $('[data-incr-price='+ data.id +']').attr('data-price', data.price);   
          });
        })
    </script>


Refresh for the last time and click the link. Now click it again. Did the price go up? Awesome! You're one step closer to asynchronous web domination. There are many ways different ways to accomplish this javascript request we just made, but the thought process should be the same. Click an element, intercept the click event, grab data from our DOM and make an asyncronous request. Make sure your URL, HTTP verb, and dataType are all set. Supply any data you want to, and finally attach some kind of success handler to the result. It seems a bit verbose, and it is...there are some simpler ways to accomplish this flow, but they just hide details from you...they're not actually simpler under the hood. 



## Fin

To wrap it up, we got our hands dirty with jQuery and we got to manipulate the DOM. We played with the javascript console and learned quite a bit about this new strange language. We passed data from Ruby using ERB to javascript to make our chart visualization, and then we used javascript to make asynchronous requests to our Ruby server. THe most important parts of this exercise are understaning the core pieces of technology, and taking a very slow iterative approach to development. When I'm building javascript powered features, I typically build them without the javascript first (if possible), and then enhance them with javascript afterwards. This makes debugging a bit easier and gives you a working prototype while you're still developing the advanced version. 



## 

