require 'spec_helper'

describe TwilioSessionError do
  subject(:error) { TwilioSessionError.new(:rotting_sock) }

  its(:voice_file) { should =~ %r|/audios/rotting_sock.mp3| }
end
