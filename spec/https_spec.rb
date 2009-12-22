require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "requesting https" do
  context "from fortify.net" do
    it "returns the cipher" do
      begin
        response = Rack::Client.new.get("https://www.fortify.net/cgi/ssl_3.pl")
        response.should have_selector("li.cipheronstrong", :content => 'AES cipher, 256-bit key')
      rescue SocketError => e
        pending do
          raise ArgumentError, "Looks like you're offline"
        end
      end
    end
  end
end
