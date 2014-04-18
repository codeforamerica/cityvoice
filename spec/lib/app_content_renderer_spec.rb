require 'spec_helper'

describe AppContentRenderer do
  let(:content_path) { Rails.root.join('spec', 'support', 'fixtures', 'app_content.md') }
  let(:updated_content_path) { Rails.root.join('spec', 'support', 'fixtures', 'app_content_changed.md') }
  let(:memoized) { true }

  subject(:renderer) { AppContentRenderer.new(content_path, memoized) }

  describe '#rendered' do
    its(:rendered) { should == "<p>Hi there!</p>\n" }
    its(:rendered) { should be_html_safe }

    context 'after rendering happens once' do
      before do
        renderer.rendered
        renderer.path = updated_content_path
      end

      context 'when memoizing' do
        let(:memoized) { true }

        its(:rendered) { should == "<p>Hi there!</p>\n" }
      end

      context 'when not memoizing' do
        let(:memoized) { false }

        its(:rendered) { should == "<p>I&#39;m different, too!</p>\n" }
      end
    end
  end

  describe '.renderer_for' do
    it 'creates a renderer with a markdown path inside data' do
      renderer = AppContentRenderer.renderer_for(:tacos)
      expect(renderer.path).to eq(Rails.root.join('data', 'tacos.md'))
    end

    it 'sets the memoization mode with a test for production mode' do
      renderer = AppContentRenderer.renderer_for(:meats)
      expect(renderer.memoize).to eq(false)

      Rails.env.stub(production?: true)
      renderer = AppContentRenderer.renderer_for(:meats)
      expect(renderer.memoize).to eq(true)
    end
  end
end
