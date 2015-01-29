require 'spec_helper'

describe Admin::RawResource do
  subject { described_class.new(params) }

  before do
    clear_resource_class_variables(described_class)
  end

  describe '.fetch_for_index' do
    describe 'without params' do
      let(:params) { {} }

      context 'without using ordering class method' do
        it 'returns raw resource' do
          expect(subject.fetch_for_index).to eq subject.resource
        end
      end

      context 'with specified default order' do
        before { described_class.ordering :plain, default: { plain: :asc }}

        it 'returns resource in specified order' do
          expect(subject.fetch_for_index).to eq subject.resource.sort
        end
      end
    end

    describe 'with ordering params' do
      let(:params) {{ 'order'=>'plain', 'asc'=>'false' }}

      context 'without using ordering class method' do
        it 'raise error' do
          expect { subject.fetch_for_index }.to raise_error
        end
      end

      context 'with specified ordering methods' do
        before { described_class.ordering :plain }

        it 'returns resource in specified order' do
          expect(subject.fetch_for_index).to eq subject.resource.sort.reverse
        end
      end
    end

    describe 'with filter params' do
      before { described_class.filters :even_numbers }

      context 'present filter params' do
        let(:params) {{ 'filters' => { 'even_numbers' => 'true' }}}

        it 'filters resource' do
          expect(subject.fetch_for_index).to eq subject.resource.select(&:even?)
        end
      end

      context 'empty filter params' do
        let(:params) {{ 'filters' => { 'even_numbers' => '' }}}

        it 'returns raw resource' do
          expect(subject.fetch_for_index).to eq subject.resource
        end
      end
    end
  end
end

def clear_resource_class_variables(klass)
  variables = [:@ordering_methods, :@filter_methods, :@default_order]
  variables.each do |variable|
    if klass.instance_variable_get(variable)
      klass.remove_instance_variable(variable)
    end
  end
end
