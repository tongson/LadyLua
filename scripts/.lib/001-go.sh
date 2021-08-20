_go_os()
{
  local os
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  printf "%s" "${os}"
}
