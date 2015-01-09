shared_examples 'return all items' do
  it 'returns all items' do
    expect(subject.fetch_for_index.count).to eq 3
    expect(subject.fetch_for_index).to include item_1
    expect(subject.fetch_for_index).to include item_2
    expect(subject.fetch_for_index).to include item_3
  end
end
