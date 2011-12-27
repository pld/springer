require 'test/unit'
require 'springer'

class SpringerTest < Test::Unit::TestCase
  # get an API key, http://dev.springer.com/
  TEST_KEY = '[YOUR SPRINGER META API KEY]'

  def test_set_key
    rg = Springer.new('valid-key')
    assert_equal 'valid-key', rg.metadata_key
  end

  def test_set_images
    rg = Springer.new('', 'images')
    assert_equal 'images', rg.images_key
  end

  def test_set_openacc
    rg = Springer.new('', '', 'open')
    assert_equal 'open', rg.openaccess_key
  end

  def test_set_referer
    rg = Springer.new('', '', '', 'ref')
    assert_equal 'ref', rg.referer
  end

  def test_set_num_results
    rg = Springer.new('', '', '', 'ref', 100)
    assert_equal 100, rg.num_results
  end

  def test_set_max_num_results
    rg = Springer.new('', '', '', 'ref', 500)
    assert_equal 100, rg.num_results
  end

  # requires internet connectivity
  def test_get_search_response
    # use a valid springer key to run test
    rg = Springer.new(TEST_KEY, '', '', 'example.com')
    assert_equal false, rg.search('nano fibers').empty?
  end

  # requires internet connectivity
  def test_get_num_search_response
    # use a valid springer key to run test
    rg = Springer.new(TEST_KEY, '', '', 'example.com', 10)
    assert_equal 10, rg.search('nano fibers').length
  end

  # requires internet connectivity
  # TODO test this 
  def test_return_nil_on_error
    # use a valid springer key to run test
    rg = Springer.new(TEST_KEY, '', '', 'example.com', 10)
  end
end

