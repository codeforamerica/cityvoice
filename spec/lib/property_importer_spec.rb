require 'spec_helper'

describe PropertyImporter do
  let(:invalid_header_content) { Rails.root.join('spec/support/fixtures/invalid_subject_headers.csv').read }
  let(:invalid_content) { Rails.root.join('spec/support/fixtures/invalid_subject.csv').read }
  let(:valid_content) { Rails.root.join('spec/support/fixtures/subject.csv').read }

  subject(:importer) { PropertyImporter.new(content) }

  describe '#has_valid_headers?' do
    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      it { should_not have_valid_headers }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      it { should have_valid_headers }
    end
  end

  describe '#valid?' do
    context 'when the content is invalid' do
      let(:content) { invalid_content }

      it { should_not be_valid }
    end

    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      it { should_not be_valid }
    end

    context 'when the content is valid' do
      let(:content) { valid_content }

      it { should be_valid }
    end
  end

  describe '#errors' do
    context 'when the headers are invalid' do
      let(:content) { invalid_header_content }

      its(:errors) { should include('Property code column is missing') }
    end

    context 'when the headers are valid' do
      let(:content) { valid_content }

      its(:errors) { should be_empty }
    end

    context 'when the content is not valid' do
      let(:content) { invalid_content }

      its(:errors) { should include("Property code can't be blank") }
    end
  end

  describe '#import' do
    context 'with all the required fields to create a property' do
      let(:content) { valid_content }

      it 'creates a property' do
        expect { importer.import }.to change { Property.count }.by(1)
      end

      describe 'the property' do
        before { importer.import }

        subject(:property) { Property.first }

        its(:name) { should == '1313 Mockingbird Lane' }
        its(:property_code) { should == '1313' }
        its(:lat) { should == '34.123382' }
        its(:long) { should == '-118.148664' }
      end
    end

    context 'when one of the fields required for a property is blank' do
      let(:content) { invalid_content }

      it 'does not create a property' do
        expect { importer.import }.to change(Property, :count).by(0)
      end
    end
  end

  describe '.import_file' do
    context 'with valid data' do
      it 'creates a property' do
        expect do
          PropertyImporter.import_file(Rails.root.join('spec/support/fixtures/subject.csv'))
        end.to change(Property, :count)
      end
    end

    context 'with invalid data' do
      it 'does not create a property' do
        expect do
          PropertyImporter.import_file(Rails.root.join('spec/support/fixtures/invalid_subject.csv'))
        end.not_to change(Property, :count)
      end
    end
  end
end
