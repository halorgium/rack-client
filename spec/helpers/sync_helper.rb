module SyncHelper
  def request(&b)
    @_response = subject.instance_eval(&b)
  end

  def response(&b)
    @_response.instance_eval(&b)
  end
end
