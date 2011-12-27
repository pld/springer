require 'cgi'
require 'json'
require 'net/http'
require 'result'
require 'uri'

class Springer
  # API to Springer search API
  # 
  # Example:
  #   >> Springer.new('[METADATA KEY]', '[IMAGES_KEY]', '[OPENACCESS_KEY]', '[Referer]').search('nano fibers')
  #   => [ #<Result:...>, ... ]
  #
  # Arguments:
  #   metadata_key: (String)
  #   images_key: (String)
  #   openaccess_key: (String)
  #   referer: (String)
  #   num_results: (Integer+)

  API_PATH = "http://api.springer.com/metadata/json"
  API_URI = URI.parse(API_PATH)

  attr_accessor :metadata_key, :images_key, :openaccess_key, :referer, :num_results

  def initialize(metadata_key, images_key='', openaccess_key='', referer='', num_results=50)
    @metadata_key = metadata_key
    @images_key = images_key
    @openaccess_key = openaccess_key
    @referer = referer
    @num_results = num_results < 100 ? num_results : 100
  end
  
  def search(query)
    api = API_URI
    api_call = Net::HTTP.new(api.host)
    params = "?p=#{@num_results}&q=#{CGI.escape(query)}&api_key=#{@metadata_key}"
    response = api_call.get2(api.path + params, { 'Referer' => @referer })
    return nil if response.class.superclass == Net::HTTPServerError
    response = JSON.parse(response.body)
    response['records'].map do |result|
      Result.new({
        :title => result['title'],
        :abstract => create_abstract(result),
        :url => result['url'],
        :date => result['publicationDate']
       })
    end
  end

  # TODO search images and openaccess apis
  
  def create_abstract(result)
    abstract = "#{result['publicationName']} &ndash; "
    result['creators'].each_with_index do |creator, i|
      abstract += " and" if i > 0
      abstract += " #{creator['creator']}"
    end
    return abstract
  end
end

