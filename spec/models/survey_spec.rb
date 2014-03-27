require 'spec_helper'

describe Survey do
  describe '.questions_for' do
    it 'returns a list of question types ordered by update time' do
      second_question = create(:question, :voice)
      first_question = create(:question, :voice)
      second_question.touch
      expect(Survey.questions_for).to eq([first_question, second_question])
    end
  end
end
