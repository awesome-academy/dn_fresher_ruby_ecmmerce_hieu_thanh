require "rails_helper"
include SessionsHelper
require "shared/share_example_spec.rb"

RSpec.describe Admin::OrdersController, type: :controller do
  let (:admin) {FactoryBot.create :user, is_admin: 1}

  describe "when valid routing" do
    it {should route(:get, "/admin/orders").to(action: :index)}
    it {should route(:put, "/admin/orders/1").to(action: :update, id: 1)}
  end

  it_behaves_like "share check login admin"

  describe "admin is logged in" do
    before {log_in admin}

    describe "GET #index" do
      let(:user){FactoryBot.create :user}
      let!(:order1){FactoryBot.create :order, status: 0, user: user}
      let!(:order2){FactoryBot.create :order, status: 1}

      context "with not params" do
        it "return list order newest" do
          get :index
          expect(assigns(:orders)).to eq [order2, order1]
        end
      end

      # context "with params" do
      #   it "return list order with param status" do
      #     get :index, params: {status: 1}
      #     expect(assigns(:orders)).to eq [order2]
      #   end

      #   it "return list order with param customer" do
      #     get :index, params: {customer: "asd"}
      #     expect(assigns(:orders)).to eq []
      #   end
      # end
    end

    describe "PUT #update" do

    end
  end
end