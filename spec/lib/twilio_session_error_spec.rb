require 'spec_helper'

describe TwilioSessionError do
  let!(:voice_file) { create :voice_file, short_name: 'rotting_sock' }

  subject(:error) { TwilioSessionError.new(:rotting_sock) }

  its(:voice_file) { should =~ %r|/audios/rotting_sock.mp3| }
end
