shared_examples_for "Streamed Response API" do

  subject do
    Rack::Client.new(@base_url, &method(:rackup))
  end

  it 'can properly chunk a streamed response' do
    response_body = %w[ this is a stream ]
    request   { get('/stream') }
    response do
      each {|part| part.should == response_body.shift }
    end
  end
end
