namespace :seed do
  desc "Load countries + car brands into db"
  task load: %i[load_countries load_car_brands] do
    puts "all infrastructure data loaded"
  end

  desc "Load country data into db"
  task load_countries: :environment do
    load_data("countries.txt") do |data|
      Country.import(
        data.map { |country| { name: country } },
        validate: true,
        validate_uniqueness: true
      )
    end

    puts "countries loaded"
  end

  desc "Load car brands data into db"
  task load_car_brands: :environment do
    load_data("car-makes.txt") do |data|
      CarMake.import(
        data.map { |brand| { brand: brand } },
        validate: true,
        validate_uniqueness: true
      )
    end

    puts "car brands loaded"
  end

  def load_data(filename)
    File.open(Rails.root.join("lib/tasks/data/#{filename}")) do |file|
      data = file
             .readlines
             .map(&:chomp)
      yield data
    end
  end
end
