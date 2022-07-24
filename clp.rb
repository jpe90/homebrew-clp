class Clp < Formula
  desc "command line syntax highlighter"
  homepage "https://github.com/jpe90/clp"
  url "https://github.com/jpe90/clp/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "9fa537da95d79fc22a0533ea4bc81affce8332725ddab34df0f031398a4bc0d8"
  license "MIT"

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "luajit"

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  def install
	luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.1/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

	resource("lpeg").stage do
      system "luarocks", "build", "lpeg", lua_path, "--tree=#{luapath}"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
	luaenv = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", luaenv)
  end
end
