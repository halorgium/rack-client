require 'spec_helper'

describe Rack::Client::Response do
  context "#initialize" do
    it 'follows the rack tuple convention for parameters' do
      response = Rack::Client::Response.new(200, {'X-Foo' => 'Bar'}, ['Hello World!'])

      expect(response.status).to eq(200)
      expect(response.headers['X-Foo']).to eq('Bar')
      expect(response.body).to eq(['Hello World!'])
    end

    it 'accepts a callback for streamed responses' do
      body = %w[ This is a streamed response ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each do |part|
        expect(part).to eq(check.shift)
      end

      expect(check).to be_empty
    end
  end

  context "#each" do
    it 'will not loose the streamed body chunks' do
      body = %w[ This is also a streamed response ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each {|chunk| }

      expect(response.instance_variable_get(:@body)).to eq(check)
    end

    it 'will yield the existing body before the streamed body' do
      existing, streamed = %w[ This is mostly ], %w[ a streamed response ]
      check = existing + streamed

      response = Rack::Client::Response.new(200, {}, existing) {|block| streamed.each(&block) }

      response.each do |part|
        expect(part).to eq(check.shift)
      end

      expect(check).to be_empty
    end

    it 'is idempotent' do
      body = %w[ This should only appear once ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      response.each {|chunk| }

      expect(response.instance_variable_get(:@body)).to eq(check)

      response.each {|chunk| }

      expect(response.instance_variable_get(:@body)).to eq(check)
    end
  end

  context '#body' do
    it 'will include the body stream' do
      body = %w[ This is sorta streamed ]
      check = body.dup

      response = Rack::Client::Response.new(200) {|block| body.each(&block) }

      expect(response.body).to eq(check)
    end
  end
end
