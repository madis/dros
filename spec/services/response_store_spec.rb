require 'spec_helper'
require 'services/response_store'
require 'tmpdir'

describe ResponseStore do
  def store_test_hash(hash)
    described_class.store(data: hash, args: 'greeting')
  end

  describe '.store' do
    it 'saves to disk' do
      Dir.mktmpdir do |tmpdir|
        allow(described_class).to receive(:tmp_path).and_return tmpdir
        test_object = { hello: 'world' }
        stored_file_path = store_test_hash(test_object)
        contents = File.read(stored_file_path)
        expect(JSON.parse(contents).deep_symbolize_keys).to eq(test_object)
      end
    end
  end

  describe '.retrieve' do
    it 'gets back same data as was put in' do
      Dir.mktmpdir do |tmpdir|
        allow(described_class).to receive(:tmp_path).and_return tmpdir
        example_data = { hello: 'world', number: 1 }
        ResponseStore.store data: example_data, method: :man, args: 100
        ResponseStore.store data: { should: 'not be found' }, method: :another, args: 100
        from_store = ResponseStore.retrieve method: :man, args: 100
        expect(from_store.deep_symbolize_keys).to eq example_data
      end
    end

    it 'is nil when file is not found' do
      expect(ResponseStore.retrieve(method: 'some_statistics', args: 'madis/dros')).to eq nil
    end
  end
end
