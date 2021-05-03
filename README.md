# Csbee app

## A. Description
Reactive Rails 6.1 app that allows users to upload a CSV file containing vehicles information

Reference CSV data (downloadable as a template from within import modal)

```
Name,Nationality,Email,Model,Year,ChassisNumber,Color,RegistrationDate,OdometerReading
Gemma,Kirke,gemma@kirke.me,Ford Focus,2018,123456789,Black,02/02/2018,30000
Jane Thomas,Australia,jane@thomas.me,Audi A4,2020,999999999,Green,02/01/2019,25000
Sam Johns,Belgium,sam@johns.me,BMW 4 Series,2017,111111111,White,05/01/2020,34000
Mehdi ,Elabd,mehdi@elabd.me,LEXUS IS 3000,2011,222222222,Black,02/01/2019,12300
Gemma,Kirke,gemma@kirke.me,INFINITI JX35,2011,444444444,Black,02/01/2019,12000
Jeni,Mohan,jeni@mohan.me,Audi A4,2018,555555555,White,05/04/2020,123000
Joseph,Sasank,joseph@sasank.me,Ford Focus,2020,888888888,Black,02/11/2019,34000
```

Notice that `Name` and `Nationality` columns can overlap -> handle that


## B. Main features...

1. Leverage Reactive Rails using Hotwire Turbo
2. Async offload of the import to background jobs so to not block the UI
3. Downloadable CSV reports and import template
3. List of customers-vehicles that is filterable

## C. ... so show it!

![Main list](https://raw.githubusercontent.com/FranckyU/csbee/main/public/Screenshot.png "Main list")

![Reports download](https://raw.githubusercontent.com/FranckyU/csbee/main/public/Screenshot2.png "Reports download")

![Modal](https://raw.githubusercontent.com/FranckyU/csbee/main/public/Screenshot3.png "Modal")

# Code

## A. Local installation

1. Use RVM or rbenv, have PostgreSQL running
2. clone this repository and `cd` into it
3. `bundle install`
4. `yarn`
5. `rails db:create` -> *might need you to configure database credentials*
6. `rails db:schema:load`
7. `rails data:migrate` **IMPORTANT!** to load Country and Car brands data
8. `rails s` to launch local server
9. Open another terminal and launch the background jobs queue with `bundle exec good_job start`
10. See the app at http://127.0.0.1:3000/

## B. Gems choice

I choose to use unfamiliar/new gems/libs in this project to see what's different from the regular way of libraries stacking

1. Hotwire
2. ViewComponent
3. StimulusJS
4. TailwindCSS
5. Heroicon instead of FontAwesome
6. Pagy instead of WillPaginate or Kaminari
7. Ransack for search
8. And last but not least `good_job` instead of `sidekiq` -> not Redis dependent on storing jobs queue anymore

## C. Test [WIP]

The test matrix will mainly cover the CSV import interaction:

1. Empty CSV should insert no data
2. Invalid vehicle or customer rows
3. Cross validation between customers fleet -> should not allow reassigning vehicles
4. Customer-Country automatic association
5. Vehicle-Model-Make automatic association
6. Already existing vehicles should not be duplicated -> should be able to reupload the same CSV over and over without effect

## C. Nice to have

Would have extended the app features towards:

1. `Push notification + alert + list refresh` when some new records are inserted in the background
2. CSV Import statistics along with possibility to re-upload failed rows, the actual schema is already ready for that but the UI not wired up.
2. Dockerized app
