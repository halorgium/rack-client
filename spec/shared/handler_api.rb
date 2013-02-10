shared_examples_for "Handler API" do

  context 'GET request' do
    it 'has the correct status code' do
      request   { get('/get/hello_world') }
      response  { status.should == 200 }
    end

    it "handles multiple cookies according to Rack Specification" do
      request  { get('/cookie') }
      response do
        raw_status, raw_headers, raw_body = Cookie.new.call({"rack.input" => StringIO.new, "PATH_INFO"=>"", "REQUEST_METHOD"=>"GET"})
        headers["Set-Cookie"].should == raw_headers["Set-Cookie"]
      end
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

    it 'has the correct query string' do
      request   { get('/get/params?one=hello&two=goodbye') }
      response  { body.should == 'hello goodbye' }
    end
  end

  context 'POST request' do
    it 'can accept a string post body' do
      request  { post('/post/echo', {}, 'Hello, World!') }
      response { body.should == 'Hello, World!' }
    end

    it 'can accept an IO post body' do
      o,i = IO.pipe
      i << 'Hello, World!'
      i.close

      request  { post('/post/echo', {}, o) }
      response { body.should == 'Hello, World!' }
    end

    it 'can accept a body object that responds to each and yields strings' do
      b = ['Hello, ', 'World!']

      request  { post('/post/echo', {}, b) }
      response { body.should == 'Hello, World!' }
    end
  end

  context 'PUT request' do
    it 'can accept a string post body' do
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      request  { put('/put/sum', headers, 'a=1&b=2') }
      response { body.should == '3' }
    end

    it 'can accept an IO post body' do
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      o,i = IO.pipe
      i << 'a=3&b=4'
      i.close

      request  { put('/put/sum', headers, o) }
      response { body.should == '7' }
    end

    it 'can accept a body object that responds to each and yields strings' do
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      b = ['a=5', '&', 'b=6']

      request  { put('/put/sum', headers, b) }
      response { body.should == '11' }
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
