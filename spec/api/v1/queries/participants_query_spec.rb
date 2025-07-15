# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Queries::ParticipantsQuery do
  describe '.filter_definition' do
    it 'includes allowed filters for id' do
      expect(described_class.filters_definition['id']).to match_array(%w[eq neq gt gte lt lte])
    end

    it 'includes allowed filters for created_at' do
      expect(described_class.filters_definition['created_at']).to match_array(%w[eq neq gt lt gte lte])
    end

    it 'includes allowed filters for updated_at' do
      expect(described_class.filters_definition['updated_at']).to match_array(%w[eq neq gt lt gte lte])
    end

    it 'includes allowed filters for role' do
      expect(described_class.filters_definition['role']).to match_array(%w[eq neq])
    end
  end

  describe '.sort_definition' do
    it 'includes allowed sorts' do
      expect(described_class.sorts_definition.map do |array|
        array[0]
      end).to match_array(%w[id role created_at updated_at])
    end
  end
end
