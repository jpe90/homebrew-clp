class Clp < Formula
  desc "command line syntax highlighter"
  homepage "https://github.com/jpe90/clp"
  url "https://github.com/jpe90/clp/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5f9a39439dd9fbc311096ceee165ef7d062d32a4e2b50d32193a967e1ee2795e"
  license "MIT"

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "luajit"

  resource("lpeg") do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  resource("luautf8") do
    url "https://luarocks.org/manifests/xavier-wang/luautf8-0.1.5-2.src.rock"
    sha256 "68bd8e3c3e20f98fceb9e20d5a7a50168202c22eb45b87eff3247a0608f465ae"
  end

  def install
    luapath = libexec / "vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.1/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

    resource("lpeg").stage do
      system("luarocks", "build", "lpeg", lua_path, "--tree=#{luapath}")
    end

    resource("luautf8").stage do
      system("luarocks", "build", "luautf8", lua_path, "--tree=#{luapath}")
    end

    system("./configure", "--prefix=#{prefix}")
    system("make", "install")
    luaenv = {LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"]}
    bin.env_script_all_files(libexec / "bin", luaenv)
  end
end
