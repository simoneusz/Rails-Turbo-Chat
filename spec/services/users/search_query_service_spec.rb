# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SearchQueryService do
  let!(:user) { create(:user, username: 'john_doe', email: 'john@example.com', first_name: 'John', last_name: 'Doe') }
  let!(:other_user) do
    create(:user, username: 'jane_doe', email: 'jane@example.com', first_name: 'Jane', last_name: 'Smith')
  end

  describe '#call' do
    context 'when search is empty' do
      subject(:service) { described_class.new({}).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'returns empty results' do
        expect(service.data[:results]).to eq([])
      end
    end

    context 'when searching by username with #' do
      subject(:service) { described_class.new(q: { search: '#john' }).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'includes matching user' do
        expect(service.data[:results]).to include(user)
      end

      it 'does not include non-matching user' do
        expect(service.data[:results]).not_to include(other_user)
      end
    end

    context 'when searching by email with @' do
      subject(:service) { described_class.new(q: { search: '@jane' }).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'includes matching user' do
        expect(service.data[:results]).to include(other_user)
      end

      it 'does not include non-matching user' do
        expect(service.data[:results]).not_to include(user)
      end
    end

    context 'when searching by first or last name with $' do
      subject(:service) { described_class.new(q: { search: '$Doe' }).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'includes matching user' do
        expect(service.data[:results]).to include(user)
      end

      it 'does not include non-matching user' do
        expect(service.data[:results]).not_to include(other_user)
      end
    end

    context 'when searching with general query' do
      subject(:service) { described_class.new(q: { search: 'Jane Smith' }).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'includes matching user' do
        expect(service.data[:results]).to include(other_user)
      end

      it 'does not include non-matching user' do
        expect(service.data[:results]).not_to include(user)
      end
    end

    context 'when query is just spaces' do
      subject(:service) { described_class.new(q: { search: '   ' }).call }

      it 'returns success' do
        expect(service).to be_success
      end

      it 'returns empty results' do
        expect(service.data[:results]).to eq([])
      end
    end
  end
end
