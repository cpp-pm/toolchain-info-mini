require 'formula'

class HunterToolchainInfo < Formula
  version '0.0.1'

  homepage 'https://github.com/hunter-packages/toolchain-info-mini'
  url 'https://github.com/hunter-packages/toolchain-info-mini.git', :branch => 'master'

  devel do
    version '0.0.1'
    url 'https://github.com/hunter-packages/toolchain-info-mini.git', :branch => 'master'
  end

  depends_on 'cmake' => :build

  def install
    args = *std_cmake_args

    if build.with? "debug"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    args << "-DHUNTER_STATUS_DEBUG=ON"

    system "cmake", *args
    system "make"
    system "make", "install"

  end
end
