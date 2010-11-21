shared_examples_for "Handler API" do

  context 'GET request' do
    it 'has the correct status code' do
      request   { get('/get/hello_world') }
      response  { status.should == 200 }
    end

    it 'has the correct headers' do
      request  { get('/get/hello_world') }
      response do
        %w[Content-Type Date Content-Length Connection].each do |header|
          headers.keys.include?(header).should == true
        end
      end
    end

    it 'has the correct body' do
      request   { get('/get/hello_world') }
      response  { body.should == 'Hello World!' }
    end
  end

  context 'DELETE request' do
    it 'can handle a No Content response' do
      request   { delete('/delete/no-content') }
      response  { body.should == '' }
    end
  end

  context 'HEAD request' do
    it 'can handle ETag headers' do
      request   { head('/head/etag') }
      response  { headers['ETag'].should == 'DEADBEEF' }
    end
  end
end
