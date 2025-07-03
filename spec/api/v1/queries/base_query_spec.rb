# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Queries::BaseQuery do
  subject(:query) { custom_query.new(scope, params).call }

  let!(:custom_query) do
    Class.new(described_class) do
      filter_by :id, only: %i[eq neq gt gte lt lte]
      filter_by :name, only: %i[eq]
      filter_by :created_at, only: %i[eq neq gt lt gte lte]
      filter_by :updated_at, only: %i[eq neq gt lt gte lte]

      sort_by :id
      sort_by :name
      sort_by :created_at
      sort_by :updated_at
    end
  end

  # mocking model
  before do
    ActiveRecord::Base.logger = nil
    ActiveRecord::Schema.define do
      create_table :dummy_models, force: true do |t|
        t.string :name
        t.integer :age

        t.timestamps
      end
    end

    stub_const('DummyModel', Class.new(ApplicationRecord))

    20.times { DummyModel.create(name: Faker::Name.name, age: Faker::Number.between(from: 1, to: 100)) }
  end

  after do
    ActiveRecord::Base.connection.drop_table(:dummy_models)
  end

  describe 'pagination' do
    let(:scope) { DummyModel.all }
    let(:params) { ActionController::Parameters.new(page: 1, limit: 10) }

    context 'with valid params' do
      context 'when page and limit are not provided' do
        it 'returns paginated records' do
          expect(query.second.size).to eq(params[:limit])
        end
      end

      context 'when page and limit are provided' do
        let(:params) { ActionController::Parameters.new(page: 1, limit: 2) }

        it 'returns paginated records' do
          expect(query.second.size).to eq(params[:limit])
        end

        it 'returns pagy object' do
          expect(query.first).to be_a(Pagy)
        end

        it 'returns correct count' do
          expect(query.first.count).to eq(DummyModel.count)
        end

        it 'returns correct pages' do
          expect(query.first.pages).to eq(DummyModel.count / params[:limit])
        end
      end
    end

    context 'with invalid params' do
      context 'when page and limit are provided and limit is not an integer' do
        let(:params) { ActionController::Parameters.new(page: 1, limit: 'invalid') }

        it 'returns paginated records' do
          expect(query.second.size).to eq(described_class::DEFAULT_PER_PAGE)
        end
      end

      context 'when page and limit are provided and limit is greater than max per page' do
        let(:params) { ActionController::Parameters.new(page: 1, limit: 101) }

        it 'returns paginated records' do
          expect(query.second.size).to eq(described_class::DEFAULT_PER_PAGE)
        end
      end

      context 'when limit is less than 0' do
        let(:params) { ActionController::Parameters.new(page: 1, limit: -1) }

        it 'returns paginated records' do
          expect(query.second.size).to eq(described_class::DEFAULT_PER_PAGE)
        end
      end

      context 'when page is less than 0' do
        let(:params) { ActionController::Parameters.new(page: -1, limit: 1) }

        it 'returns paginated records' do
          expect(query.second.size).to eq(params[:limit])
        end
      end

      context 'when params is not hash' do
        let(:params) { 'invalid' }

        it 'returns paginated records' do
          expect { query }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe 'filtering' do
    let(:scope) { DummyModel.all }
    let(:params) { ActionController::Parameters.new }

    context 'with valid params' do
      context 'when filtering by id' do
        let(:params) { ActionController::Parameters.new(filter: { id: { eq: 1 } }) }

        it 'returns filtered records' do
          expect(query.second.first.id).to eq(1)
        end

        it 'returns correct count' do
          expect(query.first.count).to eq(1)
        end

        it 'returns correct pages' do
          expect(query.first.pages).to eq(1)
        end
      end

      context 'when filtering by name' do
        let(:params) { ActionController::Parameters.new(filter: { name: { eq: name } }) }

        let(:name) { DummyModel.first.name }

        it 'returns filtered records' do
          expect(query.second.first.name).to eq(name)
        end
      end

      context 'when providing multiple filters' do
        let(:params) { ActionController::Parameters.new(filter: { id: { eq: 1 }, name: { eq: name } }) }

        let(:name) { DummyModel.first.name }

        it 'returns data with filter applied' do
          expect(query.second.first.name).to eq(name)
        end
      end

      context 'when filtering by created_at' do
        let(:params) { ActionController::Parameters.new(filter: { created_at: { gt: created_at } }) }

        let(:created_at) { DummyModel.second.created_at }

        it 'returns filtered records' do
          expect(query.second.pluck(:created_at)).not_to include(created_at)
        end
      end

      context 'when action is lt' do
        let(:params) { ActionController::Parameters.new(filter: { id: { lt: id } }) }

        let(:id) { DummyModel.second.id }

        it 'returns filtered records' do
          expect(query.second.pluck(:id)).not_to include(id)
        end
      end

      context 'when action is lte' do
        let(:params) { ActionController::Parameters.new(filter: { id: { lte: id } }) }

        let(:id) { DummyModel.last.id }

        it 'returns filtered records' do
          expect(query.second.pluck(:id)).to include(id)
        end
      end

      context 'when filtering with eq by date' do
        let(:params) { ActionController::Parameters.new(filter: { created_at: { eq: created_at } }) }

        let(:created_at) { DummyModel.second.created_at }

        it 'returns filtered records' do
          expect(query.second.pluck(:created_at)).to include(created_at)
        end
      end
    end

    context 'with invalid params' do
      context 'when filtering by invalid field' do
        let(:params) { ActionController::Parameters.new(filter: { invalid: { eq: 1 } }) }

        it 'raises error' do
          expect { query }.to raise_error(ArgumentError)
        end
      end

      context 'when filtering by invalid operator' do
        let(:params) { ActionController::Parameters.new(filter: { id: { invalid: 1 } }) }

        it 'raises error' do
          expect { query }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe 'sorting' do
    let(:scope) { DummyModel.all }
    let(:params) { ActionController::Parameters.new }

    context 'with valid params' do
      context 'when sorting by id' do
        let(:params) { ActionController::Parameters.new(sort: 'id') }

        it 'returns sorted records' do
          expect(query.second.first.id).to be < query.second.second.id
        end
      end

      context 'when sorting by name with asc direction' do
        let(:params) { ActionController::Parameters.new(sort: 'name', direction: 'asc') }

        it 'returns first record with proper name' do
          expect(query.second.first.name).to eq(DummyModel.order(name: :asc).first.name)
        end
      end

      context 'when sorting by name with desc direction' do
        let(:params) { ActionController::Parameters.new(sort: 'name', direction: 'desc') }

        it 'returns last record with proper name' do
          expect(query.second.last.name).to eq(DummyModel.order(name: :desc).last.name)
        end
      end
    end

    context 'with invalid params' do
      context 'when sorting by invalid field' do
        let(:params) { ActionController::Parameters.new(sort: 'invalid') }

        it 'returns sorted records by default' do
          expect(query.second.first.created_at).to eq(DummyModel.order(created_at: :asc).first.created_at)
        end
      end

      context 'when sorting by invalid direction' do
        let(:params) { ActionController::Parameters.new(sort: 'id', direction: 'invalid') }

        it 'returns sorted records by default' do
          expect(query.second.first.id).to eq(1)
        end
      end

      context 'when direction is not provided' do
        let(:params) { ActionController::Parameters.new(sort: 'id') }

        it 'returns sorted records by default' do
          expect(query.second.first.id).to eq(1)
        end
      end
    end
  end
end
