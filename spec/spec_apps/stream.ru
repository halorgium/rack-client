class SlowArray < Array
  def each
    super {|*a| sleep 0.1 ; yield(*a) }
  end
end

use Rack::Chunked # net/http is a POS

run lambda { [200, {}, SlowArray[*%w[ this is a stream ]]] }
