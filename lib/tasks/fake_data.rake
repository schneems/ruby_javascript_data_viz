require 'ffaker'


namespace :fake do
  desc "adds fake data to your project"
  task :data => :environment do
    puts "========================================"
    puts "== Populating database with fake data =="
    puts "========================================"

    def create_user
      name      = Faker::Name.name
      job_title = Faker::Job.title
      puts "  - Creating User: #{name}: #{job_title}"
      User.create(:name => name, :job_title => job_title)
    end

    def create_product(user)
      name   = Faker::Product.product_name
      price  = rand(1000) + 1
      puts "    - Creating Product: #{name}: $#{price} sold by #{user.name}"
      user.products.create(:name => name, :price => price)
    end

    100.times do
      user = create_user
      rand(6).times do
        create_product(user)
      end
    end

    puts "========================================"
    puts "== Done Populating database ============"
    puts "========================================"
  end
end