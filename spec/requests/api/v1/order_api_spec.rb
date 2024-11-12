require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/restaurants/:restaurant_code/orders' do
    before(:each) do
      @restaurant = create_restaurant()
      dish = create_dish(restaurant: @restaurant)
      first_order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      first_order.add_order_item(dish: dish, portion: dish.portions.first)
      first_order.save
      second_order = @restaurant.orders.new(customer_name: 'Mary Jane', customer_email: 'mary@jane.com')
      second_order.add_order_item(dish: dish, portion: dish.portions.first)
      second_order.save
    end

    it 'success' do
      get "/api/v1/restaurants/#{@restaurant.code}/orders"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 2
      expect(json_response[0]["customer_name"]).to eq 'Mary Jane'
      expect(json_response[1]["customer_name"]).to eq 'John Doe'
    end

    it 'success with status' do
      get "/api/v1/restaurants/#{@restaurant.code}/orders?status=awaiting_confirmation"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 2
      expect(json_response[0]["customer_name"]).to eq 'Mary Jane'
      expect(json_response[1]["customer_name"]).to eq 'John Doe'
    end

    it 'fail with invalid status' do
      get "/api/v1/restaurants/#{@restaurant.code}/orders?status=invalid_status"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Status inválido'
    end

    it 'fail with invalid restaurant code' do
      get "/api/v1/restaurants/invalid_code/orders"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/restaurants/#{@restaurant.code}/orders"

      expect(response.status).to eq 500
    end
  end

  context 'GET /api/v1/restaurants/:restaurant_code/orders/:code' do
    before(:each) do
      @restaurant = create_restaurant()
      dish = create_dish(restaurant: @restaurant)
      drink = create_drink(restaurant: @restaurant)
      @first_order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      @first_order.add_order_item(dish: dish, portion: dish.portions.first)
      @first_order.add_order_item(drink: drink, portion: drink.portions.first)
      @first_order.save
    end

    it 'success' do
      get "/api/v1/restaurants/#{@restaurant.code}/orders/#{@first_order.code}"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response["customer_name"]).to eq 'John Doe'
      expect(json_response["status"]).to eq 'awaiting_confirmation'
      expect(json_response["total_price"]).to eq '30.0'
      expect(json_response["order_items"].length).to eq 2
      expect(json_response["order_items"][0]["price"]).to eq "25.0"
      expect(json_response["order_items"][1]["price"]).to eq "5.0"
    end

    it 'fail with invalid restaurant code' do
      get "/api/v1/restaurants/invalid_code/orders/#{@first_order.code}"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with invalid order code' do
      get "/api/v1/restaurants/#{@restaurant.code}/orders/invalid_code"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get "/api/v1/restaurants/#{@restaurant.code}/orders"

      expect(response.status).to eq 500
    end
  end
end