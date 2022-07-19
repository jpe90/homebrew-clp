# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Clp < Formula
  desc "command line syntax highlighter"
  homepage "https://github.com/jpe90/clp"
  url "https://github.com/jpe90/clp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "4f0d189f350c9cb5ba3009dae005aadd95b34c7e0e4a77ffea812c246ea47b7d"
  license "MIT"

  # depends_on "cmake" => :build
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
      # system "luarocks" "--lua-dir=$(brew --prefix)/opt/lua@5.1", "build", "lpeg", "--tree=#{luapath}"
      system "luarocks", "build", "lpeg", lua_path, "--tree=#{luapath}"
    end

    # The path separator for `LUA_PATH` and `LUA_CPATH` is `;`.
    # ENV.prepend "LUA_PATH", buildpath/"deps-build/share/lua/5.1/?.lua", ";"
    # ENV.prepend "LUA_CPATH", buildpath/"deps-build/lib/lua/5.1/?.so", ";"
    # Don't clobber the default search path
    # ENV.append "LUA_PATH", ";", ";"
    # ENV.append "LUA_CPATH", ";", ";"
    # luapath = "--lua-dir=#{Formula["luajit"].opt_prefix}"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
	luaenv = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", luaenv)
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test clp`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
