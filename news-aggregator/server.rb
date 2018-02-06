require "sinatra"
require "pry" if development? || test?
require "sinatra/reloader" if development?
require "csv"
require 'sinatra/flash'
enable :sessions

set :bind, '0.0.0.0'  # bind to all interfaces

get '/' do

  erb :index
end

get '/articles' do
  @articles = CSV.readlines('articles.csv')

  erb :articles

  # binding.pry
end

get '/articles/new' do

  erb :new_article
end

post '/articles/new' do
  article_title = params["article_title"]
  article_url = params["article_url"]
  article_description = params["article_description"]
  @articles = CSV.readlines('articles.csv')
  @articles.each do |article|
    if article.include?(article_url)
      flash[:notice] = "Error!! You Can't Triple Stamp a Double Stamp.  Someone has already entered that URL."
      @article_title = article_title
      @article_url = article_url
      @article_description = article_description
      erb :error
      redirect '/articles/new'

    else
      CSV.open("articles.csv", "ab") do |csv|
        csv << [article_title, article_url, article_description]
        redirect '/articles/new'
      end
    end
  end
end
