# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Queries::MessagesQuery do
  describe '.filter_definition' do
    it 'includes allowed filters for id' do
      expect(described_class.filters_definition['id']).to match_array(%w[eq neq gt gte lt lte])
    end

    it 'includes allowed filters for content' do
      expect(described_class.filters_definition['content']).to match_array(%w[eq])
    end

    it 'includes allowed filters for created_at' do
      expect(described_class.filters_definition['created_at']).to match_array(%w[eq neq gt lt gte lte])
    end
  end
end
