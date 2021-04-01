return function()
  local T = require 'test'
  local H = require 'http'
  local R = H.request('GET', 'https://cloudflare.com', {
    timeout='30s',
    headers={ Accept='*/*'}
  })
  T['http.request GET'] = function()
    T.is_userdata(R)
    T.is_string(R.body)
    T.is_number(R.body_size)
    T.is_table(R.headers)
    T.is_table(R.cookies)
    T.is_number(R.status_code)
    T.is_string(R.url)
  end
end


