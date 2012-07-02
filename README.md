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


## 1) Move SQL to the Controller

Open the project in your favorite text editor like [Sublime Text](http://www.sublimetext.com/), take a look at the `app/views/products/index.html.erb` this is the page where we  display all of our products. You might also want to open a web browser [http://localhost:3000/products](http://localhost:3000/products). As i'm developing i usually have a browser open with the site i'm working on, my text editor open, and the console available so I can see the logs.


Views are a great place to get started coding, but they can quickly become a junk drawer for your code. If we pull out the database logic and put it a controller we will help to keep our views clean, and we can use the same data to build other view formats such as JSON.

Open up `app/views/products/index.html.erb` and remove this line:

    <% lots_of_products = Product.includes(:user).all %>

Now open up the `app/controllers/products_controller.rb` and modify the controller to look like this:

    class ProductsController < ApplicationController
      def index
        @products = Product.includes(:user).all
      end
    end

We then need to modify the view to use the new `@products` instance variable change this line:

    <% lots_of_products.each do |product| %>

to this line:

   <% @products.each do |product| %>

Refresh the `/products` page and it should work the same as before, but now we've got all of our SQL queries safely out of the view.

While we're modifying our view lets add the ability to get these products in JSON form. Open up the products_controller.rb again and add this into your index method:

    respond_to do |format|
      format.json {render :json => @products}
    end

Now when you visit [http://localhost:3000/products.json](http://localhost:3000/products.json) you will see your products in json form:


    [{"created_at":"2012-06-23T19:11:44Z","id":1,"name":"rails book","price":19,"updated_at":"2012-06-23T19:11:44Z","user_id":1},
     {"created_at":"2012-06-23T20:18:08Z","id":2,"name":"GPS HD Amplifier","price":681,"updated_at":"2012-06-23T20:18:08Z","user_id":2},
     {"created_at":"2012-06-23T20:18:08Z","id":3,"name":"Electric Filter","price":843,"updated_at":"2012-06-23T20:18:08Z","user_id":2},
     {"created_at":"2012-06-23T20:18:08Z","id":4,"name":"Performance Case","price":651,"updated_at":"2012-06-23T20:18:08Z","user_id":2},
     {"created_at":"2012-06-23T20:18:08Z","id":5,"name":"Video Tag Adapter","price":616,"updated_at":"2012-06-23T20:18:08Z","user_id":4},
     {"created_at":"2012-06-23T20:18:08Z","id":7,"name":"Video Bridge","price":352,"updated_at":"2012-06-23T20:18:08Z","user_id":4},
     {"created_at":"2012-06-23T20:18:08Z","id":8,"name":"Side Gel Controller","price":929,"updated_at":"2012-06-23T20:18:08Z","user_id":4},
     {"created_at":"2012-06-23T20:18:08Z","id":9,"name":"Tag Mount","price":854,"updated_at":"2012-06-23T20:18:08Z","user_id":5},
      ... ]

JSON can easily be understood by computers and is how most modern web API's are built. Popular mobile applications like Instagram or Twitter use server backed JSON API's to send data to servers for storage later, and can get data such as a list of tweets in JSON form.

Next we'll move the active record queries from our `app/views/products/create.html.erb`. Open the file and remove these lines:


    <%= params[:product].inspect %>

    <% product = Product.new(params[:product]) %>
    <%= product.save %>
    <%= product.inspect  %>

    <br />
    <% product.errors.inspect %>

    <% if product.save %>
      <h2> Congrats You Created a New Product</h2>
      Your product looks like <%= product.inspect %>
    <% else %>
      <h2>Your product was not saved!! </h2>
      <%= product.errors.full_messages %>
      Please go back in your browser and fix the problem
    <% end %>

Replace it with the html:


    <h2>Product Created Successfully<h2>

    <%= @product.name %> added to the website, it costs: $<%= @product.price %>

Now open up the `products_controller.rb` and add the `create` method with this logic in it.


    def create
      @product = Product.new(params[:product])

      respond_to do |format|
        if @product.save
          format.html { render :action => "create" }
          format.json { render :json => @product }
        else
          format.html { render :action => "new" }
          format.json { render :json => @product.errors, :status => :unprocessable_entity }
        end
      end
    end

You'll notice that the logic looks very similar, we're creating a product out of the values we got from the `params` hash. We then try to save the product by calling `@product.save`. If the product object passes all validations and saves to the database successfully then we will render the create view. Othewise we want to re-render the product form, and give our users the ability to re-enter data.


Lets go ahead and try to use our create action using the code in the controller rather than the view. Open up [http://localhost:3000/products/new](http://localhost:3000/products/new), then enter in the name and price of a product.
Like "Sneakers" for $40. You should see the success message we left in create.html.erb. If you open up the log you will see the create action being called and a successful insertion into the database:

    Started POST "/products" for 127.0.0.1 at 2012-07-01 10:47:47 -0700
    Processing by ProductsController#create as HTML
      Parameters: {"product"=>{"name"=>"sneakersz", "price"=>"40"}}
    WARNING: Can't verify CSRF token authenticity
       (0.1ms)  begin transaction
      Product Exists (0.3ms)  SELECT 1 AS one FROM "products" WHERE "products"."name" = 'sneakersz' LIMIT 1
      SQL (0.4ms)  INSERT INTO "products" ("created_at", "name", "price", "updated_at", "user_id") VALUES (?, ?, ?, ?, ?)  [["created_at", Sun, 01 Jul 2012 17:47:47 UTC +00:00], ["name", "sneakersz"], ["price", 40], ["updated_at", Sun, 01 Jul 2012 17:47:47 UTC +00:00], ["user_id", nil]]
       (0.8ms)  commit transaction
      Rendered products/create.html.erb within layouts/application (0.0ms)
    Completed 200 OK in 15ms (Views: 9.9ms | ActiveRecord: 1.6ms)

If you got an error, try to use the error messages to debug the problem.


Go ahead and go back to [http://localhost:3000/products/new](http://localhost:3000/products/new). Enter in the name of a product that already exists, like "sneakers" and submit. You should be sent back to the form where we entered in the name and price for our product. This is because if `@product.save` does not return true in our controller we render the `new` action which has the form for our product. This is much more useful than simply saying the product didn't save like we did before, but we're leaving our user in the dark. Right now they don't know if that worked or not, and they don't know which fields didn't validate correctly. Even worse they lost everything they typed in to the form. This is a bad user experience for sure. Lets update this form to use Rails form helpers and give our users a usability boost in the next section.

Save and commit the results to GIT.


## 2) Rails Form Helpers


We'll start out by adding a `new` action to our products controller. Open up `app/controllers/products_controller.rb` and add this code:

  def new
    @product = Product.new
  end

Here we're adding an instance variable `@product` and assigning it to a new product instance. This new product instance hasn't been saved to our database and doesn't have any name or price associated with it. We will use it while building our form. Now open up the view `app/views/products/new.html.erb` and remove the form and we will replace it with with rails form helper:


    <%= form_for(@product) do |f| %>
      <div class="field">
        <%= f.label :name %><br />
        <%= f.text_field :name %>
      </div>
      <div class="field">
        <%= f.label :price %><br />
        <%= f.text_field :price %>
      </div>
      <div class="actions">
        <%= f.submit %>
      </div>
    <% end %>

Go ahead and refresh the page, you can view source on the html or use an html inspector (right click and go to inspect html in chrome and safari), from here you will see that the html that Rails generates is nearly identical to the form html we had before. Go ahead and try to create another duplicate product name such as "sneakers" and hit enter. The form submits to the products controller create action, but since our product does not save we decide to re-render our form (you can check the logs to verify this behavior in your app). Once the page renders, you should see something different from last time when we used the plain form. Now the `Name` is highlighted in red and the `name` field has a red border. You might also notice that you didn't lose the name and price you entered in, how does this work? To see we'll dig into this form a little bit.


Looking at the form in `app/views/products/new.html.erb` we have the code wrapped in a form builder that we use called `form_for`:


    <%= form_for(@product) do |f| %>
      #...
    <% end %>

Into this form builder we are passing an instance variable `@product` that we created in our products controller. When we go to [http://localhost:3000/products/new](http://localhost:3000/products/new) the form fields are empty, because `@product.name` will be blank, and `@product.price` will be blank. Lets try to change that. Open up the `products_controller.rb` and modify the new action so that our `@product` has a name (even if it isn't saved to the database yet).

    def new
      @product = Product.new(:name => 'sneakers')
    end

Now refresh the page and you will see that the `name` field is pre populated with whatever name you entered into the `Product.new` in the controller. Go ahead and try changing the name and refreshing the page, you should see whatever you enter in our `products_controller.rb`. The same goes for price, add a price:

    def new
      @product = Product.new(:name => 'sneakers', :price => 10)
    end

When you refresh the price changes to 10 in our form. This is because rails is doing a little magic with our form. We are passing our `@product` into our `form_for` helper, so Rails knows the form is related to this unsaved product. It then goes on to see that we have a `text_field` for our name value:

    <%= f.label :name %><br />
    <%= f.text_field :name %>

Since Rails knows our form is for our `@product` wich has a `@product.name` method, it can assume (correctly so) that the value of `@product.name` and that field are related. This is why whenever you enter a 'name' into the controller like `@product = Product.new(:name => 'sneakers')` it shows up in the field. But what about when we submit our form? How does rails know the values we submitted. Take a look into the `products_controller.rb` file, the create action. (Note i use 'action' and 'method' interchangeably when refering to ruby objects, they are the same thing). Here we are creating a `@product` by passing our parameters hash into `Product.new`

    def create
      @product = Product.new(params[:product])
      # ...

So if we enter in a wrong value in our form and `@product.save` is false when we submit to this create action then we will render our `new` view which holds the rails view helper.


    def create
    # ...
      if @product.save
        format.html { render :action => "create"}
        format.json { render :json => @product }
      else
        format.html { render :action => "new"}
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end

Since our `new` action has our form with our form helper `form_for(@product)` and in this case `@product` is already populated with the values we entered in our form, Rails is smart enough to show them to us in the correct fields.

It's great that rails does this logic for us and even highlights our fields with errors for us, but our user still doesn't know _why_ their product didn't get saved, lets add some text showing them the errors. Open up the `app/views/products/new.html.erb` file and add this to the top:

    <% if @product.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(@product.errors.count, "error") %> prohibited this user from being saved:</h2>

        <ul>
        <% @product.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    <% end %>

Go ahead and submit the form again with a duplicate name, now you should see a big error box with the text `Name has already been taken`. This was accomplished since we have a validation on our `Product` in `app/models/product.rb` that says all names must be unique:

  validates :name, :uniqueness => true

So a products name isn't unique when we try calling `@product.save` in our Products#create action (products_controller.rb, create action) then error will be added to our `@product` object. We can get to these errors by accessing `@product.errors`. So if errors exist on our `@product` then we will show the `@product.errors.full_messages` which is an array of error messages. We also used the rails helper `pluralize` so if we have more than one error `@product.errors.count` then we will pluralize the word 'error'.

    <%= pluralize(@product.errors.count, "error") %>

All of this comes together to make an easy to use interface for users. Change the products controller index action back to the original format so our new product form doesn't populate with any values.

  def new
    @product = Product.new
  end

Save and commit the results to GIT.


## 3) Using partials and Routes Resources


So we've got a pretty good interface for viewing all of our products and we've got a way to make new products with some pretty good user interaction for handling errors and validations. Out of our CRUD operations we've covered Create and Read. What about the Update and Delete? We'll build those in just a minute but first, partials!

A partial in Rails is a re-useable view piece that can be used by multiple different views. Partials end in `.html.erb` but begin with an underscore `_`. Lets go to the `app/views/products/` folder and make a new partial called `_form.html.erb`. We'll move all of the shared components of our view into this partial so we can re-use them later. Take the form and the error messages out of of `app/views/products/new.html.erb` and put them into `app/views/products/_form.html.erb`


    <%= form_for(@product) do |f| %>
      <div class="field">
        <%= f.label :name %><br />
        <%= f.text_field :name %>
      </div>
      <div class="field">
        <%= f.label :price %><br />
        <%= f.text_field :price %>
      </div>
      <div class="actions">
        <%= f.submit %>
      </div>
    <% end %>



    <% if @product.errors.any? %>
      <div id="error_explanation">
        <h2><%= pluralize(@product.errors.count, "error") %> prohibited this user from being saved:</h2>

        <ul>
        <% @product.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
        </ul>
      </div>
    <% end %>

Then you will need to render this partial from your `new.html.erb` view. Open up `app/views/products/new.html.erb` and add this line:

    <%= render :partial => 'form' %>

Since we are already in the products view it understands to look in for `products/_form.html.erb`. Or we can manualy specify the location by using:

    <%= render :partial => 'products/form' %>

Refresh the page [http://localhost:3000/products/new](http://localhost:3000/products/new) and it should look the same, but now we have our form in a re-useable partial. We will use this partial in the edit view in just a bit but first we will replace our routes with a resource helper.

Right now our `config/routes.rb` has routes for products that look like this:

    get '/products' => 'products#index'

We will delete all of these custom routes, and instead use resources. Remove any route lines that contain '/products' and add this:


    resources :products

This is the rails prefered way to define those routes. It means that you want to use the Rails standard's when it comes to accessing urls. Rails creates all the routes we need for our CRUD operations. In the terminal if you run


    $ rake routes

You will see that we have our original paths and more:


        products GET    /products(.:format)          products#index
                 POST   /products(.:format)          products#create
     new_product GET    /products/new(.:format)      products#new
    edit_product GET    /products/:id/edit(.:format) products#edit
         product GET    /products/:id(.:format)      products#show
                 PUT    /products/:id(.:format)      products#update
                 DELETE /products/:id(.:format)      products#destroy


In the output of `rake routes` we get all the information we need about a route, let's look at the first one

        products GET    /products(.:format)          products#index

On the left side we have `products` this referst to the url helper that rails gives us. We can use `products_path` and `products_url` in our rails app to get to this route.

The next element is `GET` which designates that this route is reachable via GET request.

The next element is the url `/products(.:format)` with optional format. This means when we are viewing a path of `http://localhost:3000/products` with a GET request we are referring to this route.

The final element is `products#index` which is short hand for the products controller & index action.

Now that we have all of these routes, let's finish our Update and Delete actions.

Right now we've built a vew to list all products in our possession, on the index page, but we don't have a way to view just a single product. We'll make a quick show view. Create a file called show.html.erb at `app/views/products/show.html.erb`. Then add this to it:

    <p>
      <b>Name:</b>
      <%= @product.name %>
    </p>

    <p>
      <b>Price:</b>
      <%= @product.price %>
    </p>

Then we populate the `@product` in our product controller `show` view:

    def show
      @product = Product.where(:id => params[:id]).first
    end

Now you can view an individual product using it's primary key (id). For insance if you wanted to see the product with an ID of 3 you could go to [http://localhost:3000/products/3](http://localhost:3000/products/3). This isn't that useful with such a simple model, but you can imagine if we had 30 attributes in addition to `:name` and `:price` then having a detailed show view would come in very handy. Now that we can create and view an individual object lets edit an existing one:

First we will be making an edit view. The edit view is what you see before you update a product. Make a new file `/app/views/products/edit.html.erb` and add these lines:


    <h1>Editing Product</h1>

    <%= render 'form' %>

    <%= link_to 'Back', products_path %>

Here we are rendering the same `_form` partial we used in the new view. To use this properly we need a `@product` instance variable populated via the controller. Unlike the `new` action, we want to edit a specific product. So we will have to look up that product from the database. Open up `app/views/controllers/products_controller.rb` and add an edit action:


    def edit
      @product = Product.where(:id => params[:id]).first
    end

With these two pieces together we can open up a browser and almost edit a product. If we wanted to edit the first product in our database (product with id of 1) then we would visit [http://localhost:3000/products/1/edit](http://localhost:3000/products/1/edit). Compare this url to the routes output above, can you confirm that this url routes to the `products#edit` controller action?

When the page loads you'll see the name and price populated since we have `@product.name` and `@product.price` populated via our `Product.where` SQL query. If you look really close, the button is even different, it says "Update Product". If you open [http://localhost:3000/products/new](http://localhost:3000/products/new) in a different tab, you'll see that the button says "Create Product". Both are using the same `_form.html.erb` partial, so how does rails know what our intent is?

The magic comes from the first line in our `_form.html.erb`


    <%= form_for(@product) do |f| %>


Rails can look at `@product` and if it has been saved to the database (if `@product.persisted?` is true) then Rails knows you aren't creating a new product but rather updating the existing product. Likewise if `@product` had not been saved to the database yet (`@product = Product.new`) then Rails would know that we need to create a product. Rails also changes the HTTP method and URL, you can view source on the forms in the two different pages if you don't believe me. This is how we can use the same form for new and edit actions.

Now that we've got an edit view, if you submit changes to your product you will get an error.


    The action 'update' could not be found for ProductsController

When we submit our form on `edit` it will hit our `update` action on ProductsController which we haven't implemented yet. Open up ProductsController and add this in:

      def update
        @product = Product.where(:id => params[:id]).first

        respond_to do |format|
          if @product.update_attributes(params[:product])
            format.html { redirect_to @product, :notice => 'Product was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @product.errors, :status => :unprocessable_entity }
          end
        end
      end


Here we look up a product with a given id from `params[:id]` then we update all of the attributes by calling `@product.update_attributes(params[:product])`. Since `params[:product]` will be a hash that looks like:


    {:name => 'sneakers', :price => 10}

We can pass it directly into our update_attributes method and it will attempt to change the `:name` and `:price` of our `@product`. If that is successful we will redirect_to the `@product` otherwise we will show the edit action again. This follows a similar pattern to when we were creating products with the new view and the create action. There are two things here we haven't seen before, the `redirect_to @product` and `:notice => 'User was successfully updated.'` Lets take a look at each of them.

Lets look at the first one, `redirect_to @product`. Remember when we used our `form_for(@product)` and Rails was smart enough to figure out that we wanted an update form for a `@product` that was already in the database, and a create form for an `@product` that was brand new. In a similar way `redirect_to` is smart enough to know that when we are redirecting to a `@product` that has been saved to the database, we likely want to show that product. So all together `redirect_to @product` will send our user to the `app/views/products/show.html.erb` view when the update is successful. We could do the same thing by manually building our url `redirect_to "/products/#{@product.id}" but hard coding your urls is considered bad form. (It makes it harder to change your app later on down the road).

The next part `:notice => 'User was successfully updated.'` is using something that rails calls "flash", essent
this is a tool to pass on one time messages to the users of your application. To show this to your users we'll have to add some code to our layout, add this to `app/views/layouts/application.html.erb` above the yield:


    <% if flash[:notice].present? %>
      <p class="flash-notice"><%= flash[:notice] %></p>
    <% end %>

Inside of our controller we can have other types of flash messages by using the `flash` object. For instance, you might set `flash[:error] = 'Please try again'` in the controller but you would still need to add the view logic to your layout. Flash messages are nice for a lightweight application but shouldn't be relied on too much. Also note that this type of inline :notice can only be used with redirects for now.


Go back to [http://localhost:3000/products/1/edit](http://localhost:3000/products/1/edit) change the price and then hit enter. You should end up on the Products#show page with the extra flash message of "Product was successfully updated.".

At this point and time we've got [C]reate [R]ead [U]pdate and need to implement the [D]elete. When you delete something you usually don't show it afterwards, so there is no need to make a 'destroy.html.erb'. Open up your Products controller and add this method:


    def destroy
      @product = Product.where(:id => params[:id]).first
      @product.destroy

      respond_to do |format|
        format.html { redirect_to products_url }
        format.json { head :no_content }
      end
    end


Since we don't need a view thats all we had to do. Now we can add a button to delete a product anywhere we want. Open up `app/views/products/show.html.erb` and add a delete button.

    <%= link_to 'Destroy', @product, :method => :delete, :data => { :confirm => 'Are you sure?' } %>

Like we saw with the `redirect_to @product`, `link_to` understands that if you are using a `@product` that has saved to the database, and the `:delete` HTTP method that you intend to link to the ProductsController and the destroy action. If you're fuzzy on how that makes sense, try taking a look at the output of rake routes. We could also hard code a url, but as I mentioned that makes things a bit messier to change in the future.

In addition to specifying the method, we're also telling our link_to to show the user a confirmation popup to ensure that they didn't click the destroy button by accident.

Go ahead and navigate to a product page like [http://localhost:3000/products/23](http://localhost:3000/products/23) and click the destroy link. You should be redirected to the products index page. To verify that product no longer exists, you can go to the same url [http://localhost:3000/products/23](http://localhost:3000/products/23) and you should get an error since it no longer exists.


Save and commit the results to GIT.


## Fin

Congrats, you've successfully made a way to Create Read Update & Delete a product on our system. You wrote all the code for the MVCr all by hand, and should have a much better understanding of how different rails components interact with each other to provide these basic data operations.

If you take a look at the code in the users_controller.rb  you should be able to understand most of what is going on. If not, make a note and we can talk about it in class. You should also be able to look through the views in `app/views/users` and understand most of what is going on as well.

At this point we've covered the foundation of using Rails, from designing a database table, querying that table with a Model building Views with erb, controlling what views we see with Controllers and using Routes to map that all to urls that every browser can understand. There is still plenty to learn, but you now have the building blocks in your hands to start building the next facebook or instagram. The rest is just details :)

