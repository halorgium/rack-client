class SlowArray < Array
  def each
    super {|*a| sleep 0.1 ; yield(*a) }
  end
end

run lambda { [200, {}, SlowArray[*%w[ this is a stream ]]] }
