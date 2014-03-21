class QuestionPresenter < Struct.new(:row)
  def valid?
    to_voice_file.valid? && to_question.valid?
  end

  def to_question
    question = Question.find_or_initialize_by(short_name: row[:short_name])
    question.attributes = row
    question.voice_file = to_voice_file
    question
  end

  def to_voice_file
    voice_file = VoiceFile.find_or_initialize_by(short_name: row[:short_name])
    voice_file.attributes = voice_file_attributes
    voice_file
  end

  protected

  def voice_file_attributes
    {
      short_name: row[:short_name],
      url: row[:voice_file_url],
    }
  end
end
