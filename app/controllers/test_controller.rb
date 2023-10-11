class TestController < ApplicationController
  def heehaw
    render json: { message: 'Heehaw' }
  end
end
