require 'spec_helper'

describe Rack::Client::Response do
  context "#initialize" do
    it 'follows the rack tuple convention for parameters' do
      response = Rack::Client::Response.new(200, {'X-Foo' => 'Bar'}, ['Hello World!'])

      response.status.should == 200
      response.headers['X-Foo'].should == 'Bar'
      response.body.should == ['Hello World!']
    end

    it 'accepts a callback for streamed responses' do
      body = %w[ This is a streamed response ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each do |part|
        part.should == check.shift
      end

      check.should be_empty
    end
  end

  context "#each" do
    it 'will not loose the streamed body chunks' do
      body = %w[ This is also a streamed response ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each {|chunk| }

      response.instance_variable_get(:@body).should == check
    end

    it 'will yield the existing body before the streamed body' do
      existing, streamed = %w[ This is mostly ], %w[ a streamed response ]
      check = existing + streamed

      response = Rack::Client::Response.new(200, {}, existing) {|block| streamed.each(&block) }

      response.each do |part|
        part.should == check.shift
      end

      check.should be_empty
    end

    it 'is idempotent' do
      body = %w[ This should only appear once ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each {|chunk| }

      response.instance_variable_get(:@body).should == check

      response.each {|chunk| }

      response.instance_variable_get(:@body).should == check
    end
  end

  context '#body' do
    it 'will include the body stream' do
      body = %w[ This is sorta streamed ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.body.should == check
    end

    it 'will close body after loading' do
      body = Rack::BodyProxy.new(%w[ Should get closed ]) { }

      response = Rack::Client::Response.new(200, {}, body)

      response.body

      body.should be_closed
    end
  end
end
