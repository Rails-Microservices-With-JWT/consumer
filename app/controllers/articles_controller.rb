require 'net/http'

class ArticlesController < ApplicationController

  def index
    uri = URI.parse('http://localhost:3000/user_token')
    req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
    req.body = { auth: {email: 'admin@mail.com', password: 'securepassword'}}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end

    jwt_token = JSON.parse(res.body)['jwt']

    uri = URI.parse("http://localhost:3000/articles")
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      request.add_field("Authorization", "Bearer #{jwt_token}")
      response = http.request request
      render json: JSON.parse(response.body)
    end
  end
end
