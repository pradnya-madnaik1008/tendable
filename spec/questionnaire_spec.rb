require 'rspec'
require_relative '../questionnaire'

RSpec.describe 'Questionnaire' do
  let(:store) { PStore.new('test.pstore') }
  
  before do
    store.transaction do
      store[:answers] = []
      store[:scores] = []
    end
  end

  describe '#normalize_answer' do
    it 'returns true for Yes and Y' do
      expect(normalize_answer("Yes")).to eq(true)
      expect(normalize_answer("Y")).to eq(true)
    end

    it 'returns false for No and N' do
      expect(normalize_answer("No")).to eq(false)
      expect(normalize_answer("N")).to eq(false)
    end

    it 'returns nil for invalid answers' do
      expect(normalize_answer("Maybe")).to eq(nil)
      expect(normalize_answer("")).to eq(nil)
    end
  end

  describe '#calculate_ratings' do
    it 'calculates correct rating based on Yes answers' do
      answers = {
        "q1" => true,
        "q2" => false,
        "q3" => true,
        "q4" => false,
        "q5" => true
      }
      expect(calculate_ratings(answers)).to eq(60)
    end

    it 'handles no questions answered' do
      answers = {}
      expect(calculate_ratings(answers)).to eq(0)
    end
  end

  describe '#save_data' do
    it 'persists answers and ratings' do
      answers = {
        "q1" => true,
        "q2" => false
      }
      score = 50
      save_data(store, answers, score)

      store.transaction do
        expect(store[:answers].size).to eq(1)
        expect(store[:scores].size).to eq(1)
      end
    end
  end
end
