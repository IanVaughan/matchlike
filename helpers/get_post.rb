# helpers do

  def get_post(url, &block)
    get url, &block
    post url, &block
  end

# end
