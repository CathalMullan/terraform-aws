{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "iamlive";
  version = "0.46.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "iann0036";
    repo = "iamlive";
    sha256 = "sha256-Kve7p8VYPiWR7Cwqt4Nejr7MlMyzdrVaHDMH3V3CHKE=";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/iann0036/iamlive";
    description = " Generate an IAM policy from AWS calls using client-side monitoring (CSM) or embedded proxy.";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ cmullan ];
    platforms = platforms.all;
  };
}
