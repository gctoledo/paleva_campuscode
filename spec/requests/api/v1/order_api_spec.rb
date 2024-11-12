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
      get api_v1_restaurant_orders_path(@restaurant.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 2
      expect(json_response[0]["customer_name"]).to eq 'Mary Jane'
      expect(json_response[1]["customer_name"]).to eq 'John Doe'
    end

    it 'success with status' do
      get "#{api_v1_restaurant_orders_path(@restaurant.code)}?status=awaiting_confirmation"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 2
      expect(json_response[0]["customer_name"]).to eq 'Mary Jane'
      expect(json_response[1]["customer_name"]).to eq 'John Doe'
    end

    it 'fail with invalid status' do
      get "#{api_v1_restaurant_orders_path(@restaurant.code)}?status=invalid_status"

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Status inválido'
    end

    it 'fail with invalid restaurant code' do
      get api_v1_restaurant_orders_path('invalid_code')

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      get api_v1_restaurant_orders_path(@restaurant.code)

      expect(response.status).to eq 500
    end
  end

  context 'GET /api/v1/restaurants/:restaurant_code/orders/:code' do
    before(:each) do
      @restaurant = create_restaurant()
      dish = create_dish(restaurant: @restaurant)
      drink = create_drink(restaurant: @restaurant)
      @order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      @order.add_order_item(dish: dish, portion: dish.portions.first)
      @order.add_order_item(drink: drink, portion: drink.portions.first)
      @order.save
    end

    it 'success' do
      get api_v1_restaurant_order_path(@restaurant.code, @order.code)

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
      get api_v1_restaurant_order_path('invalid_code', @order.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with invalid order code' do
      get api_v1_restaurant_order_path(@restaurant.code, 'invalid_code')

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:includes).and_raise(ActiveRecord::ActiveRecordError)

      get api_v1_restaurant_order_path(@restaurant.code, @order.code)

      expect(response.status).to eq 500
    end
  end

  context 'PATCH /api/v1/restaurants/:restaurant_code/orders/:code/preparing' do
    before(:each) do
      @restaurant = create_restaurant()
      dish = create_dish(restaurant: @restaurant)
      @order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      @order.add_order_item(dish: dish, portion: dish.portions.first)
      @order.save
    end

    it 'success' do
      patch preparing_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      @order.reload
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(@order.status).to eq 'preparing'
      expect(json_response["message"]).to eq 'Status atualizado para "em preparação".'
    end

    it 'fail because order is not awaiting confirmation' do
      @order.delivered!
      patch preparing_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 409
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'O pedido não está aguardando confirmação.'
    end

    it 'fail with invalid restaurant code' do
      patch preparing_api_v1_restaurant_order_path('invalid_code', @order.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with invalid order code' do
      patch preparing_api_v1_restaurant_order_path(@restaurant.code, 'invalid_code')

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:find_by!).and_raise(ActiveRecord::ActiveRecordError)

      patch preparing_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      expect(response.status).to eq 500
    end
  end

  context 'PATCH /api/v1/restaurants/:restaurant_code/orders/:code/ready' do
    before(:each) do
      @restaurant = create_restaurant()
      dish = create_dish(restaurant: @restaurant)
      @order = @restaurant.orders.new(customer_name: 'John Doe', customer_email: 'john@doe.com')
      @order.add_order_item(dish: dish, portion: dish.portions.first)
      @order.status = "preparing"
      @order.save
    end

    it 'success' do
      patch ready_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      @order.reload
      json_response = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(@order.status).to eq 'ready'
      expect(json_response["message"]).to eq 'Status atualizado para "pronto".'
    end

    it 'fail because order is not preparing' do
      @order.delivered!
      patch ready_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 409
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'O pedido não estava em preparação.'
    end

    it 'fail with invalid restaurant code' do
      patch ready_api_v1_restaurant_order_path('invalid_code', @order.code)

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with invalid order code' do
      patch ready_api_v1_restaurant_order_path(@restaurant.code, 'invalid_code')

      json_response = JSON.parse(response.body)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(json_response["error"]).to eq 'Nenhum registro encontrado'
    end

    it 'fail with internal server error' do
      allow(Order).to receive(:find_by!).and_raise(ActiveRecord::ActiveRecordError)

      patch ready_api_v1_restaurant_order_path(@restaurant.code, @order.code)

      expect(response.status).to eq 500
    end
  end
end