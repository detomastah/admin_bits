require 'spec_helper'

describe Admin::ItemResource do
  let!(:item_1) { create(:item, name: 'item 1', price: 100) }
  let!(:item_2) { create(:item, name: 'item 2', price: 150) }
  let!(:item_3) { create(:item, name: 'item 3', price: 50) }

  subject { described_class.new(params) }

  describe '.fetch_for_index' do

    describe 'without params' do
      let(:params) { {} }

      include_examples 'return all items'

      it 'returns elements in default order' do
        expect(subject.fetch_for_index.first).to eq item_3
        expect(subject.fetch_for_index.last).to eq item_2
      end
    end

    describe 'ordering' do
      its 'class includes ActiveRecordSort' do
        expect(described_class.ancestors).to include AdminBits::ActiveRecordSort
      end

      context 'by_name asc' do
        let(:params) {{ 'asc'=>'true', 'order'=>'by_name' }}

        include_examples 'return all items'

        it 'returns elements in default order' do
          expect(subject.fetch_for_index.first).to eq item_1
          expect(subject.fetch_for_index.last).to eq item_3
        end
      end

      context 'by_name desc' do
        let(:params) {{ 'asc'=>'false', 'order'=>'by_name' }}

        include_examples 'return all items'

        it 'returns elements in default order' do
          expect(subject.fetch_for_index.first).to eq item_3
          expect(subject.fetch_for_index.last).to eq item_1
        end
      end
    end

    describe 'filters' do
      describe '.having_name' do
        context 'without params' do
          let(:params) { {} }

          it "doesn't call having_name method" do
            expect(subject).to_not receive(:having_name)
            subject.fetch_for_index
          end
        end

        context 'with empty filters params' do
          let(:params) {{ 'filters' => { 'having_name'=>'' }}}

          it "doesn't call having_name method" do
            expect(subject).to_not receive(:having_name)
            subject.fetch_for_index
          end
        end

        context 'with empty two two-dimensional filters params' do
          let(:params) {{ 'filters' => { 'having_name'=> { 'a' => '' } }}}

          it "doesn't call having_name method" do
            expect(subject).to_not receive(:having_name)
            subject.fetch_for_index
          end
        end

        context 'with present filters params' do
          let(:params) {{ 'filters' => { 'having_name'=>'3' }}}

          it 'returns proper items' do
            expect(subject.fetch_for_index).to eq [item_3]
          end
        end

        context 'with present two two-dimensional filters params' do
          let(:params) {{ 'filters' => { 'having_name'=> { 'a' => 'a' } }}}

          it "call having_name method" do
            subject.stub(:having_name) { subject.resource }
            expect(subject).to receive(:having_name)
            subject.fetch_for_index
          end
        end
      end
    end
  end
end


