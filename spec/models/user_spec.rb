require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires a phone number' do
      user = User.new

      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include("can't be blank")
    end

    it 'requires a numeric phone number' do
      user = User.new(phone: 'abc')

      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include('is not a number')
    end

    it 'accepts a numeric phone number' do
      user = User.new(phone: '1234567890')

      expect(user).to be_valid
    end
  end
end
