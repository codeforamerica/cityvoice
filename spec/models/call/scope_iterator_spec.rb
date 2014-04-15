require 'spec_helper'

describe Call::ScopeIterator do
  let(:relation) { [:geese] }
  let(:index) { '0' }

  subject(:iterator) { Call::ScopeIterator.new(relation, index) }

  its(:current) { should == :geese }
  its(:next_index) { should == 1 }

  describe '#empty?' do
    context 'when there are elements in the relation' do
      it { should_not be_empty }
    end

    context 'when the relation is empty' do
      let(:relation) { [] }

      it { should be_empty }
    end
  end

  describe '#has_more?' do
    context 'when not at the end of the relation' do
      it { should have_more }
    end

    context 'when at the end of the relation' do
      let(:index) { '1' }

      it { should_not have_more }
    end
  end
end
