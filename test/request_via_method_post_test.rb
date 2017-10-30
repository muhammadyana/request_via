require "test_helper"

class RequestViaMethodPostTest < Minitest::Test
  Http = -> url { "http://#{url}" }
  Https = -> url { "https://#{url}" }

  EXAMPLE_COM = 'example.com'
  WWW_EXAMPLE_COM = "www.#{EXAMPLE_COM}"

  def test_request_without_protocol
    assertion = Support::Assertions::RequestWithoutProtocol.new(self)
    assertion.(:post, protocol_to_request: 'http')
  end

  def test_response_and_request_option
    assertion = Support::Assertions::ResponseAndRequestOption.new(self)
    assertion.(:post, protocol_to_request: 'http')
    assertion.(:post, protocol_to_request: 'https')
  end

  def test_post_request
    # Without params
    stub_request(:post, Http.(EXAMPLE_COM))
    stub_request(:post, Https.(EXAMPLE_COM))

    res1 = RequestVia::Post.(Http.(EXAMPLE_COM))
    res2 = RequestVia::Post.(Https.(EXAMPLE_COM))

    assert_equal '200', res1.code
    assert_equal '200', res2.code

    # With params
    stub_request(:post, Https.(WWW_EXAMPLE_COM)).with(body: {'a' => '1'})

    res3 = RequestVia::Post.(Https.(WWW_EXAMPLE_COM), params: { a: '1' } )

    assert_equal '200', res3.code

    # With headers
    stub_request(:post, Https.(WWW_EXAMPLE_COM)).with(headers: {'Accept' => 'image/png' })

    res4 = RequestVia::Post.(Https.(WWW_EXAMPLE_COM), headers: { 'Accept' => 'image/png' } )

    assert_equal '200', res4.code

    # With headers and params
    stub_request(:post, Https.(WWW_EXAMPLE_COM)).with(
      headers: {'Accept' => 'image/png' }, body: {'a' => '2'}
    )

    res4 = RequestVia::Post.(
      Https.(WWW_EXAMPLE_COM),
      headers: { 'Accept' => 'image/png' },
      params: { 'a' => 2 }
    )

    assert_equal '200', res4.code
  end
end