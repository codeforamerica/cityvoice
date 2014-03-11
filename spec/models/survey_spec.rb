require 'spec_helper'

describe Survey do
  describe '.questions_for' do
    context 'when the survey is by neighborhood' do
      it 'returns a list of question types' do
        expect(Survey.questions_for('neighborhood')).to eq(%w[public_safety property_values neighborhood_comments])
      end
    end

    context 'when the survey is by property' do
      it 'returns a list of question types' do
        expect(Survey.questions_for('property')).to eq(%w[property_outcome property_comments])
      end
    end

    context 'when the survey is an i-wish-there-was' do
      it 'returns a question type' do
        expect(Survey.questions_for('iwtw')).to eq(%w[i_wish_comment])
      end
    end
  end
end
