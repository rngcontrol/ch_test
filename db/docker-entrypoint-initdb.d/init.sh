#!/bin/bash

#tar xvf /var/data/hits_v1.tar -C /var/lib/clickhouse
#tar xvf /var/data/visits_v1.tar -C /var/lib/clickhouse
#service clickhouse-server restart
#clickhouse-client --query "SELECT COUNT(*) FROM datasets.hits_v1"
#clickhouse-client --query "SELECT COUNT(*) FROM datasets.visits_v1"

#clickhouse-client --query "SHOW DATABASES"

tar xvf /var/data/2021_08_01_07_01_17_data.tgz -C /var/data

clickhouse-client --query "CREATE DATABASE IF NOT EXISTS menus"
clickhouse-client --query "CREATE TABLE menus.dish(id UInt32,name String,description String,menus_appeared UInt32,times_appeared Int32,first_appeared UInt16,last_appeared UInt16,lowest_price Decimal64(3),highest_price Decimal64(3)) ENGINE = MergeTree ORDER BY id;"
clickhouse-client --query "CREATE TABLE menus.menu (id UInt32,name String,sponsor String,event String,venue String,place String,physical_description String,occasion String,notes String,call_number String,keywords String,language String,date String,location String,location_type String,currency String,currency_symbol String,status String,page_count UInt16,dish_count UInt16) ENGINE = MergeTree ORDER BY id;"
clickhouse-client --query "CREATE TABLE menus.menu_page(id UInt32,menu_id UInt32,page_number UInt16,image_id String,full_height UInt16,full_width UInt16,uuid UUID) ENGINE = MergeTree ORDER BY id;"
clickhouse-client --query "CREATE TABLE menus.menu_item(id UInt32,menu_page_id UInt32,price Decimal64(3),high_price Decimal64(3),dish_id UInt32,created_at DateTime,updated_at DateTime,xpos Float64,ypos Float64) ENGINE = MergeTree ORDER BY id;"

clickhouse-client --format_csv_allow_single_quotes 0 --input_format_null_as_default 0 --query "INSERT INTO menus.dish FORMAT CSVWithNames" < /var/data/Dish.csv
clickhouse-client --format_csv_allow_single_quotes 0 --input_format_null_as_default 0 --query "INSERT INTO menus.menu FORMAT CSVWithNames" < /var/data/Menu.csv
clickhouse-client --format_csv_allow_single_quotes 0 --input_format_null_as_default 0 --query "INSERT INTO menus.menu_page FORMAT CSVWithNames" < /var/data/MenuPage.csv
clickhouse-client --format_csv_allow_single_quotes 0 --input_format_null_as_default 0 --date_time_input_format best_effort --query "INSERT INTO menus.menu_item FORMAT CSVWithNames" < /var/data/MenuItem.csv

clickhouse-client --query "CREATE TABLE menus.menu_item_denorm ENGINE = MergeTree ORDER BY (dish_name, created_at) AS SELECT price,high_price,created_at,updated_at,xpos,ypos,dish.id AS dish_id,dish.name AS dish_name,dish.description AS dish_description,dish.menus_appeared AS dish_menus_appeared,dish.times_appeared AS dish_times_appeared,dish.first_appeared AS dish_first_appeared,dish.last_appeared AS dish_last_appeared,dish.lowest_price AS dish_lowest_price,dish.highest_price AS dish_highest_price,menu.id AS menu_id,menu.name AS menu_name,menu.sponsor AS menu_sponsor,menu.event AS menu_event,menu.venue AS menu_venue,menu.place AS menu_place,menu.physical_description AS menu_physical_description,menu.occasion AS menu_occasion,menu.notes AS menu_notes,menu.call_number AS menu_call_number,menu.keywords AS menu_keywords,menu.language AS menu_language,menu.date AS menu_date,menu.location AS menu_location,menu.location_type AS menu_location_type,menu.currency AS menu_currency,menu.currency_symbol AS menu_currency_symbol,menu.status AS menu_status,menu.page_count AS menu_page_count,menu.dish_count AS menu_dish_count FROM menus.menu_item menu_item JOIN menus.dish dish ON menu_item.dish_id = dish.id JOIN menus.menu_page menu_page ON menu_item.menu_page_id = menu_page.id JOIN menus.menu menu ON menu_page.menu_id = menu.id;"

#clickhouse-client --query "SELECT count() FROM menus.menu_item_denorm;"
