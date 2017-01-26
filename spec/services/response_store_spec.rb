require 'spec_helper'
require 'services/response_store'
require 'tmpdir'

describe ResponseStore do
  def store_test_hash(hash)
    described_class.store(data: hash, args: 'greeting')
  end

  it 'stores responses' do
    Dir.mktmpdir do |tmpdir|
      allow(described_class).to receive(:tmp_path).and_return tmpdir
      stored_file_path = store_test_hash(hello: 'world')
      contents = File.read(stored_file_path)
      expect(JSON.parse(contents).deep_symbolize_keys).to eq(hello: 'world')
    end
  end
end
