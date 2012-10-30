require 'spec_helper'

describe Sdbport do
  before do
    @mock = mock
    @domain = Sdbport::Domain.new :args1 => 'val1'
  end

  it "should call domain_import from the given input" do
    Sdbport::Domain::Import.should_receive(:new).
                            with(:args1 => 'val1').
                            and_return @mock
    @mock.should_receive(:import).with('/tmp/file').
          and_return true
    @domain.import('/tmp/file').should be_true
  end

  it "should call export from the given output" do
    Sdbport::Domain::Export.should_receive(:new).
                            with(:args1 => 'val1').
                            and_return @mock
    @mock.should_receive(:export).with('/tmp/file').
          and_return true
    @domain.export('/tmp/file').should be_true
  end

  it "should call export_sequential_write with the given output" do
    Sdbport::Domain::Export.should_receive(:new).
                            with(:args1 => 'val1').
                            and_return @mock
    @mock.should_receive(:export_sequential_write).with('/tmp/file').
          and_return true
    @domain.export_sequential_write('/tmp/file').should be_true
  end

  it "should call domain_purge" do
    Sdbport::Domain::Purge.stub :new => @mock
    @mock.should_receive(:purge).and_return true
    @domain.purge.should be_true
  end

  it "should call domain_destroy" do
    Sdbport::Domain::Destroy.stub :new => @mock
    @mock.should_receive(:destroy).and_return true
    @domain.destroy.should be_true
  end

end
