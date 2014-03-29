require 'spec_helper'

describe 'import rake task' do
  before do
    Rake.application.rake_require 'tasks/import'
    Rake::Task.define_task(:environment)
  end

  describe 'import:locations' do
    before do
      Rake::Task['import:locations'].reenable
    end

    def run_rake_task(path = nil)
      Rake.application.invoke_task("import:locations[#{path}]")
    end

    context 'when we pass in a file' do
      context 'when there are no errors' do
        let(:content_path) { Rails.root.join('spec/support/fixtures/location.csv') }

        it 'imports that file' do
          expect { run_rake_task(content_path) }.to change(Location, :count).by(1)
        end
      end

      context 'when there are errors' do
        let(:content_path) { Rails.root.join('spec/support/fixtures/invalid_location.csv') }

        it 'prints the errors' do
          expect(Kernel).to receive(:puts).with("Line 2: Name can't be blank")
          run_rake_task(content_path)
        end
      end
    end

    context 'when no file is passed in' do
      it 'imports the example' do
        expect { run_rake_task }.to change(Location, :count).by(3)
      end
    end
  end

  describe 'import:quesitons' do
    before do
      Rake::Task['import:questions'].reenable
    end

    def run_rake_task(path = nil)
      Rake.application.invoke_task("import:questions[#{path}]")
    end

    context 'when we pass in a file' do
      context 'when there are no errors' do
        let(:content_path) { Rails.root.join('spec/support/fixtures/question.csv') }

        it 'imports that file' do
          expect { run_rake_task(content_path) }.to change(Question, :count).by(1)
        end
      end

      context 'when there are errors' do
        let(:content_path) { Rails.root.join('spec/support/fixtures/invalid_question.csv') }

        it 'prints the errors' do
          expect(Kernel).to receive(:puts).with("Line 2: Feedback type can't be blank")
          run_rake_task(content_path)
        end
      end
    end

    context 'when no file is passed in' do
      it 'imports the example' do
        expect { run_rake_task }.to change(Question, :count).by(2)
      end
    end
  end
end
