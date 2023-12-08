require 'rails_helper'

RSpec.describe Users::FindOrCreate, type: :service do
  let(:phone) { '1234567890' }

  subject { described_class.run(phone: phone) }

  context 'when the user does not exist' do
    it 'creates a new user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'returns the user' do
      expect(subject.value).to be_a(User)
    end

    it 'sets the user phone number' do
      expect(subject.value.phone).to eq(phone)
    end
  end

  context 'when the user exists' do
    let!(:user) { create(:user, phone: phone) }

    it 'does not create a new user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'returns the user' do
      expect(subject.value).to eq(user)
    end
  end

  context 'when the phone number is not normalized' do
    let(:phone) { '+1 (234) 567-890' }

    it 'creates a new user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'returns the user' do
      expect(subject.value).to be_a(User)
    end

    it 'normalizes the phone number' do
      expect(subject.value.phone).to eq('1234567890')
    end
  end
end
